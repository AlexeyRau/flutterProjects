import requests
import base64
import os
from datetime import datetime
from tkinter import Tk, filedialog, messagebox
from getpass import getpass  # Для скрытого ввода токена

def load_config():
    """Загружает конфигурацию (токен вводится вручную)"""
    print("🔐 Введите данные для доступа к GitHub:")
    token = getpass("GitHub Token (скрыт при вводе): ").strip()
    repo_owner = input("Ваш GitHub username: ").strip()
    repo_name = input("Название репозитория: ").strip()
    csv_path = input("Путь к CSV файлу (например, lectures.csv): ").strip() or "lectures.csv"
    
    return {
        "GITHUB_TOKEN": token,
        "REPO_OWNER": repo_owner,
        "REPO_NAME": repo_name,
        "CSV_PATH": csv_path
    }

def select_md_file():
    """Открывает проводник для выбора .md файла"""
    root = Tk()
    root.withdraw()
    root.attributes('-topmost', True)
    return filedialog.askopenfilename(
        title="Выберите файл лекции (.md)",
        filetypes=[("Markdown files", "*.md")]
    )

def create_initial_csv(config):
    """Создаёт CSV файл с заголовками"""
    url = f"https://api.github.com/repos/{config['REPO_OWNER']}/{config['REPO_NAME']}/contents/{config['CSV_PATH']}"
    headers = {
        "Authorization": f"token {config['GITHUB_TOKEN']}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    response = requests.put(
        url,
        headers=headers,
        json={
            "message": "Создание файла lectures.csv",
            "content": base64.b64encode("Дата,Название лекции,Содержание лекции\n".encode()).decode()
        }
    )
    return response.status_code == 201

def get_current_csv(config):
    """Получает текущий CSV из GitHub"""
    response = requests.get(
        f"https://api.github.com/repos/{config['REPO_OWNER']}/{config['REPO_NAME']}/contents/{config['CSV_PATH']}",
        headers={"Authorization": f"token {config['GITHUB_TOKEN']}"}
    )
    return base64.b64decode(response.json()["content"]).decode() if response.status_code == 200 else None

def update_csv_on_github(config, new_content):
    """Обновляет CSV на GitHub"""
    current_file = requests.get(
        f"https://api.github.com/repos/{config['REPO_OWNER']}/{config['REPO_NAME']}/contents/{config['CSV_PATH']}",
        headers={"Authorization": f"token {config['GITHUB_TOKEN']}"}
    ).json()
    
    response = requests.put(
        f"https://api.github.com/repos/{config['REPO_OWNER']}/{config['REPO_NAME']}/contents/{config['CSV_PATH']}",
        headers={"Authorization": f"token {config['GITHUB_TOKEN']}"},
        json={
            "message": "Добавлена новая лекция",
            "content": base64.b64encode(new_content.encode()).decode(),
            "sha": current_file.get("sha", "")
        }
    )
    return response.status_code == 200

def add_lecture():
    """Основная функция"""
    config = load_config()
    
    if not (md_path := select_md_file()):
        messagebox.showerror("Ошибка", "Файл не выбран!")
        return
    
    try:
        date = input("Дата лекции (ГГГГ-ММ-ДД): ").strip()
        datetime.strptime(date, "%Y-%m-%d")  # Валидация даты
        name = input("Название лекции: ").strip()
        
        with open(md_path, "r", encoding="utf-8") as f:
            content = f.read().replace('"', '""')
            
        csv_content = get_current_csv(config) or "Дата,Название лекции,Содержание лекции\n"
        
        if update_csv_on_github(config, csv_content + f'"{date}","{name}","{content}"\n'):
            messagebox.showinfo("Успех", "✅ Лекция добавлена!")
        else:
            messagebox.showerror("Ошибка", "Не удалось обновить CSV на GitHub")
            
    except ValueError:
        messagebox.showerror("Ошибка", "Неверный формат даты! Используйте ГГГГ-ММ-ДД.")
    except Exception as e:
        messagebox.showerror("Ошибка", f"Не удалось обработать файл:\n{e}")

if __name__ == "__main__":
    add_lecture()

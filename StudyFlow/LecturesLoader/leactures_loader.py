import requests
import base64
import os
from datetime import datetime
from tkinter import Tk, filedialog 
from tkinter import messagebox 

GITHUB_TOKEN = input("Введите ваш GitHub Token: ")
print("Токен получен!")
REPO_OWNER = "AlexeyRau"
REPO_NAME = "lectures_base"
CSV_PATH = "lectures.csv"

def select_md_file():
    """Открывает проводник для выбора .md файла"""
    root = Tk()
    root.withdraw()
    root.attributes('-topmost', True)
    
    file_path = filedialog.askopenfilename(
        title="Выберите файл лекции (.md)",
        filetypes=[("Markdown files", "*.md"), ("All files", "*.*")]
    )
    return file_path if file_path else None

def create_initial_csv():
    """Создаёт CSV файл с заголовками"""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{CSV_PATH}"
    headers = {
        "Authorization": f"token {GITHUB_TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    initial_content = "Дата,Название лекции,Содержание лекции\n"
    encoded_content = base64.b64encode(initial_content.encode("utf-8")).decode("utf-8")
    
    data = {
        "message": "Создание файла lectures.csv",
        "content": encoded_content
    }
    
    response = requests.put(url, headers=headers, json=data)
    return response.status_code == 201

def get_current_csv():
    """Получает текущий CSV из GitHub"""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{CSV_PATH}"
    headers = {"Authorization": f"token {GITHUB_TOKEN}"}
    
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        content = base64.b64decode(response.json()["content"]).decode("utf-8")
        return content
    return None

def update_csv_on_github(new_content):
    """Обновляет CSV на GitHub"""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{CSV_PATH}"
    headers = {"Authorization": f"token {GITHUB_TOKEN}"}

    current_file = requests.get(url, headers=headers).json()
    sha = current_file.get("sha", "")
    
    encoded_content = base64.b64encode(new_content.encode("utf-8")).decode("utf-8")
    
    data = {
        "message": "Добавлена новая лекция",
        "content": encoded_content,
        "sha": sha
    }
    
    response = requests.put(url, headers=headers, json=data)
    return response.status_code == 200

def add_lecture():
    """Основная функция"""
    print("\nДобавление новой лекции")
    print("-" * 30)
    
    md_path = select_md_file()
    if not md_path:
        print("❌ Файл не выбран!")
        return
    
    date = input("Дата лекции (ГГГГ-ММ-ДД): ").strip()
    try:
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        messagebox.showerror("Ошибка", "Неверный формат даты! Используйте ГГГГ-ММ-ДД.")
        return
    
    name = input("Название лекции: ").strip()
    if not name:
        messagebox.showerror("Ошибка", "Название лекции не может быть пустым!")
        return
    
    try:
        with open(md_path, "r", encoding="utf-8") as f:
            content = f.read().replace('"', '""')
    except Exception as e:
        messagebox.showerror("Ошибка", f"Не удалось прочитать файл:\n{e}")
        return
    
    csv_content = get_current_csv()
    if csv_content is None:
        if not create_initial_csv():
            messagebox.showerror("Ошибка", "Не удалось создать CSV файл!")
            return
        csv_content = "Дата,Название лекции,Содержание лекции\n"
    
    new_row = f'"{date}","{name}","{content}"\n'
    
    if update_csv_on_github(csv_content + new_row):
        messagebox.showinfo("Успех", "✅ Лекция добавлена!")
    else:
        messagebox.showerror("Ошибка", "Не удалось обновить CSV на GitHub")

if __name__ == "__main__":
    add_lecture()
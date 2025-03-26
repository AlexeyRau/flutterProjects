import json
import base64
from datetime import datetime
from tkinter import Tk, filedialog, messagebox, simpledialog
from tkinter.ttk import Combobox
from getpass import getpass
import requests

# Конфигурация
REPO_OWNER = "AlexeyRau"
REPO_NAME = "lectures_base"
JSON_PATH = "lectures.json"
SUBJECTS = ["ОАИП", "Математика", "Физика", "Программирование", "Другое"]

class LectureApp:
    def __init__(self):
        self.root = Tk()
        self.root.withdraw()

    def select_md_file(self):
        """Выбор файла через проводник"""
        return filedialog.askopenfilename(
            title="Выберите файл лекции",
            filetypes=[("Markdown", "*.md"), ("Все файлы", "*.*")]
        )

    def select_subject(self):
        """Диалог выбора предмета"""
        dialog = Tk()
        dialog.title("Выбор предмета")
        dialog.geometry("300x100")
        
        label = simpledialog.Label(dialog, text="Выберите предмет:")
        label.pack(pady=5)
        
        combo = Combobox(dialog, values=SUBJECTS, state="readonly")
        combo.pack(pady=5)
        combo.set(SUBJECTS[0])
        
        def confirm():
            dialog.result = combo.get()
            dialog.destroy()
        
        simpledialog.Button(dialog, text="OK", command=confirm).pack()
        dialog.wait_window()
        return getattr(dialog, 'result', None)

    def get_lecture_metadata(self):
        """Ввод метаданных лекции"""
        subject = self.select_subject()
        if not subject:
            return None

        date = simpledialog.askstring("Дата", "Дата лекции (ГГГГ-ММ-ДД):")
        if not date:
            return None
        try:
            datetime.strptime(date, "%Y-%m-%d")
        except ValueError:
            messagebox.showerror("Ошибка", "Некорректный формат даты!")
            return None

        title = simpledialog.askstring("Название", "Название лекции:")
        if not title:
            return None

        return {
            "subject": subject,
            "date": date,
            "title": title
        }

    def upload_to_github(self, token, lectures):
        """Загрузка данных на GitHub"""
        url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{JSON_PATH}"
        headers = {"Authorization": f"token {token}"}

        # Получаем текущий SHA
        response = requests.get(url, headers=headers)
        sha = response.json().get("sha", "") if response.status_code == 200 else ""

        data = {
            "message": f"Добавлена лекция по {lectures[-1]['subject']}",
            "content": base64.b64encode(
                json.dumps(lectures, indent=2, ensure_ascii=False).encode()
            ).decode(),
            "sha": sha
        }

        response = requests.put(url, headers=headers, json=data)
        return response.status_code in (200, 201)

    def run(self):
        """Основной цикл приложения"""
        token = input("GitHub Token: ")
        if not token:
            return

        # Выбор файла
        md_path = self.select_md_file()
        if not md_path:
            return

        # Ввод метаданных
        metadata = self.get_lecture_metadata()
        if not metadata:
            return

        # Чтение содержимого
        try:
            with open(md_path, "r", encoding="utf-8") as f:
                content = f.read()
        except Exception as e:
            messagebox.showerror("Ошибка", f"Ошибка чтения файла:\n{e}")
            return

        # Формирование лекции
        new_lecture = {
            "id": f"{metadata['subject'].lower()}-{datetime.now().timestamp()}",
            **metadata,
            "content": content,
            "created_at": datetime.now().isoformat(),
            "updated_at": datetime.now().isoformat()
        }

        # Загрузка существующих данных
        try:
            url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{JSON_PATH}"
            response = requests.get(url, headers={"Authorization": f"token {token}"})
            
            if response.status_code == 200:
                lectures = json.loads(base64.b64decode(response.json()["content"]))
            else:
                lectures = []
        except Exception as e:
            messagebox.showerror("Ошибка", f"Ошибка загрузки лекций:\n{e}")
            return

        # Добавление и сохранение
        lectures.append(new_lecture)
        
        if self.upload_to_github(token, lectures):
            messagebox.showinfo("Успех", "Лекция успешно добавлена!")
        else:
            messagebox.showerror("Ошибка", "Не удалось сохранить лекции")

if __name__ == "__main__":
    app = LectureApp()
    app.run()
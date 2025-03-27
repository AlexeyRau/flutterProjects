import json
import base64
import os
from datetime import datetime
from tkinter import Tk, Listbox, Button, Label, messagebox, filedialog, simpledialog
from tkinter.ttk import Combobox
import requests

REPO_OWNER = "AlexeyRau"
REPO_NAME = "lectures_base"
JSON_PATH = "lectures.json"
SUBJECTS = ["ОАИП", "Математика", "Физика", "Программирование", "Другое"]

class LectureManager:
    def __init__(self, root):
        self.root = root
        self.root.title("Менеджер лекций")
        self.root.geometry("600x400")
        
        self.token = None
        self.lectures = []
        
        self.setup_ui()
        self.load_token()
        self.refresh_lectures()

    def setup_ui(self):
        """Создание интерфейса"""
        self.listbox = Listbox(self.root, width=80, height=15)
        self.listbox.pack(pady=10)
        
        Button(self.root, text="Добавить лекцию", command=self.add_lecture).pack(side="left", padx=10)
        Button(self.root, text="Удалить лекцию", command=self.delete_lecture).pack(side="left", padx=10)
        Button(self.root, text="Обновить список", command=self.refresh_lectures).pack(side="left", padx=10)
        Button(self.root, text="Показать содержание", command=self.show_content).pack(side="left", padx=10)

    def load_token(self):
        """Загрузка токена"""
        self.token = simpledialog.askstring("GitHub Token", "Введите ваш GitHub Token:", parent=self.root)
        if not self.token:
            messagebox.showwarning("Предупреждение", "Токен не введен, некоторые функции недоступны")

    def fetch_lectures(self):
        """Загрузка лекций с GitHub"""
        if not self.token:
            return []
        
        url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{JSON_PATH}"
        headers = {"Authorization": f"token {self.token}"}
        
        try:
            response = requests.get(url, headers=headers)
            if response.status_code == 200:
                content = base64.b64decode(response.json()["content"]).decode("utf-8")
                return json.loads(content)
            return []
        except Exception as e:
            messagebox.showerror("Ошибка", f"Не удалось загрузить лекции: {e}")
            return []

    def refresh_lectures(self):
        """Обновление списка лекций"""
        self.lectures = self.fetch_lectures()
        self.listbox.delete(0, "end")
        
        for lecture in self.lectures:
            display_text = f"{lecture['date']} | {lecture['subject']} | {lecture['title']}"
            self.listbox.insert("end", display_text)

    def add_lecture(self):
        """Добавление новой лекции"""
        if not self.token:
            messagebox.showerror("Ошибка", "Токен не введен!")
            return
        
        filepath = filedialog.askopenfilename(filetypes=[("Markdown", "*.md")])
        if not filepath:
            return
        
        title = os.path.splitext(os.path.basename(filepath))[0]
        
        subject = self.select_subject()
        if not subject:
            return
        
        date = simpledialog.askstring("Дата", "Дата лекции (ГГГГ-ММ-ДД):", parent=self.root)
        if not date:
            return
        try:
            datetime.strptime(date, "%Y-%m-%d")
        except ValueError:
            messagebox.showerror("Ошибка", "Некорректный формат даты!")
            return
        
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
        except Exception as e:
            messagebox.showerror("Ошибка", f"Ошибка чтения файла: {e}")
            return
        
        new_lecture = {
            "id": f"{datetime.now().timestamp()}",
            "subject": subject,
            "date": date,
            "title": title,
            "content": content,
            "created_at": datetime.now().isoformat()
        }
        
        self.lectures.append(new_lecture)
        self.save_lectures()
        self.refresh_lectures()

    def delete_lecture(self):
        """Удаление выбранной лекции"""
        selection = self.listbox.curselection()
        if not selection:
            messagebox.showwarning("Предупреждение", "Лекция не выбрана")
            return
        
        if messagebox.askyesno("Подтверждение", "Удалить выбранную лекцию?"):
            del self.lectures[selection[0]]
            self.save_lectures()
            self.refresh_lectures()

    def show_content(self):
        """Показать содержание выбранной лекции"""
        selection = self.listbox.curselection()
        if not selection:
            return
        
        content = self.lectures[selection[0]]["content"]
        messagebox.showinfo("Содержание", content[:1000] + "..." if len(content) > 1000 else content)

    def select_subject(self):
        """Выбор предмета"""
        dialog = Tk()
        dialog.title("Выбор предмета")
        dialog.geometry("300x150")
        
        Label(dialog, text="Выберите предмет:").pack(pady=10)
        
        combo = Combobox(dialog, values=SUBJECTS, state="readonly")
        combo.pack(pady=5)
        combo.set(SUBJECTS[0])
        
        result = []
        Button(dialog, text="OK", command=lambda: [result.append(combo.get()), dialog.destroy()]).pack()
        
        dialog.wait_window()
        return result[0] if result else None

    def save_lectures(self):
        """Сохранение лекций на GitHub"""
        if not self.token:
            return False
        
        url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents/{JSON_PATH}"
        headers = {"Authorization": f"token {self.token}"}
        
        response = requests.get(url, headers=headers)
        sha = response.json().get("sha", "") if response.status_code == 200 else ""
        
        data = {
            "message": "Обновление списка лекций",
            "content": base64.b64encode(
                json.dumps(self.lectures, indent=2, ensure_ascii=False).encode()
            ).decode(),
            "sha": sha
        }
        
        try:
            response = requests.put(url, headers=headers, json=data)
            if response.status_code not in (200, 201):
                messagebox.showerror("Ошибка", f"Ошибка сохранения: {response.text}")
                return False
            return True
        except Exception as e:
            messagebox.showerror("Ошибка", f"Не удалось сохранить: {e}")
            return False

if __name__ == "__main__":
    root = Tk()
    app = LectureManager(root)
    root.mainloop()
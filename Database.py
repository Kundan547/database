"""
# Database.py TASK - 

The task is to create a Database-driven Employee Management System in Python that will store the information in the MySQL Database. The script will contain the following operations :

For user interfaces, frontends use TKinter Library.

1.Add Employee
2.Remove Employee
3.Promote Employee
4.Display Employees

"The idea is that we perform different changes in our employee record by using different functions. For example, the Add Employee function will insert a new row in our Employee table. We will also create a Remove Employee function, which will delete the record of any particular existing employee in our Employee table. This system works on the concepts of taking the information from the database, making the required changes to the fetched data, and applying the changes to the record, which we will see in our Promote Employee System. We can also have information about all the existing employees by using the Display Employee function. The main advantage of connecting our program to the database is that the information becomes lossless even after closing our program a number of times."


    """
    
import tkinter as tk
from tkinter import messagebox
import mysql.connector

class EmployeeSystem:
    def __init__(self, root):
        self.root = root
        self.root.title("Employee Management System")
        
        # Database connection
        self.conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="password123",
            database="employee_db"
        )
        self.cursor = self.conn.cursor()
        
        # Create table if not exists
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS employees (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(50),
                position VARCHAR(50),
                salary FLOAT
            )
        """)
        
        # GUI Elements
        tk.Label(root, text="Name:").grid(row=0, column=0)
        tk.Label(root, text="Position:").grid(row=1, column=0)
        tk.Label(root, text="Salary:").grid(row=2, column=0)
        
        self.name_entry = tk.Entry(root)
        self.position_entry = tk.Entry(root)
        self.salary_entry = tk.Entry(root)
        
        self.name_entry.grid(row=0, column=1)
        self.position_entry.grid(row=1, column=1)
        self.salary_entry.grid(row=2, column=1)
        
        # Buttons
        tk.Button(root, text="Add Employee", command=self.add_employee).grid(row=3, column=0)
        tk.Button(root, text="Show Employees", command=self.show_employees).grid(row=3, column=1)
        
    def add_employee(self):
        name = self.name_entry.get()
        position = self.position_entry.get()
        salary = self.salary_entry.get()
        
        if name and position and salary:
            try:
                self.cursor.execute("INSERT INTO employees (name, position, salary) VALUES (%s, %s, %s)",
                                  (name, position, salary))
                self.conn.commit()
                messagebox.showinfo("Success", "Employee added successfully!")
                self.clear_entries()
            except:
                messagebox.showerror("Error", "Failed to add employee")
        else:
            messagebox.showwarning("Warning", "Please fill all fields")
            
    def show_employees(self):
        self.cursor.execute("SELECT * FROM employees")
        employees = self.cursor.fetchall()
        
        display_window = tk.Toplevel(self.root)
        display_window.title("Employee List")
        
        for idx, emp in enumerate(employees):
            tk.Label(display_window, 
                    text=f"ID: {emp[0]}, Name: {emp[1]}, Position: {emp[2]}, Salary: {emp[3]}").pack()
    
    def clear_entries(self):
        self.name_entry.delete(0, tk.END)
        self.position_entry.delete(0, tk.END)
        self.salary_entry.delete(0, tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    app = EmployeeSystem(root)
    root.mainloop()
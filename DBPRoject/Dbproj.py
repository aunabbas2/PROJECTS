from msvcrt import getch
import pyodbc

# === DB Connection ===
conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=DESKTOP-A1EHJ20\\SQLEXPRESS;'
    'DATABASE=Exam;'
    'Trusted_Connection=yes;'
)
cursor = conn.cursor()


# === LOGIN SYSTEM ===
def login():
    print("=== Login ===")
    role = input("Login as (admin/student): ").lower()
    username = input("Username or Email: ")
    password = input("Password: ")

    if role == 'admin':
        cursor.execute("SELECT * FROM Admins WHERE Username = ? AND PasswordHash = ?", username, password)
        result = cursor.fetchone()
        if result:
            print("Admin login successful!\n")
            print(f"DEBUG: Admin {username} logged in successfully.")  # Debug print line 19
            admin_menu()
        else:
            print("Invalid admin credentials.\n")

    elif role == 'student':
        cursor.execute("SELECT * FROM Students WHERE Email = ? AND PasswordHash = ?", username, password)
        result = cursor.fetchone()
        if result:
            print("Student login successful!\n")
            print(f"DEBUG: Student {username} logged in successfully with ID {result.StudentID}.")  # Debug print line 28
            student_menu(result.StudentID)
        else:
            print("Invalid student credentials.\n")
    else:
        print("Invalid role selected.\n")


# === ADMIN FUNCTIONS ===
def add_student():
    name = input("Full Name: ")
    email = input("Email: ")
    password = input("Password Hash: ")
    cursor.execute("EXEC InsertStudent ?, ?, ?", name, email, password)
    conn.commit()
    print("Student added successfully.\n")

def add_subject():
    name = input("Subject Name: ")
    cursor.execute("EXEC InsertSubject ?", name)
    conn.commit()
    print("Subject added successfully.\n")

def add_exam():
    subject_id = int(input("Subject ID: "))
    title = input("Exam Title: ")
    date = input("Exam Date (YYYY-MM-DD): ")
    duration = int(input("Duration in minutes: "))
    cursor.execute("EXEC InsertExam ?, ?, ?, ?", subject_id, title, date, duration)
    conn.commit()
    print("Exam added successfully.\n")

def add_question():
    subject_id = int(input("Subject ID: "))
    qtext = input("Question Text: ")
    a = input("Option A: ")
    b = input("Option B: ")
    c = input("Option C: ")
    d = input("Option D: ")
    correct = input("Correct Option (A/B/C/D): ").upper()
    cursor.execute("EXEC InsertQuestion ?, ?, ?, ?, ?, ?, ?", subject_id, qtext, a, b, c, d, correct)
    conn.commit()
    print("Question added successfully.\n")

def view_results():
    cursor.execute("""
        SELECT s.FullName, e.ExamTitle, r.Score, r.TotalQuestions, r.AttemptedAt 
        FROM ExamResults r 
        JOIN Students s ON r.StudentID = s.StudentID 
        JOIN Exams e ON r.ExamID = e.ExamID
    """)
    results = cursor.fetchall()
    for row in results:
        print(f"{row.FullName} | {row.ExamTitle} | {row.Score}/{row.TotalQuestions} | {row.AttemptedAt}")
    print(getch())


# === STUDENT FUNCTIONS ===
def take_exam(student_id):
    cursor.execute("SELECT ExamID, ExamTitle FROM Exams")
    exams = cursor.fetchall()
    print("\nAvailable Exams:")
    for ex in exams:
        print(f"{ex.ExamID}. {ex.ExamTitle}")

    try:
        exam_id = int(input("Choose Exam ID to attempt: "))
    except ValueError:
        print("\u274c Invalid exam ID.\n")
        return

    # === Check if already attempted ===
    cursor.execute("""
        SELECT * FROM ExamResults
        WHERE StudentID = ? AND ExamID = ?
    """, student_id, exam_id)
    already_attempted = cursor.fetchone()

    if already_attempted:
        print("\n\u274c You have already attempted this exam. You cannot take it again.\n")
        return

    # === Load questions ===
    cursor.execute("""
        SELECT eq.QuestionID, q.QuestionText, q.OptionA, q.OptionB, q.OptionC, q.OptionD, q.CorrectOption
        FROM ExamQuestions eq
        JOIN Questions q ON eq.QuestionID = q.QuestionID
        WHERE eq.ExamID = ?
    """, exam_id)
    questions = cursor.fetchall()
    print(f"DEBUG: Loaded {len(questions)} questions for exam {exam_id}.")  # Debug print after fetching questions (line 108)

    if not questions:
        print("\u274c No questions found for this exam.\n")
        return

    score = 0
    total = len(questions)

    # === Ask questions and record answers ===
    for q in questions:
        print(f"\nQ: {q.QuestionText}")
        print(f"A. {q.OptionA}")
        print(f"B. {q.OptionB}")
        print(f"C. {q.OptionC}")
        print(f"D. {q.OptionD}")
        ans = input("Your answer (A/B/C/D): ").upper()
        if ans not in ['A', 'B', 'C', 'D']:
            print("\u26a0\ufe0f Invalid option. Marked as incorrect.")
            ans = None

        cursor.execute("EXEC InsertStudentAnswer ?, ?, ?, ?", student_id, exam_id, q.QuestionID, ans)
        print(f"DEBUG: Answer saved for QuestionID {q.QuestionID} with answer {ans}.")  # Debug print after inserting student answer (line 117)
        if ans == q.CorrectOption:
            score += 1

    # === Store result ===
    cursor.execute("EXEC InsertExamResult ?, ?, ?, ?", student_id, exam_id, score, total)
    conn.commit()
    print("DEBUG: Exam result inserted.")  # Debug print after inserting exam result (line 125)

    # === Show result ===
    print(f"\n\u2705 Exam submitted successfully!")
    percentage = (score / total) * 100
    print(f"student Percentage: {percentage:.2f}%\n")


# === MENU SYSTEM ===
def admin_menu():
    while True:
        print("=== Admin Menu ===")
        print("1. Add Student")
        print("2. Add Subject")
        print("3. Add Exam")
        print("4. Add Question")
        print("5. View Results")
        print("0. Logout")
        choice = input("Select an option: ")
        if choice == '1': add_student()
        elif choice == '2': add_subject()
        elif choice == '3': add_exam()
        elif choice == '4': add_question()
        elif choice == '5': view_results()
        elif choice == '0': break
        else: print("Invalid option.\n")

def student_menu(student_id):
    while True:
        print("=== Student Menu ===")
        print("1. Take Exam")
        print("0. Logout")
        choice = input("Select an option: ")
        if choice == '1': take_exam(student_id)
        elif choice == '0': break
        else: print("Invalid option.\n")


# === MAIN LOOP ===
def main():
    while True:
        login()


if __name__ == "__main__":
    main()

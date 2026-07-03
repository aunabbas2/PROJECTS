CREATE DATABASE Exam;
USE Exam;

-- Run this in SQL Server to create the Admins table
CREATE TABLE Admins (
    AdminID INT PRIMARY KEY IDENTITY,
    Username NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL
);

-- Insert a default admin user (example)
INSERT INTO Admins (Username, PasswordHash) VALUES ('admin', 'admin123');  

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY IDENTITY,
    SubjectName NVARCHAR(100) NOT NULL
);

CREATE TABLE Exams (
    ExamID INT PRIMARY KEY IDENTITY,
    SubjectID INT,
    ExamTitle NVARCHAR(100),
    ExamDate DATE,
    DurationMinutes INT,
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);


CREATE TABLE Questions (
    QuestionID INT PRIMARY KEY IDENTITY,
    SubjectID INT,
    QuestionText NVARCHAR(500),
    OptionA NVARCHAR(100),
    OptionB NVARCHAR(100),
    OptionC NVARCHAR(100),
    OptionD NVARCHAR(100),
    CorrectOption CHAR(1),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);


CREATE TABLE ExamQuestions (
    ExamQuestionID INT PRIMARY KEY IDENTITY,
    ExamID INT,
    QuestionID INT,
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
);


CREATE TABLE StudentAnswers (
    AnswerID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    ExamID INT,
    QuestionID INT,
    SelectedOption CHAR(1),
    AnsweredAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
);


CREATE TABLE ExamResults (
    ResultID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    ExamID INT,
    Score INT,
    TotalQuestions INT,
    AttemptedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);


-- =============================================
-- 1. Procedure: Insert Student
-- =============================================
CREATE PROCEDURE InsertStudent
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255)
AS
BEGIN
    INSERT INTO Students (FullName, Email, PasswordHash)
    VALUES (@FullName, @Email, @PasswordHash);
END;
GO

-- =============================================
-- 2. Procedure: Insert Subject
-- =============================================
CREATE PROCEDURE InsertSubject
    @SubjectName NVARCHAR(100)
AS
BEGIN
    INSERT INTO Subjects (SubjectName)
    VALUES (@SubjectName);
END;
GO

-- =============================================
-- 3. Procedure: Insert Exam
-- =============================================
CREATE PROCEDURE InsertExam
    @SubjectID INT,
    @ExamTitle NVARCHAR(100),
    @ExamDate DATE,
    @DurationMinutes INT
AS
BEGIN
    INSERT INTO Exams (SubjectID, ExamTitle, ExamDate, DurationMinutes)
    VALUES (@SubjectID, @ExamTitle, @ExamDate, @DurationMinutes);
END;
GO

-- =============================================
-- 4. Procedure: Insert Question
-- =============================================
CREATE PROCEDURE InsertQuestion
    @SubjectID INT,
    @QuestionText NVARCHAR(500),
    @OptionA NVARCHAR(100),
    @OptionB NVARCHAR(100),
    @OptionC NVARCHAR(100),
    @OptionD NVARCHAR(100),
    @CorrectOption CHAR(1)
AS
BEGIN
    INSERT INTO Questions (SubjectID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption)
    VALUES (@SubjectID, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectOption);
END;
GO

-- =============================================
-- 5. Procedure: Insert Exam Question Mapping
-- =============================================
CREATE PROCEDURE InsertExamQuestion
    @ExamID INT,
    @QuestionID INT
AS
BEGIN
    INSERT INTO ExamQuestions (ExamID, QuestionID)
    VALUES (@ExamID, @QuestionID);
END;
GO

-- Student Answer
CREATE PROCEDURE InsertStudentAnswer
    @StudentID INT,
    @ExamID INT,
    @QuestionID INT,
    @SelectedOption CHAR(1)
AS
BEGIN
    INSERT INTO StudentAnswers (StudentID, ExamID, QuestionID, SelectedOption)
    VALUES (@StudentID, @ExamID, @QuestionID, @SelectedOption);
END;

-- =============================================
-- 7. Procedure: Insert Exam Result
-- =============================================
EXEC InsertStudent 'Ali Khan', 'ali.khan1@example.com', 'pass123';
EXEC InsertStudent 'Ayesha Noor', 'ayesha.noor2@example.com', 'pass456';
EXEC InsertStudent 'Bilal Ahmed', 'bilal.ahmed3@example.com', 'pass789';
EXEC InsertStudent 'Fatima Rizwan', 'fatima.rizwan4@example.com', 'abc123';
EXEC InsertStudent 'Usman Tariq', 'usman.tariq5@example.com', 'xyz456';
EXEC InsertStudent 'Sara Malik', 'sara.malik6@example.com', 'pwd001';
EXEC InsertStudent 'Ahmed Javed', 'ahmed.javed7@example.com', 'pwd002';
EXEC InsertStudent 'Zara Qureshi', 'zara.qureshi8@example.com', 'pwd003';
EXEC InsertStudent 'Hassan Riaz', 'hassan.riaz9@example.com', 'pwd004';
EXEC InsertStudent 'Mariam Shah', 'mariam.shah10@example.com', 'pwd005';
EXEC InsertStudent 'Omar Latif', 'omar.latif11@example.com', 'pass111';
EXEC InsertStudent 'Nida Farooq', 'nida.farooq12@example.com', 'pass222';
EXEC InsertStudent 'Raza Imran', 'raza.imran13@example.com', 'pass333';
EXEC InsertStudent 'Sana Jamil', 'sana.jamil14@example.com', 'pass444';
EXEC InsertStudent 'Tariq Abbas', 'tariq.abbas15@example.com', 'pass555';
EXEC InsertStudent 'Khadija Saeed', 'khadija.saeed16@example.com', 'pwd111';
EXEC InsertStudent 'Zain Malik', 'zain.malik17@example.com', 'pwd222';
EXEC InsertStudent 'Hina Rauf', 'hina.rauf18@example.com', 'pwd333';
EXEC InsertStudent 'Junaid Iqbal', 'junaid.iqbal19@example.com', 'pwd444';
EXEC InsertStudent 'Iqra Ali', 'iqra.ali20@example.com', 'pwd555';
EXEC InsertStudent 'Faisal Shafiq', 'faisal.shafiq21@example.com', 'pass666';
EXEC InsertStudent 'Mehwish Khan', 'mehwish.khan22@example.com', 'pass777';
EXEC InsertStudent 'Arham Nadeem', 'arham.nadeem23@example.com', 'pass888';
EXEC InsertStudent 'Sobia Aslam', 'sobia.aslam24@example.com', 'pass999';
EXEC InsertStudent 'Waqas Javed', 'waqas.javed25@example.com', 'pwd666';
EXEC InsertStudent 'Amina Riaz', 'amina.riaz26@example.com', 'pwd777';
EXEC InsertStudent 'Danish Ahmed', 'danish.ahmed27@example.com', 'pwd888';
EXEC InsertStudent 'Nawal Sheikh', 'nawal.sheikh28@example.com', 'pwd999';
EXEC InsertStudent 'Bilal Hussain', 'bilal.hussain29@example.com', 'pass101';
EXEC InsertStudent 'Sadia Khan', 'sadia.khan30@example.com', 'pass202';
EXEC InsertStudent 'Zubair Malik', 'zubair.malik31@example.com', 'pass303';
EXEC InsertStudent 'Iqra Khan', 'iqra.khan32@example.com', 'pass404';
EXEC InsertStudent 'Rehan Abbas', 'rehan.abbas33@example.com', 'pass505';
EXEC InsertStudent 'Huma Tariq', 'huma.tariq34@example.com', 'pwd101';
EXEC InsertStudent 'Salman Yousaf', 'salman.yousaf35@example.com', 'pwd202';
EXEC InsertStudent 'Areeba Jamil', 'areeba.jamil36@example.com', 'pwd303';
EXEC InsertStudent 'Hamza Ali', 'hamza.ali37@example.com', 'pwd404';
EXEC InsertStudent 'Samar Nadeem', 'samar.nadeem38@example.com', 'pwd505';
EXEC InsertStudent 'Zainab Saeed', 'zainab.saeed39@example.com', 'pass707';
EXEC InsertStudent 'Fahad Qureshi', 'fahad.qureshi40@example.com', 'pass808';
EXEC InsertStudent 'Maryam Khan', 'maryam.khan41@example.com', 'pass909';
EXEC InsertStudent 'Taimoor Raza', 'taimoor.raza42@example.com', 'pass010';
EXEC InsertStudent 'Hira Iqbal', 'hira.iqbal43@example.com', 'pwd707';
EXEC InsertStudent 'Noman Latif', 'noman.latif44@example.com', 'pwd808';
EXEC InsertStudent 'Zoya Farooq', 'zoya.farooq45@example.com', 'pwd909';

-- =========================
-- Insert Subjects
-- =========================
EXEC InsertSubject 'Computer Science';  -- ID = 1
EXEC InsertSubject 'Mathematics';       -- ID = 2
EXEC InsertSubject 'Physics';           -- ID = 3

-- =========================
-- Insert Exams
-- =========================
EXEC InsertExam 1, 'CS Midterm', '2025-06-10', 60;     -- ID = 1
EXEC InsertExam 2, 'Math Quiz 1', '2025-06-12', 30;    -- ID = 2
EXEC InsertExam 3, 'Physics Final', '2025-06-15', 90;  -- ID = 3

-- =========================
-- Insert Questions for Computer Science (SubjectID = 1)
-- =========================
EXEC InsertQuestion 1, 'What does CPU stand for?', 'Central Power Unit', 'Central Processing Unit', 'Control Panel Unit', 'Central Primary Unit', 'B';
EXEC InsertQuestion 1, 'Which one is a programming language?', 'HTTP', 'HTML', 'Python', 'USB', 'C';
EXEC InsertQuestion 1, 'What is the output of 3 + 2 * 2?', '10', '7', '8', '5', 'B';
EXEC InsertQuestion 1, 'Which data type stores text?', 'int', 'float', 'char', 'string', 'D';
EXEC InsertQuestion 1, 'Which is a valid variable name?', '1var', '_name', 'var$', 'None', 'B';
EXEC InsertQuestion 1, 'What does RAM stand for?', 'Random Access Memory', 'Read Access Memory', 'Run All Memory', 'Real Access Mode', 'A';
EXEC InsertQuestion 1, 'Which is not an OS?', 'Windows', 'Linux', 'Oracle', 'MacOS', 'C';
EXEC InsertQuestion 1, 'What is an IDE?', 'Device', 'Software', 'Network', 'Database', 'B';
EXEC InsertQuestion 1, 'Which is not an input device?', 'Keyboard', 'Mouse', 'Monitor', 'Scanner', 'C';
EXEC InsertQuestion 1, 'What does HTML stand for?', 'Hyper Text Markup Language', 'Hyperlink Mark Language', 'Hyper Test Machine Language', 'None', 'A';

-- =========================
-- Insert Questions for Mathematics (SubjectID = 2)
-- =========================
EXEC InsertQuestion 2, 'What is 15 + 6?', '20', '21', '22', '23', 'B';
EXEC InsertQuestion 2, 'Square root of 81?', '9', '8', '7', '6', 'A';
EXEC InsertQuestion 2, '10 x 12 = ?', '120', '100', '112', '122', 'A';
EXEC InsertQuestion 2, '100 ÷ 4 = ?', '20', '25', '30', '35', 'B';
EXEC InsertQuestion 2, 'What is π approximately?', '3.14', '2.17', '4.10', '3.00', 'A';
EXEC InsertQuestion 2, 'What is 2³?', '6', '8', '9', '10', 'B';
EXEC InsertQuestion 2, 'What is 7²?', '42', '48', '49', '56', 'C';
EXEC InsertQuestion 2, 'Solve: (5 + 3) * 2', '14', '16', '10', '12', 'B';
EXEC InsertQuestion 2, '5% of 200 is?', '5', '10', '15', '20', 'D';
EXEC InsertQuestion 2, 'What is the next prime after 7?', '9', '10', '11', '13', 'C';

-- =========================
-- Insert Questions for Physics (SubjectID = 3)
-- =========================
EXEC InsertQuestion 3, 'SI unit of Force?', 'Pascal', 'Joule', 'Newton', 'Watt', 'C';
EXEC InsertQuestion 3, 'Who gave laws of motion?', 'Einstein', 'Newton', 'Tesla', 'Galileo', 'B';
EXEC InsertQuestion 3, 'Speed = ?', 'Distance x Time', 'Distance ÷ Time', 'Time ÷ Distance', 'Velocity x Time', 'B';
EXEC InsertQuestion 3, 'Acceleration = ?', 'v ÷ t', 's ÷ v', 't ÷ s', 'None', 'A';
EXEC InsertQuestion 3, 'Which is not a scalar quantity?', 'Speed', 'Distance', 'Force', 'Time', 'C';
EXEC InsertQuestion 3, 'Light year is unit of?', 'Time', 'Distance', 'Speed', 'Velocity', 'B';
EXEC InsertQuestion 3, '1 kWh = ?', '3600 J', '3.6 x 10⁶ J', '1000 J', 'None', 'B';
EXEC InsertQuestion 3, 'Power = ?', 'Work / Time', 'Force x Distance', 'Speed x Time', 'Mass x Velocity', 'A';
EXEC InsertQuestion 3, 'Which is an EM wave?', 'Sound', 'Light', 'Water', 'Seismic', 'B';
EXEC InsertQuestion 3, 'Who discovered gravity?', 'Newton', 'Einstein', 'Bohr', 'Faraday', 'A';

-- =========================
-- Map 10 Questions to Each Exam
-- =========================

-- CS Midterm - ExamID = 1, Questions 1-10
EXEC InsertExamQuestion 1, 1;
EXEC InsertExamQuestion 1, 2;
EXEC InsertExamQuestion 1, 3;
EXEC InsertExamQuestion 1, 4;
EXEC InsertExamQuestion 1, 5;
EXEC InsertExamQuestion 1, 6;
EXEC InsertExamQuestion 1, 7;
EXEC InsertExamQuestion 1, 8;
EXEC InsertExamQuestion 1, 9;
EXEC InsertExamQuestion 1, 10;

-- Math Quiz 1 - ExamID = 2, Questions 11-20
EXEC InsertExamQuestion 2, 11;
EXEC InsertExamQuestion 2, 12;
EXEC InsertExamQuestion 2, 13;
EXEC InsertExamQuestion 2, 14;
EXEC InsertExamQuestion 2, 15;
EXEC InsertExamQuestion 2, 16;
EXEC InsertExamQuestion 2, 17;
EXEC InsertExamQuestion 2, 18;
EXEC InsertExamQuestion 2, 19;
EXEC InsertExamQuestion 2, 20;

-- Physics Final - ExamID = 3, Questions 21-30
EXEC InsertExamQuestion 3, 21;
EXEC InsertExamQuestion 3, 22;
EXEC InsertExamQuestion 3, 23;
EXEC InsertExamQuestion 3, 24;
EXEC InsertExamQuestion 3, 25;
EXEC InsertExamQuestion 3, 26;
EXEC InsertExamQuestion 3, 27;
EXEC InsertExamQuestion 3, 28;
EXEC InsertExamQuestion 3, 29;
EXEC InsertExamQuestion 3, 30;


select * from StudentAnswers


INSERT INTO ExamResults (StudentID, ExamID, Score, TotalQuestions)
SELECT
    sa.StudentID,
    sa.ExamID,
    SUM(CASE WHEN sa.SelectedOption = q.CorrectOption THEN 1 ELSE 0 END) AS Score,
    COUNT(DISTINCT sa.QuestionID) AS TotalQuestions
FROM
    StudentAnswers sa
JOIN
    Questions q ON sa.QuestionID = q.QuestionID
GROUP BY
    sa.StudentID, sa.ExamID;



	-- 1. Get all exams with their subject names
SELECT e.ExamID, e.ExamTitle, s.SubjectName, e.ExamDate
FROM Exams e
JOIN Subjects s ON e.SubjectID = s.SubjectID;

-- 2. Count total students who took each exam
SELECT er.ExamID, COUNT(DISTINCT er.StudentID) AS TotalStudents
FROM ExamResults er
GROUP BY er.ExamID;

-- 3. Get each student’s highest score per subject
SELECT s.StudentID, s.FullName, sub.SubjectName, MAX(er.Score) AS HighestScore
FROM Students s
JOIN ExamResults er ON s.StudentID = er.StudentID
JOIN Exams e ON er.ExamID = e.ExamID
JOIN Subjects sub ON e.SubjectID = sub.SubjectID
GROUP BY s.StudentID, s.FullName, sub.SubjectName;


-- 5. Get average score per exam
SELECT er.ExamID, AVG(CAST(er.Score AS FLOAT)) AS AverageScore
FROM ExamResults er
GROUP BY er.ExamID;

-- 6. Get students who scored more than 5 marks in any exam
SELECT s.StudentID, s.FullName, er.ExamID, er.Score, er.TotalQuestions
FROM ExamResults er
JOIN Students s ON er.StudentID = s.StudentID
WHERE er.Score > 5;

-- 7. Get exams that have more than 9 questions
SELECT e.ExamID, e.ExamTitle, COUNT(eq.QuestionID) AS NumberOfQuestions
FROM Exams e
JOIN ExamQuestions eq ON e.ExamID = eq.ExamID
GROUP BY e.ExamID, e.ExamTitle
HAVING COUNT(eq.QuestionID) > 9;

-- 8. Get students who attempted more than 1 exams
SELECT s.StudentID, s.FullName, COUNT(DISTINCT er.ExamID) AS ExamsAttempted
FROM Students s
JOIN ExamResults er ON s.StudentID = er.StudentID
GROUP BY s.StudentID, s.FullName
HAVING COUNT(DISTINCT er.ExamID) > 1;

-- 9. Find questions without any answers yet
SELECT q.QuestionID, q.QuestionText
FROM Questions q
LEFT JOIN StudentAnswers sa ON q.QuestionID = sa.QuestionID
WHERE sa.AnswerID IS NULL;

-- 10. Get student exam attempts with scores and exam duration
SELECT s.FullName, e.ExamTitle, er.Score, e.DurationMinutes
FROM ExamResults er
JOIN Students s ON er.StudentID = s.StudentID
JOIN Exams e ON er.ExamID = e.ExamID;



-- 12. Get the most recent exam date for each subject
SELECT sub.SubjectName, MAX(e.ExamDate) AS LastExamDate
FROM Subjects sub
JOIN Exams e ON sub.SubjectID = e.SubjectID
GROUP BY sub.SubjectName;

-- 13. List students who never took any exam
SELECT s.StudentID, s.FullName, s.Email
FROM Students s
LEFT JOIN ExamResults er ON s.StudentID = er.StudentID
WHERE er.StudentID IS NULL;

-- 14. Find exams with their question counts and average scores (left join for exams without results)
SELECT e.ExamID, e.ExamTitle, COUNT(DISTINCT eq.QuestionID) AS QuestionCount,
       AVG(CAST(er.Score AS FLOAT)) AS AverageScore
FROM Exams e
LEFT JOIN ExamQuestions eq ON e.ExamID = eq.ExamID
LEFT JOIN ExamResults er ON e.ExamID = er.ExamID
GROUP BY e.ExamID, e.ExamTitle;

-- 15. Get top 5 students by total score across all exams
SELECT TOP 5 s.StudentID, s.FullName, SUM(er.Score) AS TotalScore
FROM Students s
JOIN ExamResults er ON s.StudentID = er.StudentID
GROUP BY s.StudentID, s.FullName
ORDER BY TotalScore DESC;

-- students having less than avg marks
SELECT DISTINCT s.StudentID, s.FullName
FROM Students s
JOIN ExamResults er ON s.StudentID = er.StudentID
WHERE er.ExamID = (
    SELECT TOP 1 e.ExamID
    FROM Exams e
    JOIN ExamResults er2 ON e.ExamID = er2.ExamID
    GROUP BY e.ExamID
    ORDER BY AVG(CAST(er2.Score AS FLOAT)) ASC
);

--Get the latest exam attempted by each student
SELECT s.StudentID, s.FullName, er.ExamID, er.AttemptedAt AS LatestAttempt
FROM Students s
JOIN ExamResults er ON s.StudentID = er.StudentID
WHERE er.AttemptedAt = (
    SELECT MAX(er2.AttemptedAt)
    FROM ExamResults er2
    WHERE er2.StudentID = s.StudentID
);

-- Find the question(s) that most students answered incorrectly
SELECT TOP 1 q.QuestionID, q.QuestionText, COUNT(*) AS IncorrectCount
FROM StudentAnswers sa
JOIN Questions q ON sa.QuestionID = q.QuestionID
WHERE sa.SelectedOption <> q.CorrectOption
GROUP BY q.QuestionID, q.QuestionText
ORDER BY IncorrectCount DESC;




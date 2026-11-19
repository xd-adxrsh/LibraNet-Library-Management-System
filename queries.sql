-- Analytical SQL Queries for LibraNet
USE libranet_db;

-- 1. Circulation, Overdue Count & Fines Collected by Subject
SELECT
    b.subject,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE WHEN l.return_date > l.due_date THEN 1 ELSE 0 END) AS overdue_count,
    COALESCE(SUM(f.fine_amount), 0) AS fines_collected_inr
FROM vw_library_circulation l
JOIN books b ON l.book_id = b.book_id
LEFT JOIN fines f ON l.loan_id = f.loan_id
GROUP BY b.subject
ORDER BY total_loans DESC;

-- 2. Most Borrowed Titles
SELECT
    title,
    subject,
    COUNT(loan_id) AS borrow_count
FROM vw_library_circulation
GROUP BY book_id, title, subject
ORDER BY borrow_count DESC;

-- 3. Overdue Members Report
SELECT
    member_name,
    department,
    title,
    due_date,
    DATEDIFF(COALESCE(return_date, CURDATE()), due_date) AS days_overdue
FROM vw_library_circulation
WHERE COALESCE(return_date, CURDATE()) > due_date
ORDER BY days_overdue DESC;

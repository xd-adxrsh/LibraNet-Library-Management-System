-- Problem Statement 07: LibraNet — Library Circulation and Reader Analytics
-- MySQL 8.0+ 3NF Relational Schema

CREATE DATABASE IF NOT EXISTS libranet_db;
USE libranet_db;

CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120) UNIQUE NOT NULL,
    address VARCHAR(200),
    contact_info VARCHAR(100)
);

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    subject VARCHAR(80) NOT NULL,
    publication_year INT CHECK (publication_year >= 1900),
    isbn VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    biography TEXT
);

-- Many-to-Many Bridge Table between Books and Authors
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE copies (
    copy_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    status ENUM('Available', 'Issued', 'Damaged', 'Lost') DEFAULT 'Available',
    acquisition_date DATE NOT NULL,
    shelf_location VARCHAR(40) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department VARCHAR(80) NOT NULL,
    join_date DATE NOT NULL
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    FOREIGN KEY (copy_id) REFERENCES copies(copy_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT UNIQUE NOT NULL,
    fine_amount DECIMAL(8,2) NOT NULL CHECK (fine_amount >= 0),
    paid_status ENUM('Unpaid', 'Paid') DEFAULT 'Unpaid',
    assessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- Trigger to automatically calculate overdue fine (Rs. 10/day) and mark copy Available on return
DELIMITER //
CREATE TRIGGER trg_calculate_overdue_fine
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    DECLARE overdue_days INT;
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        UPDATE copies SET status = 'Available' WHERE copy_id = NEW.copy_id;
        SET overdue_days = DATEDIFF(NEW.return_date, NEW.due_date);
        IF overdue_days > 0 THEN
            INSERT INTO fines (loan_id, fine_amount, paid_status)
            VALUES (NEW.loan_id, overdue_days * 10.00, 'Unpaid');
        END IF;
    END IF;
END //
DELIMITER ;

-- Analytical View for Circulation Reporting
CREATE OR REPLACE VIEW vw_library_circulation AS
SELECT
    l.loan_id,
    l.loan_date,
    l.due_date,
    l.return_date,
    c.copy_id,
    b.book_id,
    b.title,
    b.subject,
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.department
FROM loans l
JOIN copies c ON l.copy_id = c.copy_id
JOIN books b ON c.book_id = b.book_id
JOIN members m ON l.member_id = m.member_id;

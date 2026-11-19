-- Sample Seed Data for LibraNet
USE libranet_db;

INSERT INTO publishers (name, address, contact_info) VALUES
('O''Reilly Media', 'Sebastopol, CA', 'support@oreilly.com'),
('Springer Nature', 'Berlin, Germany', 'service@springer.com'),
('Oxford University Press', 'Oxford, UK', 'enquiry@oup.com');

INSERT INTO books (publisher_id, title, subject, publication_year, isbn) VALUES
(1, 'Designing Data-Intensive Applications', 'Data Science', 2022, '978-1449373320'),
(2, 'Pattern Recognition and Machine Learning', 'Computer Science', 2021, '978-0387310732'),
(3, 'Thinking, Fast and Slow', 'Economics', 2020, '978-0374533557'),
(3, 'The God of Small Things', 'Literature', 2019, '978-0679457312');

INSERT INTO authors (first_name, last_name, biography) VALUES
('Martin', 'Kleppmann', 'Distributed systems researcher and author'),
('Christopher', 'Bishop', 'Professor of Computer Science and AI'),
('Daniel', 'Kahneman', 'Nobel laureate in Economic Sciences'),
('Arundhati', 'Roy', 'Booker Prize-winning novelist');

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4);

INSERT INTO copies (book_id, status, acquisition_date, shelf_location) VALUES
(1, 'Available', '2024-01-15', 'DS-A12'),
(1, 'Issued', '2024-01-15', 'DS-A13'),
(2, 'Available', '2024-02-10', 'CS-B04'),
(3, 'Available', '2024-03-05', 'EC-C09'),
(4, 'Available', '2024-04-20', 'LT-D02');

INSERT INTO members (first_name, last_name, email, phone, department, join_date) VALUES
('Nandana', 'P', 'nandana.p@university.edu', '9876543210', 'Data Science', '2025-08-01'),
('Rahul', 'Nair', 'rahul.n@university.edu', '9876543211', 'Bioinformatics', '2025-08-03'),
('Priya', 'Menon', 'priya.m@university.edu', '9876543212', 'Computer Science', '2025-08-05');

INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date) VALUES
(1, 1, '2026-10-01', '2026-10-15', '2026-10-20'),
(3, 2, '2026-10-05', '2026-10-19', '2026-10-18'),
(4, 3, '2026-10-10', '2026-10-24', '2026-10-29'),
(2, 1, '2026-11-01', '2026-11-15', NULL);

INSERT INTO fines (loan_id, fine_amount, paid_status) VALUES
(1, 50.00, 'Paid'),
(3, 50.00, 'Unpaid');

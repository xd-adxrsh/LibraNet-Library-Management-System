# LibraNet — Library Circulation and Reader Analytics

**Course:** M.Sc. Data Science · 25MSDA1S04 (DBMS for Analytics)  
**Problem Statement No.:** 07 · **Domain:** Library  

## Repository Structure
- `schema.sql` — 3NF MySQL schema (8 tables including `book_authors` M:N bridge), `trg_calculate_overdue_fine` trigger, and `vw_library_circulation` view.
- `data.sql` — Seed records for publishers, books, authors, copies, members, loans, and fines.
- `queries.sql` — Analytical SQL queries for subject circulation, overdue members, and fines collected.
- `analysis.py` — Python DB-API (`mysql.connector`) + `pandas` & `matplotlib` visualization script.
- `mongodb_scripts.js` — MongoDB document schema for `user_activity_logs`, indexes, CRUD operations, and aggregation pipelines.

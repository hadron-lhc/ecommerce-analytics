# SQL Exercises — E-commerce Analytics

53 exercises organized by topic. Each `.sql` file has numbered exercises with the SQL concepts used.

---

## Schema

| File                   | Description                                                                        |
| ---------------------- | ---------------------------------------------------------------------------------- |
| `schema/schema_v1.sql` | DDL: table creation for `users`, `movies`, `viewing_session` with PKs, FKs, CHECKs |

---

## 01 — Basic Exploration

| #   | File                                          | Concepts                        |
| --- | --------------------------------------------- | ------------------------------- |
| 1   | `01_basic_exploration/01_size_viewer.sql`     | SELECT, COUNT(\*)               |
| 2   | `01_basic_exploration/01_size_viewer.sql`     | SELECT, COUNT(\*)               |
| 3   | `01_basic_exploration/01_size_viewer.sql`     | SELECT, COUNT(\*)               |
| 4   | `01_basic_exploration/02_movies_analysis.sql` | ORDER BY DESC, LIMIT            |
| 5   | `01_basic_exploration/02_movies_analysis.sql` | ORDER BY ASC, LIMIT             |
| 6   | `01_basic_exploration/02_movies_analysis.sql` | GROUP BY, COUNT, ORDER BY       |
| 7   | `01_basic_exploration/03_event_analysis.sql`  | AVG                             |
| 8   | `01_basic_exploration/03_event_analysis.sql`  | AVG, ROUND, arithmetic operator |
| 9   | `01_basic_exploration/03_event_analysis.sql`  | GROUP BY, COUNT, ORDER BY       |
| 10  | `01_basic_exploration/03_event_analysis.sql`  | GROUP BY, COUNT, ORDER BY       |

## 02 — Joins

| #   | File                               | Concepts                                                             |
| --- | ---------------------------------- | -------------------------------------------------------------------- |
| 11  | `02_joins/01_users_as_main.sql`    | LEFT JOIN, GROUP BY, COUNT, ORDER BY, LIMIT                          |
| 12  | `02_joins/01_users_as_main.sql`    | LEFT JOIN, SUM, GROUP BY, ORDER BY, LIMIT                            |
| 13  | `02_joins/02_movies_as_main.sql`   | LEFT JOIN, GROUP BY, COUNT, ORDER BY, LIMIT                          |
| 14  | `02_joins/02_movies_as_main.sql`   | LEFT JOIN, GROUP BY, COUNT, ORDER BY, LIMIT                          |
| 15  | `02_joins/03_sessions_as_main.sql` | LEFT JOIN, AVG, ROUND, GROUP BY, ORDER BY                            |
| 16  | `02_joins/03_sessions_as_main.sql` | CTE (WITH), LEFT JOIN, SUM, COUNT, GROUP BY                          |
| 17  | `02_joins/03_sessions_as_main.sql` | Multiple CTEs, INNER JOIN, WHERE, GROUP BY, ROW_NUMBER, PARTITION BY |
| 18  | `02_joins/03_sessions_as_main.sql` | LEFT JOIN, SUM, GROUP BY, ORDER BY, division                         |

## 03 — Aggregations

| #   | File                         | Concepts                                                         |
| --- | ---------------------------- | ---------------------------------------------------------------- |
| 19  | `03_aggs/01_agregations.sql` | CTE, EXTRACT, AGE, AVG, ROUND                                    |
| 20  | `03_aggs/01_agregations.sql` | Multiple CTEs, EXTRACT, AGE, CASE, GROUP BY, ORDER BY            |
| 21  | `03_aggs/01_agregations.sql` | Multiple CTEs (x4), EXTRACT, AGE, CASE, JOIN, RANK, PARTITION BY |
| 22  | `03_aggs/01_agregations.sql` | Multiple CTEs (x3), EXTRACT, AGE, CASE, JOIN, SUM, GROUP BY      |
| 23  | `03_aggs/01_agregations.sql` | JOIN, AVG, ROUND, GROUP BY                                       |
| 24  | `03_aggs/01_agregations.sql` | CTE, INNER JOIN, COUNT, GROUP BY, WHERE                          |
| 25  | `03_aggs/01_agregations.sql` | CTE, INNER JOIN, COUNT, GROUP BY, WHERE                          |
| 26  | `03_aggs/01_agregations.sql` | CTE, INNER JOIN, SUM, GROUP BY, WHERE                            |

## 04 — CTEs

| #   | File                        | Concepts                                                 |
| --- | --------------------------- | -------------------------------------------------------- |
| 27  | `04_CTEs/01_for_users.sql`  | CTE, CROSS JOIN, AVG, WHERE, LIMIT                       |
| 28  | `04_CTEs/01_for_users.sql`  | CTE, JOIN, GROUP BY, subquery, AVG, ORDER BY, LIMIT      |
| 29  | `04_CTEs/01_for_users.sql`  | Multiple CTEs, JOIN, SUM, GROUP BY, RANK, PARTITION BY   |
| 30  | `04_CTEs/02_for_movies.sql` | Multiple CTEs, CROSS JOIN (x2), SUM, COUNT, GROUP BY     |
| 31  | `04_CTEs/02_for_movies.sql` | Multiple CTEs, JOIN, COUNT, GROUP BY, RANK, PARTITION BY |

## 05 — Window Functions

| #   | File                                          | Concepts                                                         |
| --- | --------------------------------------------- | ---------------------------------------------------------------- |
| 32  | `05_window_functions/01_window_functions.sql` | ROW_NUMBER, PARTITION BY, ORDER BY, LIMIT                        |
| 33  | `05_window_functions/01_window_functions.sql` | CTE, COUNT, GROUP BY, RANK, ORDER BY, LIMIT                      |
| 34  | `05_window_functions/01_window_functions.sql` | Multiple CTEs, JOIN, COUNT, GROUP BY, ROW_NUMBER, PARTITION BY   |
| 35  | `05_window_functions/01_window_functions.sql` | Multiple CTEs, JOIN, COUNT, GROUP BY, RANK, PARTITION BY         |
| 36  | `05_window_functions/01_window_functions.sql` | CTE, MIN, GROUP BY, ORDER BY                                     |
| 37  | `05_window_functions/01_window_functions.sql` | CTE, MAX, GROUP BY, ORDER BY                                     |
| 38  | `05_window_functions/01_window_functions.sql` | CTE, LAG, PARTITION BY, ORDER BY, type casting, date subtraction |

## 06 — Gaps and Islands

| #   | File                                          | Concepts                                                                           |
| --- | --------------------------------------------- | ---------------------------------------------------------------------------------- |
| 39  | `06_gaps_and_islands/01_gaps_and_islands.sql` | DISTINCT, ROW_NUMBER, PARTITION BY, INTERVAL, GROUP BY, MIN, MAX                   |
| 40  | `06_gaps_and_islands/01_gaps_and_islands.sql` | Multiple CTEs (x3), DISTINCT, ROW_NUMBER, INTERVAL, GROUP BY, MAX                  |
| 41  | `06_gaps_and_islands/01_gaps_and_islands.sql` | Multiple CTEs (x3), DISTINCT, ROW_NUMBER, INTERVAL, GROUP BY, WHERE                |
| 42  | `06_gaps_and_islands/01_gaps_and_islands.sql` | Multiple CTEs (x3), DISTINCT, ROW_NUMBER, INTERVAL, GROUP BY, MAX, ORDER BY, LIMIT |

## 07 — Business Questions

| #   | File                                              | Concepts                                            |
| --- | ------------------------------------------------- | --------------------------------------------------- |
| 43  | `07_business_questions/01_business_questions.sql` | JOIN, AVG, ROUND, GROUP BY, ORDER BY, LIMIT         |
| 44  | `07_business_questions/01_business_questions.sql` | JOIN, SUM, GROUP BY, ORDER BY, LIMIT                |
| 45  | `07_business_questions/01_business_questions.sql` | CASE, AVG, ROUND, GROUP BY, ORDER BY, LIMIT         |
| 46  | `07_business_questions/01_business_questions.sql` | GROUP BY, AVG, ROUND, ORDER BY                      |
| 47  | `07_business_questions/01_business_questions.sql` | CTE, EXTRACT, AGE, CASE, JOIN, AVG, ROUND, GROUP BY |
| 48  | `07_business_questions/01_business_questions.sql` | GROUP BY, AVG, ROUND, ORDER BY, LIMIT               |

## 08 — Hard Challenges

| #   | File                                        | Concepts                                                                        |
| --- | ------------------------------------------- | ------------------------------------------------------------------------------- |
| 49  | `08_hard_challenges/01_hard_challenges.sql` | Multiple CTEs, JOIN, COUNT, GROUP BY, ROW_NUMBER, PARTITION BY                  |
| 50  | `08_hard_challenges/01_hard_challenges.sql` | Multiple CTEs (x4), NTILE, ROW_NUMBER, PARTITION BY, COUNT, CASE, MAX           |
| 51  | `08_hard_challenges/01_hard_challenges.sql` | CTE, CASE, GROUP BY, ORDER BY                                                   |
| 52  | `08_hard_challenges/01_hard_challenges.sql` | DATE_TRUNC, COUNT(DISTINCT), GROUP BY, ORDER BY                                 |
| 53  | `08_hard_challenges/01_hard_challenges.sql` | Multiple CTEs, DATE_TRUNC, EXTRACT, AGE, JOIN, COUNT(DISTINCT), ROUND, GROUP BY |

---

**Total: 53 exercises** on an e-commerce schema with `users`, `movies`, and `viewing_session`.

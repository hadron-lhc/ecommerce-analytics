# E-commerce Analytics

A hands-on SQL practice project using synthetic e-commerce data. It simulates a streaming platform with users, movies, and viewing sessions.

## Dataset

The synthetic data includes ~100 users, ~200 movies, and ~22K viewing sessions across 9 genres (Action, Drama, Comedy, Horror, Romance, Anime, Animation, Documentary, Short Film).

## Project Structure

```
├── data/
│   ├── raw/              # Generated CSV files (users_v1, movies_v1, sessions_v1)
│   ├── processed/        # Reserved for processed data
│   └── export/           # Reserved for exports
├── src/
│   ├── generators/       # Synthetic data generation scripts
│   │   ├── config.py             # Genre distributions, subgenres, durations, title templates
│   │   ├── generate_users.py     # 100 users with weighted age ranges
│   │   ├── generate_movies.py    # 200 movies with genre-aware titles and metadata
│   │   └── generate_viewing_sessions.py  # 22K sessions with realistic patterns
│   ├── loaders/          # Load CSVs into PostgreSQL via SQLAlchemy
│   │   ├── load_users.py
│   │   ├── load_movies.py
│   │   ├── load_events.py
│   │   └── load_all.py           # Truncate + load pipeline
│   ├── explorers/        # Quick SQL check scripts (commented out)
│   └── paths.py          # Path configuration
├── sql/
│   ├── schema/           # DDL: table creation with PKs, FKs, CHECK constraints
│   ├── README.md         # Index of all 53 exercises with concept tags
│   └── analytics/        # 53 numbered exercises by topic
│       ├── 01_basic_exploration/  # SELECT, COUNT, AVG, GROUP BY (exercises 1-10)
│       ├── 02_joins/              # LEFT JOIN, CROSS JOIN (exercises 11-18)
│       ├── 03_aggs/               # CTEs, EXTRACT, CASE, RANK (exercises 19-26)
│       ├── 04_CTEs/               # CROSS JOIN with CTEs, subqueries (exercises 27-31)
│       ├── 05_window_functions/   # ROW_NUMBER, RANK, LAG (exercises 32-38)
│       ├── 06_gaps_and_islands/   # Streak detection with ROW_NUMBER + date diff (exercises 39-42)
│       ├── 07_business_questions/ # Completion rate, retention analysis (exercises 43-48)
│       └── 08_hard_challenges/    # NTILE, cohort analysis, monthly retention (exercises 49-53)
├── dashboard/           # Reserved for future dashboard
├── reports/             # Reserved for reports
├── requirements.txt     # pandas, sqlalchemy, psycopg2, python-dotenv
└── .env.example         # PostgreSQL connection template
```

## Prerequisites

- Python 3.10+
- PostgreSQL running locally
- pip dependencies (`pandas`, `sqlalchemy`, `psycopg2-binary`, `python-dotenv`)

## Setup

```bash
# 1. Configure database connection
cp .env.example .env
# Edit .env with your PostgreSQL credentials

# 2. Install dependencies
pip install -r requirements.txt

# 3. Create the schema in PostgreSQL
psql -U your_user -d your_db -f sql/schema/schema_v1.sql

# 4. Generate synthetic data
python -m src.generators.generate_users
python -m src.generators.generate_movies
python -m src.generators.generate_viewing_sessions

# 5. Load data into PostgreSQL
python -m src.loaders.load_all
```

## SQL Exercises

53 exercises organized by difficulty and SQL concept. Each file has numbered queries with the concepts used.

| Topic | Exercises | Key Concepts |
|-------|-----------|--------------|
| Basic Exploration | 1-10 | SELECT, COUNT, AVG, GROUP BY, ORDER BY |
| Joins | 11-18 | LEFT JOIN, INNER JOIN, CROSS JOIN |
| Aggregations | 19-26 | CTEs, EXTRACT, AGE, CASE, RANK |
| CTEs | 27-31 | WITH, multiple CTEs, subqueries |
| Window Functions | 32-38 | ROW_NUMBER, RANK, LAG, PARTITION BY |
| Gaps and Islands | 39-42 | Streak detection, date arithmetic |
| Business Questions | 43-48 | Completion rate, retention by segment |
| Hard Challenges | 49-53 | NTILE, cohort analysis, monthly retention |

See [sql/README.md](sql/README.md) for the full exercise index.

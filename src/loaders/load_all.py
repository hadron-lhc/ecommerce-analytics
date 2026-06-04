import pandas as pd
import os
import ast
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

from pathlib import Path
import sys

SRC_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SRC_DIR))

from paths import DATA_PATH


def load_db_config():
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    db_name = os.getenv("DB_NAME")
    return user, password, host, port, db_name


def connect_db():
    user, password, host, port, db_name = load_db_config()
    url = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"
    return create_engine(url)


def read_users():
    path = DATA_PATH / "raw/users_v1.csv"
    return pd.read_csv(path, parse_dates=["sign_up_date", "birth_date"])


def read_movies():
    path = DATA_PATH / "raw/movies_v1.csv"
    df = pd.read_csv(path, parse_dates=["release_date"])
    df["genres"] = df["genres"].apply(ast.literal_eval)
    return df


def read_viewing_sessions():
    path = DATA_PATH / "raw/viewing_sessions_v1.csv"
    return pd.read_csv(path, parse_dates=["started_at"])


def truncate_all(engine):
    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE viewing_session CASCADE"))
        conn.execute(text("TRUNCATE TABLE movies CASCADE"))
        conn.execute(text("TRUNCATE TABLE users CASCADE"))


def load_users(engine):
    df = read_users()
    df.to_sql("users", engine, if_exists="append", index=False)
    print(f"Usuarios cargados correctamente ({len(df)} filas)")


def load_movies(engine):
    df = read_movies()
    df.to_sql("movies", engine, if_exists="append", index=False)
    print(f"Películas cargadas correctamente ({len(df)} filas)")


def load_viewing_sessions(engine):
    df = read_viewing_sessions()
    df.to_sql("viewing_session", engine, if_exists="append", index=False)
    print(f"Sesiones cargadas correctamente ({len(df)} filas)")


def main():
    try:
        load_dotenv()
    except Exception as e:
        print(f"Error al cargar .env: {e}")
        return

    try:
        engine = connect_db()
    except Exception as e:
        print(f"Error al conectar a la base de datos: {e}")
        return

    try:
        truncate_all(engine)
        print("Tablas truncadas correctamente")
    except Exception as e:
        print(f"Error al truncar tablas: {e}")
        return

    try:
        load_users(engine)
        load_movies(engine)
        load_viewing_sessions(engine)
    except Exception as e:
        print(f"Error al cargar datos: {e}")
        return


if __name__ == "__main__":
    main()

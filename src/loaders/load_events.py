import pandas as pd
import os
from sqlalchemy import create_engine
from dotenv import load_dotenv
from sqlalchemy import text

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
    url_conexion = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"
    engine = create_engine(url_conexion)
    return engine


def read_viewing_sessions():
    user_path = DATA_PATH / "raw/viewing_sessions_v1.csv"
    df = pd.read_csv(user_path, parse_dates=["started_at"])
    return df


def main():
    try:
        load_dotenv()
    except Exception as e:
        print(f"Error al cargar el archivo .env: {e}")
        return

    try:
        engine = connect_db()
    except Exception as e:
        print(f"Error al conectar a la base de datos: {e}")
        return

    try:
        df = read_viewing_sessions()

    except Exception as e:
        print(f"Error al leer el archivo CSV: {e}")
        return

    with engine.begin() as conn:
        conn.execute(text("TRUNCATE TABLE viewing_session CASCADE"))
    try:
        df.to_sql("viewing_session", engine, if_exists="append", index=False)
        print("\nMovies cargadas correctamente a PostgreSQL")
    except Exception as e:
        print(f"Error al cargar los datos a PostgreSQL: {e}")


if __name__ == "__main__":
    main()

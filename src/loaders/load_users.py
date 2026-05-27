import pandas as pd
import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

from pathlib import Path
import sys

SRC_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SRC_DIR))

from paths import DATA_PATH


def main():
    load_dotenv()

    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    db_name = os.getenv("DB_NAME")

    user_path = DATA_PATH / "raw/users_v1.csv"
    df = pd.read_csv(user_path)

    url_conexion = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"
    engine = create_engine(url_conexion)

    df.to_sql("users", engine, if_exists="append", index=False)
    print("Usuarios cargados correctamente a Postgree")


if __name__ == "__main__":
    main()

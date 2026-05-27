"""
Generador base de usuarios

La tabla cuenta con las columnas:
    - user_id
    - sign_up_date
    - gender
    - birth_date
"""

from datetime import datetime, timedelta
import pandas as pd
import uuid
import random

from pathlib import Path

SRC_DIR = Path(__file__).resolve().parent
ROOT_DIR = SRC_DIR.parent.parent

DATA_PATH = ROOT_DIR / "data"


def generate_id():
    return str(uuid.uuid4())


def generate_signup_date():
    today = datetime.now()
    days_since_signup = random.randint(0, 1095)
    signup_date = today - timedelta(days=days_since_signup)
    return signup_date.strftime("%Y-%m-%d")


def generate_gender():
    genders = ["Male", "Female"]
    chosen_gender = random.choice(genders)

    return chosen_gender


def generate_birth_date():
    today = datetime.now()

    age_range = [
        (0, 12),
        (13, 19),
        (20, 40),
        (41, 59),
        (60, 90),
    ]

    weigths_age = [
        2,  # 2%  age < 13
        13,  # 13% age 13-19
        65,  # 65% age 20-40
        17,  # 17% age 41-59
        3,  # 3% age > 60
    ]

    chosen_range = random.choices(age_range, weights=weigths_age, k=1)[0]

    age = random.randint(chosen_range[0], chosen_range[1])

    days_since_birth = int(age * 365.25) + random.randint(0, 364)
    birth_date = today - timedelta(days=days_since_birth)

    return birth_date.strftime("%Y-%m-%d")


def main():
    users = []
    amount = 100

    for _ in range(amount):
        id = generate_id()
        signup_date = generate_signup_date()
        gender = generate_gender()
        birth_date = generate_birth_date()

        user = {
            "user_id": id,
            "sign_up_date": signup_date,
            "gender": gender,
            "birth_date": birth_date,
        }

        users.append(user)

    df_users = pd.DataFrame(users)

    print(df_users.info())
    print(df_users.head())

    DATA_PATH.mkdir(parents=True, exist_ok=True)
    users_data_path = DATA_PATH / "raw/users_v1.csv"

    df_users.to_csv(users_data_path, index=False, encoding="utf-8")
    print(f"\nGuardado correctamente en: {users_data_path}")


if __name__ == "__main__":
    random.seed(42)
    main()

"""
Generar eventos diarios, cada evento cuenta con:

    - viewing_session_id: int
    - event_id: int
    - movie_id: int
    - started_at: date-time
    - watch_time_minutes: INT
    - completed: int (1/0)
    - language: string
    - subtitles_enabled: int (1/0)
    - video_quality: int
    - playback_speed: float
"""

from datetime import datetime, timedelta
import pandas as pd
import uuid
import random

from pathlib import Path
import sys

SRC_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SRC_DIR))

from paths import DATA_PATH


def generate_id():
    return str(uuid.uuid4())


def add_activity_level(df):
    df = df.copy()

    levels = ["low", "medium", "high"]
    level_weights = [20, 50, 30]

    chosen_level = random.choices(levels, weights=level_weights, k=len(df))

    df["activity_level"] = chosen_level

    return df


def main():
    users = pd.read_csv(DATA_PATH / "raw/users_v1.csv")
    movies = pd.read_csv(DATA_PATH / "raw/movies_v1.csv")

    activity_range = {  # Sesiones al año
        "low": {"min": 50, "max": 120},
        "medium": {"min": 120, "max": 250},
        "high": {"min": 250, "max": 500},
    }

    range_days = 720

    users = add_activity_level(users)

    print(users.head())
    print(movies.head())

    events = []
    amount = 500

    df_events = pd.DataFrame(events)

    print(df_events.info())
    print(df_events.head())

    """
    DATA_PATH.mkdir(parents=True, exist_ok=True)
    events_data_path = DATA_PATH / "raw/events_v1.csv"

    df_events.to_csv(events_data_path, index=False, encoding="utf-8")
    print(f"\nGuardado correctamente en: {events_data_path}")
    """


if __name__ == "__main__":
    random.seed(42)
    main()

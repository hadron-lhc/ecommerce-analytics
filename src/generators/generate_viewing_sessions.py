"""
Generar sesiones de visualización, cada sesión cuenta con:

    - viewing_session_id: uuid (str)
    - user_id: uuid (str)
    - movie_id: uuid (str)
    - started_at: datetime (str)
    - watch_time_minutes: int
    - completed: int (0/1)
    - language: string
    - subtitles_enabled: int (0/1)
    - video_quality: string (Low/Medium/High)
    - playback_speed: float
"""

from datetime import datetime, timedelta
import pandas as pd
import uuid
import random

from config import USERS_PREFERENCES

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


def add_favorite_genre(df):
    df = df.copy()

    genres = list(USERS_PREFERENCES.keys())
    genre_weights = list(USERS_PREFERENCES.values())
    normalize_wieghts = [k * 0.01 for k in genre_weights]

    chosen_genre = random.choices(genres, weights=normalize_wieghts, k=len(df))
    df["favorite_genre"] = chosen_genre

    return df


def determine_amount_sessions(activity_level, activity_range):
    if activity_level == "low":
        return random.randint(
            activity_range["low"]["min"], activity_range["low"]["max"]
        )
    elif activity_level == "medium":
        return random.randint(
            activity_range["medium"]["min"], activity_range["medium"]["max"]
        )
    else:
        return random.randint(
            activity_range["high"]["min"], activity_range["high"]["max"]
        )


def generate_random_date(user, range_days):
    """
    Generar una fecha aleatoria, de momento completamente
    aletoria dentro del rango de dias
    """
    start_date = datetime.now() - timedelta(days=range_days)
    end_date = datetime.now()
    random_date = start_date + (end_date - start_date) * random.random()
    return random_date.strftime("%Y-%m-%d %H:%M:%S")


def select_movie(user, movies):
    """
    Seleccionar una película basándose en las preferencias del usuario.
    En este caso, en la columna user["favorite_genre"]
    """

    favorite_genre = user["favorite_genre"]

    favorite_movies = movies[movies["main_genre"] == favorite_genre]

    if random.random() < 0.7 and not favorite_movies.empty:
        return favorite_movies.sample(n=1).iloc[0]

    other_movies = movies[movies["main_genre"] != favorite_genre]
    genres = other_movies["main_genre"].unique()
    genre_weights = [
        USERS_PREFERENCES[genre] for genre in genres if genre != favorite_genre
    ]
    normalize_weights = [k * 0.01 for k in genre_weights]

    selected_genre = random.choices(genres, weights=normalize_weights, k=1)[0]
    selected_movie = (
        other_movies[other_movies["main_genre"] == selected_genre].sample(n=1).iloc[0]
    )

    return selected_movie


def generate_watch_time(user, date, movie):
    """
    Generar un tiempo de visualización basado en la duración de la película
    y el comportamiento del usuario.
    """
    base_watch_time = movie["duration_minutes"] * random.uniform(0.92, 1.0)

    if user["activity_level"] == "high":
        return int(base_watch_time * random.uniform(0.85, 1.0))
    elif user["activity_level"] == "medium":
        return int(base_watch_time * random.uniform(0.80, 1.0))
    else:
        return int(base_watch_time * random.uniform(0.75, 1.0))


def determine_completed(watch_time, duration):
    """
    Determinar si la película se completó o no basándose en el tiempo de visualización
    y la duración de la película.
    """
    if watch_time >= duration * 0.9:
        return 1
    else:
        return 0


def select_language(user, movie):
    """
    Seleccionar el idioma de visualizacion, de momento es puramente random
    Solo tendremos ciertas preferencias por el ingles y el japones en el anime
    """
    if "Anime" in movie["main_genre"]:
        return random.choices(["English", "Japanese"], weights=[0.4, 0.6], k=1)[0]
    else:
        return random.choices(
            ["English", "Spanish", "French"], weights=[0.6, 0.3, 0.1], k=1
        )[0]


def determine_subtitles(user, language):
    """
    Mas probable que los substitulos esten activados si el idioma no es ingles
    y si el usuario es mayor a 35 años
    """
    if language != "English" or user["age"] > 35:
        return random.choices([1, 0], weights=[0.7, 0.3], k=1)[0]
    else:
        return random.choices([1, 0], weights=[0.3, 0.7], k=1)[0]


def generate_playback_speed():
    speeds = [0.5, 0.75, 0.85, 0.9, 0.95, 1.0, 1.05, 1.1, 1.15, 1.2, 1.25, 1.5, 2.0]
    weights = [1, 2, 3, 5, 8, 30, 10, 8, 5, 5, 3, 2, 1]
    return random.choices(speeds, weights=weights, k=1)[0]


def select_video_quality(user):
    """
    Seleccionar la calidad de video basándose en el nivel de actividad del usuario.
    Los usuarios con mayor actividad podrían preferir una calidad de video más alta.
    """
    qualities = ["High", "Medium", "Low"]
    if user["activity_level"] == "high":
        return random.choices(qualities, weights=[0.9, 0.1, 0.05], k=1)[0]
    elif user["activity_level"] == "medium":
        return random.choices(qualities, weights=[0.7, 0.2, 0.1], k=1)[0]
    else:
        return random.choices(qualities, weights=[0.5, 0.4, 0.1], k=1)[0]


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
    users = add_favorite_genre(users)

    users["age"] = users["birth_date"].apply(
        lambda x: (datetime.now() - datetime.strptime(x, "%Y-%m-%d")).days // 365
    )
    events = []

    for user in users.to_dict(orient="records"):
        amount_sessions = determine_amount_sessions(
            user["activity_level"], activity_range
        )

        for _ in range(amount_sessions):
            date = generate_random_date(user, range_days)
            movie = select_movie(user, movies)
            watch_time = generate_watch_time(user, date, movie)
            completed = determine_completed(watch_time, movie["duration_minutes"])
            language = select_language(user, movie)
            subtitles_enabled = determine_subtitles(user, language)
            video_quality = select_video_quality(user)

            playback_speed = generate_playback_speed()

            event = {
                "viewing_session_id": generate_id(),
                "user_id": user["user_id"],
                "movie_id": movie["movie_id"],
                "started_at": date,
                "watch_time_minutes": watch_time,
                "completed": completed,
                "language": language,
                "subtitles_enabled": subtitles_enabled,
                "video_quality": video_quality,
                "playback_speed": playback_speed,
            }

            events.append(event)

    df_events = pd.DataFrame(events)

    print(df_events.info())

    DATA_PATH.mkdir(parents=True, exist_ok=True)
    events_data_path = DATA_PATH / "raw/viewing_sessions_v1.csv"

    df_events.to_csv(events_data_path, index=False, encoding="utf-8")
    print(f"\nGuardado correctamente en: {events_data_path}")


if __name__ == "__main__":
    random.seed(42)
    main()

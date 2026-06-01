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


def select_movie(user, movies, empty_count):
    """
    Seleccionar una película basándose en las preferencias del usuario.
    De momento solo veremos la edad y el genero como posible indicador
    de preferencias
    """
    # pasar de fecha de nacimiento a edad
    age = user["age"]
    gender = user["gender"]

    # Filtrar películas por género

    filters = ""

    if gender.lower() == "male":
        filters += "Action|Sci-Fi|Horror|Animation|Anime"
    elif gender.lower() == "female":
        filters += "Romance|Drama|Comedy|Animation|Anime"
    else:
        filters += "Action|Comedy|Sci-Fi|Horror|Romance|Drama|Animation|Anime"

    # Filtrar películas por edad
    if age < 18:
        filters += "Animation|Anime|Comedy"
    elif age < 35:
        filters += "Action|Sci-Fi|Horror|Comedy"
    else:
        filters += "Drama|Romance|Comedy"

    filtered_movies = movies[
        movies["main_genre"].str.contains(filters, case=False, na=False)
    ]

    if filtered_movies.empty:
        empty_count += 1

    if filtered_movies.empty:
        return movies.sample(1).iloc[0], empty_count
    else:
        return filtered_movies.sample(1).iloc[0], empty_count


def generate_watch_time(user, date, movie):
    """
    Generar un tiempo de visualización basado en la duración de la película
    y el comportamiento del usuario.
    """
    base_watch_time = movie["duration_minutes"] * random.uniform(0.5, 1.0)

    if user["activity_level"] == "high":
        return int(base_watch_time * random.uniform(0.8, 1.0))
    elif user["activity_level"] == "medium":
        return int(base_watch_time * random.uniform(0.6, 0.9))
    else:
        return int(base_watch_time * random.uniform(0.4, 0.8))


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


def select_video_quality(user):
    """
    Seleccionar la calidad de video basándose en el nivel de actividad del usuario.
    Los usuarios con mayor actividad podrían preferir una calidad de video más alta.
    """
    if user["activity_level"] == "high":
        return random.choices([1080, 720, 480], weights=[0.7, 0.2, 0.1], k=1)[0]
    elif user["activity_level"] == "medium":
        return random.choices([720, 480, 360], weights=[0.5, 0.3, 0.2], k=1)[0]
    else:
        return random.choices([480, 360, 240], weights=[0.4, 0.4, 0.2], k=1)[0]


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
    users["age"] = users["birth_date"].apply(
        lambda x: (datetime.now() - datetime.strptime(x, "%Y-%m-%d")).days // 365
    )
    events = []

    empty_count = 0

    for user in users.to_dict(orient="records"):
        amount_sessions = determine_amount_sessions(
            user["activity_level"], activity_range
        )

        for _ in range(amount_sessions):
            date = generate_random_date(user, range_days)
            movie, empty_count = select_movie(user, movies, empty_count)
            watch_time = generate_watch_time(user, date, movie)
            completed = determine_completed(watch_time, movie["duration_minutes"])
            language = select_language(user, movie)
            subtitles_enabled = determine_subtitles(user, language)
            video_quality = select_video_quality(user)

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
            }

            events.append(event)

    df_events = pd.DataFrame(events)

    print(df_events.shape)

    print(df_events["completed"].value_counts(normalize=True))
    print(df_events.groupby("movie_id").size().describe())
    print(df_events.groupby("user_id").size().describe())

    """
    DATA_PATH.mkdir(parents=True, exist_ok=True)
    events_data_path = DATA_PATH / "raw/events_v1.csv"

    df_events.to_csv(events_data_path, index=False, encoding="utf-8")
    print(f"\nGuardado correctamente en: {events_data_path}")
    """


if __name__ == "__main__":
    random.seed(42)
    main()

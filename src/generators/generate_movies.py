"""
Generador base de usuarios

La tabla cuenta con las columnas:
    - movie_id: UUID
    - name: string
    - main_genre: string
    - genres: array - strings
    - duration_minutes: INT
    - release_date: date-time

"""

from datetime import datetime, timedelta
import pandas as pd
import uuid
import random

from config import GENERES_AND_DISTRIBUTION

from pathlib import Path
import sys

SRC_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SRC_DIR))

from generators.config import (
    GENRE_DURATIONS,
    SUBGENRES,
    GENERIC_WORDS,
    THEME_WORDS,
    ERAS,
    GENRE_ERA_PROBABILITY,
    DEFAULT_PROBABILITY,
)
from paths import DATA_PATH


def generate_id():  # UUID
    return str(uuid.uuid4())


def generate_title(main_genre) -> str:
    words = THEME_WORDS.get(main_genre, GENERIC_WORDS)

    structure = random.choice(words["structures"])

    noun1, noun2 = (
        random.sample(words["nouns"], 2)
        if len(words["nouns"]) > 1
        else (words["nouns"][0], words["nouns"][0])
    )
    adj1 = random.choice(words["adjectives"])

    title = structure.format(adj=adj1, noun=noun1)

    if "{noun} of {noun}" in structure:
        title = f"{noun1} of {noun2}"
    elif "in the {noun}" in structure:
        title = (
            f"The {noun1} in the {noun2}"
            if "The {noun} in the {noun}" == structure
            else title
        )
    return title


def generate_main_genre() -> str:
    genres = list(GENERES_AND_DISTRIBUTION.keys())
    weigth_distribution = list(GENERES_AND_DISTRIBUTION.values())
    choosen_genre = random.choices(genres, weights=weigth_distribution, k=1)[0]

    return choosen_genre


def generate_genres(main_genre) -> list[str]:
    items = SUBGENRES[main_genre]

    size_options = [1, 2, 3]
    size_weights = [60, 30, 10]

    choosen_size = random.choices(size_options, weights=size_weights, k=1)[0]

    genres = random.sample(items, k=choosen_size)

    return genres


def generate_duration(main_genre) -> int:
    min = GENRE_DURATIONS[main_genre]["min"]
    max = GENRE_DURATIONS[main_genre]["max"]

    duration = random.randint(min, max)

    return duration


# Helper
# -----------------------------------------------------


def generate_random_date_in_range(start_year, end_year):
    start_date = datetime(start_year, 1, 1)
    today = datetime.today()
    if end_year < today.year:
        end_date = datetime(end_year, 12, 31)
    else:
        end_date = datetime.today()

    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randint(0, days_between_dates)

    return start_date + timedelta(days=random_number_of_days)


# ------------------------------------------------------


def generate_release_date(main_genre):  # Date
    weights = GENRE_ERA_PROBABILITY.get(main_genre, DEFAULT_PROBABILITY)
    era_names = list(ERAS.keys())

    chosen_era = random.choices(era_names, weights=weights, k=1)[0]

    start_year, end_year = ERAS[chosen_era]

    release_date = generate_random_date_in_range(start_year, end_year)

    return release_date.strftime("%Y-%m-%d")


def main():
    movies = []
    amount = 200

    for _ in range(amount):
        id = generate_id()
        main_genre = generate_main_genre()
        title = generate_title(main_genre)
        genres = generate_genres(main_genre)
        duration_minutes = generate_duration(main_genre)
        release_date = generate_release_date(main_genre)

        movie = {
            "movie_id": id,
            "title": title,
            "main_genre": main_genre,
            "genres": genres,
            "duration_minutes": duration_minutes,
            "release_date": release_date,
        }

        movies.append(movie)

    df_movies = pd.DataFrame(movies)

    print(df_movies.info())
    print(df_movies.head())

    DATA_PATH.mkdir(parents=True, exist_ok=True)
    movies_data_path = DATA_PATH / "raw/movies_v1.csv"

    df_movies.to_csv(movies_data_path, index=False, encoding="utf-8")
    print(f"\nGuardado correctamente en: {movies_data_path}")


if __name__ == "__main__":
    random.seed(42)
    main()

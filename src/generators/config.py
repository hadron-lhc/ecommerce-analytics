GENERES_AND_DISTRIBUTION = {
    "Action": 22,
    "Drama": 18,
    "Comedy": 18,
    "Horror": 15,
    "Romance": 12,
    "Anime": 8,
    "Animation": 4,
    "Documentary": 2,
    "Short Film": 1,
}

USERS_PREFERENCES = {
    "Action": 25,
    "Drama": 15,
    "Comedy": 10,
    "Horror": 15,
    "Romance": 15,
    "Anime": 10,
    "Animation": 7,
    "Documentary": 2,
    "Short Film": 1,
}


SUBGENRES = {
    "Action": [
        "Adventure",
        "Superheroes",
        "Military",
        "Crime",
        "Thriller",
        "Sci-Fi Action",
        "Martial Arts",
    ],
    "Drama": [
        "Biographical",
        "Historical",
        "Family",
        "Legal",
        "Psychological",
        "Melodrama",
    ],
    "Comedy": [
        "Slapstick",
        "Satire",
        "Dark Comedy",
        "Sitcom",
        "Parody",
    ],
    "Horror": [
        "Gore",
        "Suspense",
        "Survival",
        "Supernatural",
        "Slasher",
        "Psychological Horror",
    ],
    "Romance": [
        "Teen Romance",
        "Historical Romance",
        "Romantic Drama",
        "Romantic Comedy",
        "Erotic Romance",
    ],
    "Anime": [
        "Shonen",
        "Seinen",
        "Isekai",
        "Mecha",
        "Slice of Life",
        "Shojo",
    ],
    "Animation": [
        "Family",
        "Adventure",
        "Fantasy",
        "Musical",
        "Sci-Fi",
    ],
    "Documentary": [
        "Nature",
        "History",
        "Science",
        "True Crime",
        "Social Issues",
    ],
    "Short Film": [
        "Animated Short",
        "Live Action Short",
        "Experimental",
    ],
}

GENRE_DURATIONS = {
    "Action": {"min": 100, "max": 135},
    "Drama": {"min": 100, "max": 140},
    "Comedy": {"min": 85, "max": 105},
    "Horror": {"min": 85, "max": 105},
    "Romance": {"min": 90, "max": 115},
    "Anime": {"min": 80, "max": 110},
    "Animation": {"min": 80, "max": 95},
    "Documentary": {"min": 75, "max": 110},
    "Short Film": {"min": 1, "max": 40},
}

THEME_WORDS = {
    "Action": {
        "nouns": [
            "Mission",
            "Target",
            "Vengeance",
            "Blood",
            "Agent",
            "Justice",
            "Frontier",
            "Shadow",
        ],
        "adjectives": [
            "Deadly",
            "Secret",
            "Ultimate",
            "Red",
            "Dark",
            "Silent",
            "Extreme",
            "Fallen",
        ],
        "structures": [
            "The {adj} {noun}",  # Ej: The Deadly Target
            "The {adj}",
            "{noun} of {noun}",  # Ej: Agent of Justice
        ],
    },
    "Horror": {
        "nouns": [
            "Nightmare",
            "Curse",
            "Shadow",
            "Woods",
            "Demon",
            "Asylum",
            "Cabin",
            "Whisper",
            "Mirror",
        ],
        "adjectives": [
            "Haunted",
            "Cursed",
            "Bloody",
            "Evil",
            "Forgotten",
            "Dark",
            "Incurable",
        ],
        "structures": [
            "The {noun} in the {noun}",  # Ej: The Demon in the Woods
            "The {adj} {noun}",  # Ej: The Haunted Cabin
            "Don't {noun}",  # Ej: Don't Whisper (un verbo/sustantivo adaptado)
        ],
    },
    "Romance": {
        "nouns": [
            "Heart",
            "Love",
            "Promise",
            "Destiny",
            "Summer",
            "Whisper",
            "Rain",
            "Kiss",
            "Autumn",
        ],
        "adjectives": [
            "Eternal",
            "Sweet",
            "Secret",
            "Lost",
            "Beautiful",
            "First",
            "Lasting",
        ],
        "structures": [
            "A {adj} {noun}",  # Ej: A Sweet Promise
            "{noun} of {noun}",  # Ej: Destiny of Love
            "Our {adj} {noun}",  # Ej: Our Eternal Summer
        ],
    },
    "Comedy": {
        "nouns": [
            "Boss",
            "Party",
            "Trip",
            "Wedding",
            "Neighbor",
            "Dude",
            "Detective",
            "Night",
        ],
        "adjectives": [
            "Crazy",
            "Wild",
            "Worst",
            "Fake",
            "Hilarious",
            "Accidental",
            "Bad",
        ],
        "structures": [
            "My {adj} {noun}",  # Ej: My Crazy Boss
            "The {adj} {noun}",  # Ej: The Worst Wedding
            "An {adj} {noun}",  # Ej: An Accidental Trip
        ],
    },
}

# Palabras genéricas de respaldo si el género no está definido arriba
GENERIC_WORDS = {
    "nouns": ["Chronicles", "Story", "World", "Legacy", "Time", "Life", "Man", "Day"],
    "adjectives": ["The Last", "New", "Great", "True", "Unknown", "Golden", "Hidden"],
    "structures": ["The {adj} {noun}", "{noun} of {noun}", "{adj} {noun}"],
}


ERAS = {
    "golden_age": (1940, 1979),
    "modern_age": (1980, 1999),
    "digital_age": (2000, 2014),
    "streaming_age": (2015, 2026),  # Actualizado al año corriente
}

# 2. Asignamos los pesos (probabilidades) de cada era por género.
# El orden de los pesos corresponde a: [golden_age, modern_age, digital_age, streaming_age]
GENRE_ERA_PROBABILITY = {
    "Anime": [0.01, 0.09, 0.40, 0.50],  # Ultra concentrado en lo nuevo
    "Animation": [
        0.05,
        0.15,
        0.40,
        0.40,
    ],  # Mayormente nuevo, pero con clásicos de Disney
    "Drama": [
        0.15,
        0.25,
        0.30,
        0.30,
    ],  # Distribución muy amplia, acepta clásicos viejos
    "Romance": [0.12, 0.23, 0.35, 0.30],  # Similar al drama
    "Comedy": [0.10, 0.30, 0.30, 0.30],  # Fuerte en los 80s/90s en adelante
    "Action": [0.03, 0.37, 0.30, 0.30],  # Explosión en los 80s y 90s
    "Horror": [0.08, 0.32, 0.30, 0.30],  # Clásicos de terror vs cine moderno
    "Documentary": [0.02, 0.08, 0.30, 0.60],  # Explotó con las plataformas de streaming
    "Short Film": [0.05, 0.15, 0.35, 0.45],
}

# Configuración por defecto si entra un género no registrado
DEFAULT_PROBABILITY = [0.05, 0.25, 0.35, 0.35]

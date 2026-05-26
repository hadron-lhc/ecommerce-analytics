CREATE TABLE IF NOT EXISTS users (
  user_id INT PRIMARY KEY,
  sign_up_date TIMESTAMP,
  gender CHAR(1) NOT NULL,
  birth_date DATE
);

CREATE TABLE IF NOT EXISTS movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    main_genre VARCHAR(100) NOT NULL,
    genres VARCHAR(100)[] , -- Arreglo de strings nativo en PostgreSQL
    duration_minutes INT NOT NULL,
    release_date DATE
);

-- Crear tabla principal: viewing_session
CREATE TABLE IF NOT EXISTS viewing_session (
    viewing_session_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    started_at TIMESTAMP NOT NULL,
    watch_time_minutes INT NOT NULL >= 0,
    completed INT NOT NULL CHECK (completed IN (0, 1)), -- Restringe a 1 o 0
    language VARCHAR(50),
    subtitles_enabled INT CHECK (subtitles_enabled IN (0, 1)),
    video_quality INT,
    playback_speed FLOAT > 0,

    -- Definición de Llaves Foráneas (FK)
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

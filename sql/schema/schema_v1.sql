DROP TABLE IF EXISTS viewing_session;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS movies;


CREATE TABLE users (
  user_id UUID PRIMARY KEY,
  sign_up_date TIMESTAMP NOT NULL,
  gender CHAR(1) NOT NULL,
  birth_date DATE
);

CREATE TABLE  movies (
    movie_id UUID PRIMARY KEY,
    title VARCHAR(255),
    main_genre VARCHAR(100) NOT NULL,
    genres VARCHAR(100)[] , -- Arreglo de strings nativo en PostgreSQL
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    release_date DATE
);

-- Crear tabla principal: viewing_session
CREATE TABLE  viewing_session (
    viewing_session_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    movie_id UUID NOT NULL,
    started_at TIMESTAMP NOT NULL,
    watch_time_minutes INT NOT NULL CHECK (watch_time_minutes >= 0),
    completed INT NOT NULL CHECK (completed IN (0, 1)), -- Restringe a 1 o 0
    language VARCHAR(50),
    subtitles_enabled INT CHECK (subtitles_enabled IN (0, 1)),
    video_quality VARCHAR(20) CHECK (video_quality IN ('Low', 'Medium', 'High')),
    playback_speed FLOAT CHECK (playback_speed > 0),

    -- Definición de Llaves Foráneas (FK)
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS employees (
    id          INTEGER PRIMARY KEY,
    full_name   TEXT    NOT NULL,
    phone       TEXT    NOT NULL UNIQUE,          -- только цифры: 996555123456
    tg_id       INTEGER UNIQUE,                   -- NULL, пока не зарегистрировался
    is_manager  INTEGER NOT NULL DEFAULT 0 CHECK (is_manager IN (0, 1)),
    active      INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0, 1)),
    created_at  TEXT    NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS attendance (
    id           INTEGER PRIMARY KEY,
    employee_id  INTEGER NOT NULL REFERENCES employees(id),
    kind         TEXT    NOT NULL CHECK (kind IN ('in', 'out')),
    marked_at    TEXT    NOT NULL,                -- '2026-11-13 08:57:12'
    late_min     INTEGER NOT NULL DEFAULT 0,      -- опоздание (для 'in')
    latitude     REAL,                            -- геолокация (этап 5)
    longitude    REAL,
    distance_m   INTEGER,                         -- расстояние до офиса
    CHECK (marked_at GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]')
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_attendance_day
    ON attendance (employee_id, kind, substr(marked_at, 1, 10));
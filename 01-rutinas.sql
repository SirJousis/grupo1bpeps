CREATE DATABASE IF NOT EXISTS gym_app;
USE gym_app;

CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'AppPassword123!';
GRANT ALL PRIVILEGES ON gym_app.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
-- CREATE USER IF NOT EXISTS 'alumno'@'%' IDENTIFIED BY 'alumno';
-- GRANT ALL PRIVILEGES ON peps_team.* TO 'alumno'@'localhost';
-- FLUSH PRIVILEGES;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 0,
    failed_attempts INT DEFAULT 0,
    locked_until DATETIME NULL,
    otp_secret VARCHAR(32) NULL
);

-- hardcodeadas
CREATE TABLE rutinas_base (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    objetivo ENUM('fuerza', 'cardio', 'hibrido') NOT NULL,
    nivel ENUM('basico', 'intermedio', 'avanzado') NOT NULL,
    dias INT NOT NULL,
    rutina_json JSON NOT NULL
);

-- insertar hardcodeadas las seleccionadas por usuario de las rutinas_base 

CREATE TABLE rutinas_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    rutina_base_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (rutina_base_id) REFERENCES rutinas_base(id)
);

CREATE TABLE comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_usuario INT NOT NULL,
    id_rutina INT NOT NULL,

    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (id_rutina) REFERENCES rutinas_base(id) ON DELETE CASCADE
);



CREATE TABLE ficheros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    nombre_original VARCHAR(255) NOT NULL,
    nombre_guardado VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

INSERT INTO usuarios (username, password)
VALUES (
  'admin',
  'scrypt:32768:8:1$QQlHBhSQNI3Gsx19$d6dec7d7f06cc019d96d4768abcee9536adf392650c33ac03fc0d2a79913dfab126057f1bbfd2186ca031c0e41fd22c49002fd7756f57d815d602ae07c9c3b93'
);
-- INSERTS DE RUTINAS BASE --
-- Full Body Fuerza basico 1 dia
-- ==================== FUERZA ====================

-- BÁSICO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Fuerza Básico 1 día', 'fuerza', 'basico', 1, '{"dias": [{"dia": 1, "nombre": "Full Body", "ejercicios": [{"nombre": "Sentadilla Copa", "series": 3, "reps": "12"}, {"nombre": "Flexiones", "series": 3, "reps": "10"}, {"nombre": "Remo Mancuerna", "series": 3, "reps": "12"}]}]}'),
('Fuerza Básico 2 días', 'fuerza', 'basico', 2, '{"dias": [{"dia": 1, "nombre": "Torso", "ejercicios": [{"nombre": "Press Banca", "series": 3, "reps": "10"}, {"nombre": "Jalón Pecho", "series": 3, "reps": "12"}]}, {"dia": 2, "nombre": "Pierna", "ejercicios": [{"nombre": "Sentadilla", "series": 3, "reps": "12"}, {"nombre": "Peso Muerto Rumano", "series": 3, "reps": "10"}]}]}'),
('Fuerza Básico 3 días', 'fuerza', 'basico', 3, '{"dias": [{"dia": 1, "nombre": "Pecho/Tríceps", "ejercicios": [{"nombre": "Press Banca", "series": 3, "reps": "10"}, {"nombre": "Fondos", "series": 3, "reps": "8"}]}, {"dia": 2, "nombre": "Espalda/Bíceps", "ejercicios": [{"nombre": "Remo", "series": 3, "reps": "12"}, {"nombre": "Curl", "series": 3, "reps": "12"}]}, {"dia": 3, "nombre": "Pierna", "ejercicios": [{"nombre": "Prensa", "series": 3, "reps": "12"}, {"nombre": "Zancadas", "series": 3, "reps": "12"}]}]}'),
('Fuerza Básico 4 días', 'fuerza', 'basico', 4, '{"dias": [{"dia": 1, "nombre": "Torso", "ejercicios": [{"nombre": "Press Banca", "series": 3, "reps": "10"}]}, {"dia": 2, "nombre": "Pierna", "ejercicios": [{"nombre": "Sentadilla", "series": 3, "reps": "10"}]}, {"dia": 3, "nombre": "Torso", "ejercicios": [{"nombre": "Press Militar", "series": 3, "reps": "10"}]}, {"dia": 4, "nombre": "Pierna", "ejercicios": [{"nombre": "Prensa", "series": 3, "reps": "12"}]}]}'),
('Fuerza Básico 5 días', 'fuerza', 'basico', 5, '{"dias": [{"dia": 1, "nombre": "Pecho", "ejercicios": [{"nombre": "Press Banca", "series": 3, "reps": "10"}]}, {"dia": 2, "nombre": "Espalda", "ejercicios": [{"nombre": "Remo", "series": 3, "reps": "10"}]}, {"dia": 3, "nombre": "Descanso Activo", "ejercicios": []}, {"dia": 4, "nombre": "Pierna", "ejercicios": [{"nombre": "Sentadilla", "series": 3, "reps": "10"}]}, {"dia": 5, "nombre": "Hombro/Brazo", "ejercicios": [{"nombre": "Militar", "series": 3, "reps": "10"}]}]}');

-- INTERMEDIO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Fuerza Intermedio 1 día', 'fuerza', 'intermedio', 1, '{"dias": [{"dia": 1, "nombre": "Full Body Intenso", "ejercicios": [{"nombre": "Peso Muerto", "series": 4, "reps": "6"}, {"nombre": "Press Banca", "series": 4, "reps": "8"}, {"nombre": "Dominadas", "series": 3, "reps": "Fall"}]}]}'),
('Fuerza Intermedio 2 días', 'fuerza', 'intermedio', 2, '{"dias": [{"dia": 1, "nombre": "Torso Fuerza", "ejercicios": [{"nombre": "Press Banca", "series": 4, "reps": "6"}, {"nombre": "Remo Barra", "series": 4, "reps": "8"}]}, {"dia": 2, "nombre": "Pierna Fuerza", "ejercicios": [{"nombre": "Sentadilla", "series": 4, "reps": "6"}, {"nombre": "Hip Thrust", "series": 3, "reps": "10"}]}]}'),
('Fuerza Intermedio 3 días', 'fuerza', 'intermedio', 3, '{"dias": [{"dia": 1, "nombre": "Empuje", "ejercicios": [{"nombre": "Press Banca", "series": 4, "reps": "8"}]}, {"dia": 2, "nombre": "Tracción", "ejercicios": [{"nombre": "Dominadas", "series": 4, "reps": "8"}]}, {"dia": 3, "nombre": "Pierna", "ejercicios": [{"nombre": "Sentadilla", "series": 4, "reps": "6"}]}]}'),
('Fuerza Intermedio 4 días', 'fuerza', 'intermedio', 4, '{"dias": [{"dia": 1, "nombre": "Torso A", "ejercicios": [{"nombre": "Press Banca", "series": 4, "reps": "6"}]}, {"dia": 2, "nombre": "Pierna A", "ejercicios": [{"nombre": "Sentadilla", "series": 4, "reps": "6"}]}, {"dia": 3, "nombre": "Torso B", "ejercicios": [{"nombre": "Militar", "series": 4, "reps": "8"}]}, {"dia": 4, "nombre": "Pierna B", "ejercicios": [{"nombre": "Peso Muerto", "series": 4, "reps": "6"}]}]}'),
('Fuerza Intermedio 5 días', 'fuerza', 'intermedio', 5, '{"dias": [{"dia": 1, "nombre": "Pecho", "ejercicios": [{"nombre": "Press Banca", "series": 5, "reps": "5"}]}, {"dia": 2, "nombre": "Espalda", "ejercicios": [{"nombre": "Remo", "series": 5, "reps": "5"}]}, {"dia": 3, "nombre": "Pierna", "ejercicios": [{"nombre": "Sentadilla", "series": 5, "reps": "5"}]}, {"dia": 4, "nombre": "Hombro", "ejercicios": [{"nombre": "Militar", "series": 4, "reps": "8"}]}, {"dia": 5, "nombre": "Brazos", "ejercicios": [{"nombre": "Curl", "series": 3, "reps": "12"}]}]}');

-- AVANZADO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Fuerza Avanzado 1 día', 'fuerza', 'avanzado', 1, '{"dias": [{"dia": 1, "nombre": "Big Three", "ejercicios": [{"nombre": "Squat", "series": 5, "reps": "3"}, {"nombre": "Bench Press", "series": 5, "reps": "3"}, {"nombre": "Deadlift", "series": 3, "reps": "3"}]}]}'),
('Fuerza Avanzado 2 días', 'fuerza', 'avanzado', 2, '{"dias": [{"dia": 1, "nombre": "Upper Power", "ejercicios": [{"nombre": "Banca Pausa", "series": 5, "reps": "3"}, {"nombre": "Dominadas Lastre", "series": 5, "reps": "3"}]}, {"dia": 2, "nombre": "Lower Power", "ejercicios": [{"nombre": "Sentadilla", "series": 5, "reps": "3"}, {"nombre": "Peso Muerto", "series": 3, "reps": "2"}]}]}'),
('Fuerza Avanzado 3 días', 'fuerza', 'avanzado', 3, '{"dias": [{"dia": 1, "nombre": "Sentadilla", "ejercicios": [{"nombre": "Sentadilla", "series": 6, "reps": "4"}]}, {"dia": 2, "nombre": "Banca", "ejercicios": [{"nombre": "Banca", "series": 6, "reps": "4"}]}, {"dia": 3, "nombre": "Muerto", "ejercicios": [{"nombre": "Peso Muerto", "series": 5, "reps": "2"}]}]}'),
('Fuerza Avanzado 4 días', 'fuerza', 'avanzado', 4, '{"dias": [{"dia": 1, "nombre": "Banca Dinámica", "ejercicios": [{"nombre": "Banca Speed", "series": 8, "reps": "3"}]}, {"dia": 2, "nombre": "Sentadilla Max", "ejercicios": [{"nombre": "Sentadilla", "series": 1, "reps": "1RM"}]}, {"dia": 3, "nombre": "Banca Max", "ejercicios": [{"nombre": "Banca", "series": 1, "reps": "1RM"}]}, {"dia": 4, "nombre": "Accesorios", "ejercicios": [{"nombre": "Tríceps", "series": 5, "reps": "10"}]}]}'),
('Fuerza Avanzado 5 días', 'fuerza', 'avanzado', 5, '{"dias": [{"dia": 1, "nombre": "Pecho", "ejercicios": [{"nombre": "Banca", "series": 5, "reps": "5"}]}, {"dia": 2, "nombre": "Espalda", "ejercicios": [{"nombre": "Dominadas", "series": 5, "reps": "Fall"}]}, {"dia": 3, "nombre": "Pierna", "ejercicios": [{"nombre": "Sentadilla", "series": 5, "reps": "5"}]}, {"dia": 4, "nombre": "Hombro", "ejercicios": [{"nombre": "Militar", "series": 4, "reps": "8"}]}, {"dia": 5, "nombre": "Brazos", "ejercicios": [{"nombre": "Curl", "series": 4, "reps": "10"}]}]}');


-- ==================== CARDIO ====================

-- BÁSICO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Cardio Básico 1 día', 'cardio', 'basico', 1, '{"dias": [{"dia": 1, "nombre": "Caminata", "ejercicios": [{"nombre": "Caminata Rápida", "series": 1, "reps": "45 min"}]}]}'),
('Cardio Básico 2 días', 'cardio', 'basico', 2, '{"dias": [{"dia": 1, "nombre": "Bici", "ejercicios": [{"nombre": "Estática", "series": 1, "reps": "30 min"}]}, {"dia": 2, "nombre": "Caminata", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "40 min"}]}]}'),
('Cardio Básico 3 días', 'cardio', 'basico', 3, '{"dias": [{"dia": 1, "nombre": "Bici", "ejercicios": [{"nombre": "Bicicleta", "series": 1, "reps": "30 min"}]}, {"dia": 2, "nombre": "Descanso", "ejercicios": []}, {"dia": 3, "nombre": "Elíptica", "ejercicios": [{"nombre": "Elíptica", "series": 1, "reps": "30 min"}]}]}'),
('Cardio Básico 4 días', 'cardio', 'basico', 4, '{"dias": [{"dia": 1, "nombre": "Caminata", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "30 min"}]}, {"dia": 2, "nombre": "Bici", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "30 min"}]}, {"dia": 3, "nombre": "Caminata", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "30 min"}]}, {"dia": 4, "nombre": "Bici", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "30 min"}]}]}'),
('Cardio Básico 5 días', 'cardio', 'basico', 5, '{"dias": [{"dia": 1, "nombre": "Lunes", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "30 min"}]}, {"dia": 2, "nombre": "Martes", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "30 min"}]}, {"dia": 3, "nombre": "Miercoles", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "20 min"}]}, {"dia": 4, "nombre": "Jueves", "ejercicios": [{"nombre": "Elíptica", "series": 1, "reps": "20 min"}]}, {"dia": 5, "nombre": "Viernes", "ejercicios": [{"nombre": "Nado suave", "series": 1, "reps": "30 min"}]}]}');

-- INTERMEDIO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Cardio Intermedio 1 día', 'cardio', 'intermedio', 1, '{"dias": [{"dia": 1, "nombre": "Carrera", "ejercicios": [{"nombre": "Running 5k", "series": 1, "reps": "30 min"}]}]}'),
('Cardio Intermedio 2 días', 'cardio', 'intermedio', 2, '{"dias": [{"dia": 1, "nombre": "Running", "ejercicios": [{"nombre": "Trote", "series": 1, "reps": "30 min"}]}, {"dia": 2, "nombre": "HIIT", "ejercicios": [{"nombre": "Intervalos", "series": 8, "reps": "1 min"}]}]}'),
('Cardio Intermedio 3 días', 'cardio', 'intermedio', 3, '{"dias": [{"dia": 1, "nombre": "Running", "ejercicios": [{"nombre": "Trote", "series": 1, "reps": "40 min"}]}, {"dia": 2, "nombre": "HIIT", "ejercicios": [{"nombre": "Sprints", "series": 10, "reps": "30s"}]}, {"dia": 3, "nombre": "Remo", "ejercicios": [{"nombre": "Máquina Remo", "series": 1, "reps": "20 min"}]}]}'),
('Cardio Intermedio 4 días', 'cardio', 'intermedio', 4, '{"dias": [{"dia": 1, "nombre": "Run", "ejercicios": [{"nombre": "Carrera", "series": 1, "reps": "40 min"}]}, {"dia": 2, "nombre": "Bici", "ejercicios": [{"nombre": "Rodaje", "series": 1, "reps": "50 min"}]}, {"dia": 3, "nombre": "Run", "ejercicios": [{"nombre": "Fartlek", "series": 1, "reps": "30 min"}]}, {"dia": 4, "nombre": "Natación", "ejercicios": [{"nombre": "Largos", "series": 1, "reps": "40 min"}]}]}'),
('Cardio Intermedio 5 días', 'cardio', 'intermedio', 5, '{"dias": [{"dia": 1, "nombre": "Running", "ejercicios": [{"nombre": "Carrera", "series": 1, "reps": "45 min"}]}, {"dia": 2, "nombre": "HIIT Bici", "ejercicios": [{"nombre": "Intervalos", "series": 10, "reps": "1 min"}]}, {"dia": 3, "nombre": "Natación", "ejercicios": [{"nombre": "Largos", "series": 1, "reps": "40 min"}]}, {"dia": 4, "nombre": "Comba", "ejercicios": [{"nombre": "Salto Comba", "series": 5, "reps": "3 min"}]}, {"dia": 5, "nombre": "Trekking", "ejercicios": [{"nombre": "Caminata Montaña", "series": 1, "reps": "60 min"}]}]}');

-- AVANZADO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Cardio Avanzado 1 día', 'cardio', 'avanzado', 1, '{"dias": [{"dia": 1, "nombre": "Tirada Larga", "ejercicios": [{"nombre": "Running", "series": 1, "reps": "90 min"}]}]}'),
('Cardio Avanzado 2 días', 'cardio', 'avanzado', 2, '{"dias": [{"dia": 1, "nombre": "Umbral", "ejercicios": [{"nombre": "Series 1km", "series": 6, "reps": "3:50"}]}, {"dia": 2, "nombre": "Fondo", "ejercicios": [{"nombre": "Carrera Larga", "series": 1, "reps": "80 min"}]}]}'),
('Cardio Avanzado 3 días', 'cardio', 'avanzado', 3, '{"dias": [{"dia": 1, "nombre": "Series", "ejercicios": [{"nombre": "1km a tope", "series": 5, "reps": "3:40 min/km"}]}, {"dia": 2, "nombre": "Rodaje", "ejercicios": [{"nombre": "Carrera suave", "series": 1, "reps": "60 min"}]}, {"dia": 3, "nombre": "Tempo", "ejercicios": [{"nombre": "Carrera ritmo umbral", "series": 1, "reps": "40 min"}]}]}'),
('Cardio Avanzado 4 días', 'cardio', 'avanzado', 4, '{"dias": [{"dia": 1, "nombre": "Natación", "ejercicios": [{"nombre": "3000m", "series": 1, "reps": "60 min"}]}, {"dia": 2, "nombre": "Bici", "ejercicios": [{"nombre": "Puerto", "series": 1, "reps": "90 min"}]}, {"dia": 3, "nombre": "Carrera", "ejercicios": [{"nombre": "Series Cortas", "series": 10, "reps": "400m"}]}, {"dia": 4, "nombre": "Transición", "ejercicios": [{"nombre": "Bici+Run", "series": 1, "reps": "60 min"}]}]}'),
('Cardio Avanzado 5 días', 'cardio', 'avanzado', 5, '{"dias": [{"dia": 1, "nombre": "Natación", "ejercicios": [{"nombre": "Series Agua", "series": 1, "reps": "2000m"}]}, {"dia": 2, "nombre": "Bici Rodaje", "ejercicios": [{"nombre": "Bici Ruta", "series": 1, "reps": "2 horas"}]}, {"dia": 3, "nombre": "Carrera", "ejercicios": [{"nombre": "Fartlek", "series": 1, "reps": "50 min"}]}, {"dia": 4, "nombre": "Bici Intensidad", "ejercicios": [{"nombre": "Rodillo", "series": 1, "reps": "60 min"}]}, {"dia": 5, "nombre": "Transición", "ejercicios": [{"nombre": "Bici + Correr", "series": 1, "reps": "90 min"}]}]}');


-- ==================== HÍBRIDO ====================

-- BÁSICO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Híbrido Básico 1 día', 'hibrido', 'basico', 1, '{"dias": [{"dia": 1, "nombre": "Mix", "ejercicios": [{"nombre": "Sentadilla", "series": 3, "reps": "12"}, {"nombre": "Caminata Cinta", "series": 1, "reps": "20 min"}]}]}'),
('Híbrido Básico 2 días', 'hibrido', 'basico', 2, '{"dias": [{"dia": 1, "nombre": "Fuerza FullBody", "ejercicios": [{"nombre": "Sentadilla", "series": 3, "reps": "12"}, {"nombre": "Flexiones", "series": 3, "reps": "10"}]}, {"dia": 2, "nombre": "Cardio", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "30 min"}]}]}'),
('Híbrido Básico 3 días', 'hibrido', 'basico', 3, '{"dias": [{"dia": 1, "nombre": "Fuerza", "ejercicios": [{"nombre": "Full Body", "series": 3, "reps": "12"}]}, {"dia": 2, "nombre": "Cardio", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "30 min"}]}, {"dia": 3, "nombre": "Funcional", "ejercicios": [{"nombre": "Circuito", "series": 3, "reps": "10 min"}]}]}'),
('Híbrido Básico 4 días', 'hibrido', 'basico', 4, '{"dias": [{"dia": 1, "nombre": "Fuerza A", "ejercicios": [{"nombre": "Full Body", "series": 3, "reps": "10"}]}, {"dia": 2, "nombre": "Cardio A", "ejercicios": [{"nombre": "Elíptica", "series": 1, "reps": "30 min"}]}, {"dia": 3, "nombre": "Fuerza B", "ejercicios": [{"nombre": "Full Body", "series": 3, "reps": "10"}]}, {"dia": 4, "nombre": "Cardio B", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "40 min"}]}]}'),
('Híbrido Básico 5 días', 'hibrido', 'basico', 5, '{"dias": [{"dia": 1, "nombre": "Pesas", "ejercicios": [{"nombre": "Máquinas", "series": 3, "reps": "12"}]}, {"dia": 2, "nombre": "Cardio", "ejercicios": [{"nombre": "Elíptica", "series": 1, "reps": "30 min"}]}, {"dia": 3, "nombre": "Pesas", "ejercicios": [{"nombre": "Peso libre", "series": 3, "reps": "10"}]}, {"dia": 4, "nombre": "Cardio", "ejercicios": [{"nombre": "Caminata", "series": 1, "reps": "45 min"}]}, {"dia": 5, "nombre": "Core", "ejercicios": [{"nombre": "Abdominales", "series": 4, "reps": "15"}]}]}');

-- INTERMEDIO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Híbrido Intermedio 1 día', 'hibrido', 'intermedio', 1, '{"dias": [{"dia": 1, "nombre": "Cross Training", "ejercicios": [{"nombre": "Thrusters", "series": 4, "reps": "10"}, {"nombre": "Burpees", "series": 4, "reps": "10"}, {"nombre": "Remo", "series": 1, "reps": "1000m"}]}]}'),
('Híbrido Intermedio 2 días', 'hibrido', 'intermedio', 2, '{"dias": [{"dia": 1, "nombre": "Fuerza", "ejercicios": [{"nombre": "Peso Muerto", "series": 3, "reps": "8"}, {"nombre": "Militar", "series": 3, "reps": "10"}]}, {"dia": 2, "nombre": "Metcon", "ejercicios": [{"nombre": "Box Jumps", "series": 5, "reps": "15"}, {"nombre": "Kettlebell Swing", "series": 5, "reps": "20"}]}]}'),
('Híbrido Intermedio 3 días', 'hibrido', 'intermedio', 3, '{"dias": [{"dia": 1, "nombre": "Fuerza", "ejercicios": [{"nombre": "Torso/Pierna", "series": 4, "reps": "8"}]}, {"dia": 2, "nombre": "Cardio HIIT", "ejercicios": [{"nombre": "Sprints", "series": 8, "reps": "30s"}]}, {"dia": 3, "nombre": "Metcon", "ejercicios": [{"nombre": "WOD", "series": 1, "reps": "20 min"}]}]}'),
('Híbrido Intermedio 4 días', 'hibrido', 'intermedio', 4, '{"dias": [{"dia": 1, "nombre": "Torso Fuerza", "ejercicios": [{"nombre": "Banca", "series": 4, "reps": "6"}]}, {"dia": 2, "nombre": "Pierna Fuerza", "ejercicios": [{"nombre": "Sentadilla", "series": 4, "reps": "6"}]}, {"dia": 3, "nombre": "Run", "ejercicios": [{"nombre": "8km", "series": 1, "reps": "45 min"}]}, {"dia": 4, "nombre": "HIIT", "ejercicios": [{"nombre": "Remo", "series": 10, "reps": "1 min"}]}]}'),
('Híbrido Intermedio 5 días', 'hibrido', 'intermedio', 5, '{"dias": [{"dia": 1, "nombre": "Fuerza A", "ejercicios": [{"nombre": "Sentadilla", "series": 4, "reps": "6"}]}, {"dia": 2, "nombre": "Running", "ejercicios": [{"nombre": "8km", "series": 1, "reps": "45 min"}]}, {"dia": 3, "nombre": "Fuerza B", "ejercicios": [{"nombre": "Press Militar", "series": 4, "reps": "8"}]}, {"dia": 4, "nombre": "Natación", "ejercicios": [{"nombre": "Técnica", "series": 1, "reps": "30 min"}]}, {"dia": 5, "nombre": "Funcional", "ejercicios": [{"nombre": "Kettlebells", "series": 4, "reps": "15"}]}]}');

-- AVANZADO
INSERT INTO rutinas_base (nombre, objetivo, nivel, dias, rutina_json) VALUES
('Híbrido Avanzado 1 día', 'hibrido', 'avanzado', 1, '{"dias": [{"dia": 1, "nombre": "Simulacro Hyrox", "ejercicios": [{"nombre": "SkiErg", "series": 1, "reps": "1000m"}, {"nombre": "Sled Push", "series": 1, "reps": "50m"}, {"nombre": "Running", "series": 1, "reps": "1km"}]}]}'),
('Híbrido Avanzado 2 días', 'hibrido', 'avanzado', 2, '{"dias": [{"dia": 1, "nombre": "Fuerza Max", "ejercicios": [{"nombre": "Squat", "series": 5, "reps": "3"}, {"nombre": "Clean", "series": 3, "reps": "3"}]}, {"dia": 2, "nombre": "Resistencia", "ejercicios": [{"nombre": "Murph", "series": 1, "reps": "Tiempo"}]}]}'),
('Híbrido Avanzado 3 días', 'hibrido', 'avanzado', 3, '{"dias": [{"dia": 1, "nombre": "Fuerza Max", "ejercicios": [{"nombre": "Powerlifting", "series": 5, "reps": "3"}]}, {"dia": 2, "nombre": "Capacidad Aeróbica", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "90 min"}]}, {"dia": 3, "nombre": "Potencia", "ejercicios": [{"nombre": "Olimpicos", "series": 5, "reps": "3"}]}]}'),
('Híbrido Avanzado 4 días', 'hibrido', 'avanzado', 4, '{"dias": [{"dia": 1, "nombre": "Fuerza", "ejercicios": [{"nombre": "Squat/Bench", "series": 5, "reps": "3"}]}, {"dia": 2, "nombre": "Tempo Run", "ejercicios": [{"nombre": "Run", "series": 1, "reps": "10km"}]}, {"dia": 3, "nombre": "Fuerza", "ejercicios": [{"nombre": "Deadlift/Press", "series": 5, "reps": "3"}]}, {"dia": 4, "nombre": "Larga distancia", "ejercicios": [{"nombre": "Bici", "series": 1, "reps": "3h"}]}]}'),
('Híbrido Avanzado 5 días', 'hibrido', 'avanzado', 5, '{"dias": [{"dia": 1, "nombre": "Fuerza Pierna", "ejercicios": [{"nombre": "Squat", "series": 5, "reps": "5"}]}, {"dia": 2, "nombre": "Ruck Run", "ejercicios": [{"nombre": "Correr con lastre", "series": 1, "reps": "5km"}]}, {"dia": 3, "nombre": "Fuerza Torso", "ejercicios": [{"nombre": "Press Banca", "series": 5, "reps": "5"}]}, {"dia": 4, "nombre": "Sprints", "ejercicios": [{"nombre": "Cuestas", "series": 10, "reps": "100m"}]}, {"dia": 5, "nombre": "Resistencia Muscular", "ejercicios": [{"nombre": "Murph", "series": 1, "reps": "Tiempo"}]}]}');

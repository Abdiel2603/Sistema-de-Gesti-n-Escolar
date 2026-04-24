# Sistema de Gestión Escolar

## Descripción

Proyecto de base de datos desarrollado en PostgreSQL para la administración y análisis de información académica dentro de una institución escolar.

El sistema permite gestionar alumnos, materias, maestros, grupos, kardex, especialidades, oportunidades académicas, retículas y tutorías, integrando procesos de consulta, seguimiento de rendimiento escolar y detección de riesgo académico.

Además, se implementaron funciones avanzadas en PL/pgSQL para automatizar consultas, generar alertas y facilitar el análisis de datos académicos.

---

## Objetivo

Diseñar una base de datos relacional eficiente que permita centralizar la información académica y automatizar procesos de consulta relacionados con rendimiento escolar, tutorías, asistencia, materias acreditadas y seguimiento de alumnos en riesgo.

---

## Problemática

En muchos sistemas escolares, el control académico se realiza de forma manual o con estructuras poco optimizadas, lo que provoca:

- dificultad para consultar promedios y rendimiento
- poca visibilidad sobre alumnos en riesgo
- problemas en el seguimiento de tutorías
- dificultad para analizar asistencia y reportes académicos
- procesos lentos para consultar materias, grupos y especialidades

Este proyecto busca resolver esa problemática mediante una estructura relacional sólida y consultas automatizadas.

---

## Funcionalidades principales

- Gestión de alumnos, maestros y especialidades
- Administración de materias y retículas académicas
- Control de grupos, horarios y salones
- Registro de kardex y calificaciones
- Control de oportunidades académicas
- Gestión de tutorías mediante JSONB
- Identificación de alumnos en riesgo académico
- Generación automática de alertas
- Consultas avanzadas de rendimiento escolar
- Reportes por género, asistencia, materias y promedios

---

## Estructura de la Base de Datos

### Tablas principales

- alumno
- maestro
- materia
- grupo
- integra
- kardex
- especialidad
- oportunidad
- reticula
- tutorias
- alertas

### Relaciones implementadas

- llaves primarias
- llaves foráneas
- relaciones uno a muchos
- relaciones muchos a muchos
- validación de integridad referencial
- uso de JSONB para almacenamiento flexible de tutorías

---

## Tecnologías utilizadas

- PostgreSQL
- pgAdmin
- PL/pgSQL
- SQL
- JSONB
- GitHub

---

## Consultas y procesos implementados

### Funciones desarrolladas

### Rendimiento académico

- promedio_alumno()
- alumno_prom()
- obtener_aprobados()
- promedio_aprobados()
- alumnos_apro()
- alumnos_a()

### Tutorías y riesgo académico

- alumnos_riesgo_baja_asistencia()
- alumnos_sin_riesgo()
- alumnos_asistencia_mayor_70()
- alumnos_con_reportes()
- alumnos_con_matematicas()

### Consultas académicas

- materias_de_alumno()
- materias_por_maestro()
- materias_por_especialidad()
- alumnos_por_grupo()
- alumnos_por_genero()
- alumnos_quimica_acreditada()

### Automatización y alertas

- procesar_alumnos()
- inserción automática de alertas académicas
- validación de alumnos con bajo promedio

---

## Mi participación

Responsable de:

- diseño del modelo relacional
- creación de tablas y relaciones
- definición de llaves primarias y foráneas
- desarrollo de funciones en PL/pgSQL
- consultas avanzadas de análisis académico
- uso de JSONB para tutorías
- automatización de alertas de riesgo
- pruebas funcionales del sistema
- documentación técnica del proyecto

---

## Resultados obtenidos

Se logró una base de datos funcional capaz de:

- automatizar consultas académicas complejas
- identificar alumnos con bajo rendimiento
- analizar asistencia y riesgo escolar
- mejorar el control de tutorías
- facilitar reportes de rendimiento por materia y alumno
- reducir tiempos de consulta y seguimiento académico

El proyecto permitió aplicar buenas prácticas de modelado relacional y lógica procedural en PostgreSQL orientadas al análisis de datos.

---

## Autor

José Abdiel Bastida Mata

Ingeniería en Desarrollo y Gestión de Software  
Enfoque en Bases de Datos, SQL y Análisis de Datos

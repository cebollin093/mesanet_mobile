import '../models/carrera.dart';
import '../models/materia.dart';
import '../models/mesa_examen.dart';
import '../models/usuario.dart';
import '../models/correlatividad.dart';
import '../models/historial_academico.dart';
import '../models/inscripcion.dart';

class AppData {
  static final carreras = [
    Carrera(
      id: 'carrera_1',
      nombre:
          'Técnico Superior en Análisis de Sistemas y Desarrollo de Software',
    ),
  ];

  static final materias = [
    Materia(id: 'materia_1', nombre: 'Programación I', carreraId: 'carrera_1'),
    Materia(id: 'materia_2', nombre: 'Programación II', carreraId: 'carrera_1'),
    Materia(id: 'materia_3', nombre: 'Base de Datos', carreraId: 'carrera_1'),
    Materia(
      id: 'materia_4',
      nombre: 'Ingeniería de Software I',
      carreraId: 'carrera_1',
    ),
    Materia(
      id: 'materia_5',
      nombre: 'Ingeniería de Software II',
      carreraId: 'carrera_1',
    ),
    Materia(
      id: 'materia_6',
      nombre: 'Desarrollo de Aplicaciones Móviles',
      carreraId: 'carrera_1',
    ),
    Materia(id: 'materia_7', nombre: 'Proyecto Final', carreraId: 'carrera_1'),
    Materia(
      id: 'materia_8',
      nombre: 'Fundamentos de Sistemas',
      carreraId: 'carrera_1',
    ),
  ];

  static final mesas = [
    MesaExamen(
      id: 'mesa_1',
      materiaId: 'materia_2',
      fecha: DateTime(2026, 10, 15),
      horario: '18:00 hs',
      activa: true,
    ),
    MesaExamen(
      id: 'mesa_2',
      materiaId: 'materia_3',
      fecha: DateTime(2026, 10, 18),
      horario: '19:00 hs',
      activa: true,
    ),
    MesaExamen(
      id: 'mesa_3',
      materiaId: 'materia_5',
      fecha: DateTime(2026, 10, 22),
      horario: '18:00 hs',
      activa: true,
    ),
  ];

  static final usuarios = [
    Usuario(
      id: 'usuario_1',
      nombre: 'Alumno',
      email: 'alumno@mesanet.com',
      carreraId: 'carrera_1',
      rol: 'alumno',
    ),

    Usuario(
      id: 'admin_1',
      nombre: 'Administrador',
      email: 'admin@mesanet.com',
      carreraId: 'carrera_1',
      rol: 'administrador',
    ),
  ];

  static final correlatividades = [
    Correlatividad(
      id: 'corr_1',
      materiaId: 'materia_2',
      materiaCorrelativaId: 'materia_1',
    ),
    Correlatividad(
      id: 'corr_2',
      materiaId: 'materia_5',
      materiaCorrelativaId: 'materia_4',
    ),
  ];

  static final historialAcademico = [
    HistorialAcademico(
      id: 'hist_1',
      usuarioId: 'usuario_1',
      materiaId: 'materia_1',
      nota: 8,
      aprobada: true,
    ),
    HistorialAcademico(
      id: 'hist_2',
      usuarioId: 'usuario_1',
      materiaId: 'materia_3',
      nota: 7,
      aprobada: true,
    ),
    HistorialAcademico(
      id: 'hist_3',
      usuarioId: 'usuario_1',
      materiaId: 'materia_4',
      nota: 9,
      aprobada: true,
    ),
    HistorialAcademico(
      id: 'hist_4',
      usuarioId: 'usuario_1',
      materiaId: 'materia_8',
      nota: 8,
      aprobada: true,
    ),
  ];

  static final inscripciones = <Inscripcion>[];
}

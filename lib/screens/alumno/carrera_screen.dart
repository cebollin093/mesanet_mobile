import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/historial_academico.dart';
import '../../models/usuario.dart';
import 'alumno_widgets.dart';

class CarreraScreen extends StatelessWidget {
  final Usuario usuario;

  const CarreraScreen({super.key, required this.usuario});

  String _formatGrade(HistorialAcademico historial) {
    return historial.nota % 1 == 0
        ? historial.nota.toInt().toString()
        : historial.nota.toString();
  }

  @override
  Widget build(BuildContext context) {
    final carrera = AppData.carreras.firstWhere(
      (carrera) => carrera.id == usuario.carreraId,
    );
    final materiasCarrera = AppData.materias
        .where((materia) => materia.carreraId == carrera.id)
        .toList();
    final materiasCarreraIds = materiasCarrera
        .map((materia) => materia.id)
        .toSet();
    final materiasPorId = {
      for (final materia in materiasCarrera) materia.id: materia,
    };
    final historial = AppData.historialAcademico
        .where((registro) => registro.usuarioId == usuario.id)
        .where((registro) => registro.aprobada)
        .where((registro) => materiasCarreraIds.contains(registro.materiaId))
        .toList();
    final idsMateriasAprobadas = historial
        .map((registro) => registro.materiaId)
        .toSet();
    final materiasAprobadas = historial.map((registro) {
      final materia = materiasPorId[registro.materiaId]!;
      return (materia: materia, historial: registro);
    }).toList();
    final materiasPendientes = materiasCarrera
        .where((materia) => !idsMateriasAprobadas.contains(materia.id))
        .toList();
    final aprobadas = idsMateriasAprobadas.length;
    final totalMaterias = materiasCarrera.length;
    final progreso = totalMaterias == 0 ? 0.0 : aprobadas / totalMaterias;
    final porcentaje = (progreso * 100).round();

    return Container(
      color: const Color(0xFFD0E2EF),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5A94),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  carrera.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Trayectoria académica',
                  style: TextStyle(
                    color: Color(0xFFDCEAF5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle(
            title: 'Progreso académico',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFB8D0E2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Materias aprobadas',
                      style: TextStyle(
                        color: Color(0xFF123B6D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$aprobadas de $totalMaterias',
                      style: const TextStyle(
                        color: Color(0xFF123B6D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFDCEAF5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF3A8068),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$porcentaje% de la carrera completada',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            title: 'Materias aprobadas',
          ),
          const SizedBox(height: 10),
          ...materiasAprobadas.map(
            (materia) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SubjectCard(
                name: materia.materia.nombre,
                status: 'Aprobada',
                grade: _formatGrade(materia.historial),
                approved: true,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const SectionTitle(
            title: 'Materias pendientes',
          ),
          const SizedBox(height: 10),
          ...materiasPendientes.map(
            (materia) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SubjectCard(
                name: materia.nombre,
                status: 'Pendiente',
                grade: null,
                approved: false,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
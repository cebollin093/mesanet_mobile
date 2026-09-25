import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/historial_academico.dart';
import 'alumno_widgets.dart';

class CarreraScreen extends StatelessWidget {
  const CarreraScreen();

  String _formatGrade(HistorialAcademico historial) {
    return historial.nota % 1 == 0
        ? historial.nota.toInt().toString()
        : historial.nota.toString();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AppData.usuarios.first;
    final carrera = AppData.carreras.firstWhere(
      (carrera) => carrera.id == usuario.carreraId,
    );
    final historial = AppData.historialAcademico
        .where((registro) => registro.usuarioId == usuario.id)
        .where((registro) => registro.aprobada)
        .toList();
    final materiasAprobadas = historial.map((registro) {
      final materia = AppData.materias.firstWhere(
        (materia) => materia.id == registro.materiaId,
      );
      return (materia: materia, historial: registro);
    }).toList();
    final materiasPendientes = AppData.materias.where((materia) {
      return !historial.any(
        (registro) => registro.materiaId == materia.id,
      );
    }).toList();

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
                const Row(
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
                      '12 de 28',
                      style: TextStyle(
                        color: Color(0xFF123B6D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 12 / 28,
                    minHeight: 10,
                    backgroundColor: Color(0xFFDCEAF5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF3A8068),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '43% de la carrera completada',
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
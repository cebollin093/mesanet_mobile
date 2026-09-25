import 'package:flutter/material.dart';

import 'alumno_widgets.dart';

class CarreraScreen extends StatelessWidget {
  const CarreraScreen();

  @override
  Widget build(BuildContext context) {
    const materiasAprobadas = [
      {
        'nombre': 'Programación I',
        'nota': '8',
      },
      {
        'nombre': 'Base de Datos',
        'nota': '7',
      },
      {
        'nombre': 'Ingeniería de Software I',
        'nota': '9',
      },
      {
        'nombre': 'Fundamentos de Sistemas',
        'nota': '8',
      },
    ];

    const materiasPendientes = [
      'Programación II',
      'Ingeniería de Software II',
      'Desarrollo de Aplicaciones Móviles',
      'Proyecto Final',
    ];

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  'Técnico Superior en Análisis de Sistemas y Desarrollo de Software',
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
                name: materia['nombre']!,
                status: 'Aprobada',
                grade: materia['nota']!,
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
                name: materia,
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
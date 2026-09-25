import 'package:flutter/material.dart';

import 'alumno_widgets.dart';

class MesasScreen extends StatelessWidget {
  final List<Map<String, String>> enrollments;

  final Future<void> Function({
    required String subject,
    required String date,
    required String time,
    required String status,
  }) onOpenExamDetail;

  const MesasScreen({
    required this.enrollments,
    required this.onOpenExamDetail,
  });

  bool _isEnrolled(String subject) {
    return enrollments.any(
      (enrollment) => enrollment['materia'] == subject,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: const Row(
              children: [
                Icon(
                  Icons.event_available,
                  color: Color(0xFFF28C28),
                  size: 34,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mesas disponibles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Consultá las próximas fechas de examen.',
                        style: TextStyle(
                          color: Color(0xFFEAF2F8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: FilterButton(
                  title: 'Todas',
                  selected: true,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: FilterButton(
                  title: 'Próximas',
                  selected: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: FilterButton(
                  title: 'Cerradas',
                  selected: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionTitle(
            title: 'Próximas mesas',
          ),
          const SizedBox(height: 10),
          ExamSessionCard(
            subject: 'Programación II',
            date: '15 de octubre',
            time: '18:00 hs',
            status: _isEnrolled('Programación II')
                ? 'Inscripto'
                : 'Disponible',
            enrolled: _isEnrolled('Programación II'),
            onTap: () {
              onOpenExamDetail(
                subject: 'Programación II',
                date: '15 de octubre',
                time: '18:00 hs',
                status: 'Disponible',
              );
            },
          ),
          const SizedBox(height: 12),
          ExamSessionCard(
            subject: 'Base de Datos',
            date: '18 de octubre',
            time: '19:00 hs',
            status: _isEnrolled('Base de Datos')
                ? 'Inscripto'
                : 'Disponible',
            enrolled: _isEnrolled('Base de Datos'),
            onTap: () {
              onOpenExamDetail(
                subject: 'Base de Datos',
                date: '18 de octubre',
                time: '19:00 hs',
                status: 'Disponible',
              );
            },
          ),
          const SizedBox(height: 12),
          ExamSessionCard(
            subject: 'Ingeniería de Software',
            date: '22 de octubre',
            time: '18:00 hs',
            status: _isEnrolled('Ingeniería de Software')
                ? 'Inscripto'
                : 'Disponible',
            enrolled: _isEnrolled('Ingeniería de Software'),
            onTap: () {
              onOpenExamDetail(
                subject: 'Ingeniería de Software',
                date: '22 de octubre',
                time: '18:00 hs',
                status: 'Disponible',
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
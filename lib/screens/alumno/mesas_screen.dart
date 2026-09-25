import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/inscripcion.dart';
import '../../models/materia.dart';
import '../../models/mesa_examen.dart';
import 'alumno_widgets.dart';

class MesasScreen extends StatelessWidget {
  final List<Inscripcion> enrollments;

  final Future<void> Function({
    required MesaExamen mesa,
    required Materia materia,
  }) onOpenExamDetail;

  const MesasScreen({super.key, 
    required this.enrollments,
    required this.onOpenExamDetail,
  });

  bool _isEnrolled(String mesaExamenId) {
    return enrollments.any(
      (enrollment) => enrollment.mesaExamenId == mesaExamenId,
    );
  }

  Materia _materiaFor(MesaExamen mesa) => AppData.materias.firstWhere(
        (materia) => materia.id == mesa.materiaId,
      );

  String _formattedDate(DateTime date) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]}';
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
          for (var index = 0; index < AppData.mesas.length; index++) ...[
            Builder(
              builder: (context) {
                final mesa = AppData.mesas[index];
                final materia = _materiaFor(mesa);
                final enrolled = _isEnrolled(mesa.id);
                return ExamSessionCard(
                  subject: materia.nombre,
                  date: _formattedDate(mesa.fecha),
                  time: mesa.horario,
                  status: enrolled ? 'Inscripto' : 'Disponible',
                  enrolled: enrolled,
                  onTap: () => onOpenExamDetail(
                    mesa: mesa,
                    materia: materia,
                  ),
                );
              },
            ),
            if (index < AppData.mesas.length - 1)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
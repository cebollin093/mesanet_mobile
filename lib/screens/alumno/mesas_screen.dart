import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/inscripcion.dart';
import '../../models/materia.dart';
import '../../models/mesa_examen.dart';
import '../../models/usuario.dart';
import 'alumno_widgets.dart';

class MesasScreen extends StatelessWidget {
  static final RegExp _timeFormat = RegExp(r'^([0-9]{2}):([0-9]{2}) hs$');

  final Usuario usuario;
  final List<Inscripcion> enrollments;

  final Future<void> Function({
    required MesaExamen mesa,
    required Materia materia,
  }) onOpenExamDetail;

  const MesasScreen({super.key, 
    required this.usuario,
    required this.enrollments,
    required this.onOpenExamDetail,
  });

  bool _isEnrolled(String mesaExamenId) {
    return enrollments.any(
      (enrollment) => enrollment.mesaExamenId == mesaExamenId,
    );
  }

  bool _isAvailable(MesaExamen mesa, DateTime now) {
    if (!mesa.activa) {
      return false;
    }

    final materiaExistsInCareer = AppData.materias.any(
      (materia) =>
          materia.id == mesa.materiaId &&
          materia.carreraId == usuario.carreraId,
    );
    if (!materiaExistsInCareer) {
      return false;
    }

    final match = _timeFormat.firstMatch(mesa.horario.trim());
    if (match == null) {
      return false;
    }

    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || hour > 23 || minute == null || minute > 59) {
      return false;
    }

    final startsAt = DateTime(
      mesa.fecha.year,
      mesa.fecha.month,
      mesa.fecha.day,
      hour,
      minute,
    );
    return startsAt.isAfter(now);
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
    final now = DateTime.now();
    final mesasDisponibles = AppData.mesas
        .where((mesa) => _isAvailable(mesa, now))
        .toList();

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
          for (var index = 0; index < mesasDisponibles.length; index++) ...[
            Builder(
              builder: (context) {
                final mesa = mesasDisponibles[index];
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
            if (index < mesasDisponibles.length - 1)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
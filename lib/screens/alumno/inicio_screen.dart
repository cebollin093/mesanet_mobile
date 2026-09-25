import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/inscripcion.dart';
import '../../models/materia.dart';
import '../../models/mesa_examen.dart';
import 'alumno_widgets.dart';

class InicioScreen extends StatelessWidget {
  final List<Inscripcion> enrollments;

  const InicioScreen({super.key, 
    required this.enrollments,
  });

  MesaExamen _mesaFor(Inscripcion inscripcion) => AppData.mesas.firstWhere(
        (mesa) => mesa.id == inscripcion.mesaExamenId,
      );

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
    final bool hasEnrollment = enrollments.isNotEmpty;
    final enrollment = hasEnrollment ? enrollments.first : null;
    final mesa = enrollment == null ? null : _mesaFor(enrollment);
    final materia = mesa == null ? null : _materiaFor(mesa);

    return Container(
      color: const Color(0xFFD0E2EF),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5A94),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, estudiante!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Este es el resumen de tu actividad académica.',
                  style: TextStyle(
                    color: Color(0xFFEAF2F8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle(
            title: 'Próxima mesa',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF123B6D),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33123B6D),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: hasEnrollment
                ? Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF28C28),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.event,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PRÓXIMA INSCRIPCIÓN',
                              style: TextStyle(
                                color: Color(0xFFF28C28),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              materia!.nombre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${_formattedDate(mesa!.fecha)} · ${mesa.horario}',
                              style: const TextStyle(
                                color: Color(0xFFDCEAF5),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFFF28C28),
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Inscripto · ${enrollment!.condicion}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFF28C28),
                        size: 18,
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Icon(
                        Icons.event_busy,
                        color: Color(0xFFF28C28),
                        size: 38,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIN INSCRIPCIONES',
                              style: TextStyle(
                                color: Color(0xFFF28C28),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'No tenés mesas inscriptas',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Consultá las próximas mesas disponibles.',
                              style: TextStyle(
                                color: Color(0xFFDCEAF5),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            title: 'Resumen académico',
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: AcademicCard(
                  title: 'Aprobadas',
                  value: '12',
                  subtitle: 'materias',
                  icon: Icons.check_circle,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AcademicCard(
                  title: 'Pendientes',
                  value: '8',
                  subtitle: 'materias',
                  icon: Icons.menu_book,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            title: 'Accesos rápidos',
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: QuickAction(
                  icon: Icons.event,
                  title: 'Mesas',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: QuickAction(
                  icon: Icons.school,
                  title: 'Mi carrera',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: QuickAction(
                  icon: Icons.history,
                  title: 'Historial',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: QuickAction(
                  icon: Icons.calendar_month,
                  title: 'Calendario',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
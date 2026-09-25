import 'package:flutter/material.dart';

import 'alumno_widgets.dart';

class InscripcionesScreen extends StatelessWidget {
  final List<Map<String, String>> enrollments;

  final void Function(String subject) onCancelEnrollment;

  const InscripcionesScreen({
    required this.enrollments,
    required this.onCancelEnrollment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD0E2EF),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          const Text(
            'Mis inscripciones',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Color(0xFF123B6D),
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Mesas de examen en las que estás inscripto actualmente.',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD7E3EC),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0F6),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.event_available_outlined,
                    color: Color(0xFF123B6D),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inscripciones activas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${enrollments.length} ${enrollments.length == 1 ? 'mesa registrada' : 'mesas registradas'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F0EA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Activas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A8068),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (enrollments.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFD7E3EC),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    color: Color(0xFF64748B),
                    size: 42,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No tenés inscripciones',
                    style: TextStyle(
                      color: Color(0xFF123B6D),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Cuando te inscribas a una mesa, aparecerá acá.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            const Text(
              'Próximos exámenes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF123B6D),
              ),
            ),
            const SizedBox(height: 12),
            ...enrollments.map(
              (inscripcion) => InscriptionCard(
                materia: inscripcion['materia']!,
                fecha: inscripcion['fecha']!,
                hora: inscripcion['hora']!,
                condicion: inscripcion['condicion']!,
                estado: inscripcion['estado']!,
                onCancel: () {
                  onCancelEnrollment(
                    inscripcion['materia']!,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
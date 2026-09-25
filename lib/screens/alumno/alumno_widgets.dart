import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFF28C28),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF123B6D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class AcademicCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const AcademicCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool approved = title == 'Aprobadas';

    return Container(
      height: 145,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: approved
            ? const Color(0xFF3A8068)
            : const Color(0xFF6F648F),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: approved
                ? const Color(0xFFDDF3E9)
                : const Color(0xFFEAE4F7),
            size: 25,
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: approved
                  ? const Color(0xFFEAF7F1)
                  : const Color(0xFFF0ECF8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: approved
                        ? const Color(0xFFDDF3E9)
                        : const Color(0xFFEAE4F7),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;

  const QuickAction({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E5A94),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22123B6D),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF123B6D),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFDCEAF5),
            size: 14,
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool selected;

  const FilterButton({
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF123B6D)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? const Color(0xFF123B6D)
              : const Color(0xFFB8D0E2),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : const Color(0xFF123B6D),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class ExamSessionCard extends StatelessWidget {
  final String subject;
  final String date;
  final String time;
  final String status;
  final bool enrolled;
  final VoidCallback onTap;

  const ExamSessionCard({
    required this.subject,
    required this.date,
    required this.time,
    required this.status,
    required this.enrolled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFB8D0E2),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18123B6D),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: enrolled
                      ? const Color(0xFFE2F0EA)
                      : const Color(0xFFD7E7F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  enrolled ? Icons.check_circle : Icons.event,
                  color: enrolled
                      ? const Color(0xFF3A8068)
                      : const Color(0xFF123B6D),
                  size: 27,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(
                        color: Color(0xFF123B6D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: enrolled
                            ? const Color(0xFFE2F0EA)
                            : const Color(0xFFFFF0E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: enrolled
                              ? const Color(0xFF3A8068)
                              : const Color(0xFFF28C28),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF1E5A94),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String name;
  final String status;
  final String? grade;
  final bool approved;

  const SubjectCard({
    required this.name,
    required this.status,
    required this.grade,
    required this.approved,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = approved
        ? const Color(0xFFF1F8F5)
        : const Color(0xFFF4F1F8);

    final Color accentColor = approved
        ? const Color(0xFF3A8068)
        : const Color(0xFF6F648F);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: approved
              ? const Color(0xFFC8E2D6)
              : const Color(0xFFD9D2E6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              approved ? Icons.check : Icons.menu_book,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF123B6D),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  grade != null
                      ? '$status · Nota final: $grade'
                      : status,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            approved
                ? Icons.check_circle
                : Icons.arrow_forward_ios,
            color: accentColor,
            size: approved ? 20 : 16,
          ),
        ],
      ),
    );
  }
}

class InscriptionCard extends StatelessWidget {
  final String materia;
  final String fecha;
  final String hora;
  final String condicion;
  final String estado;
  final VoidCallback onCancel;

  const InscriptionCard({
    required this.materia,
    required this.fecha,
    required this.hora,
    required this.condicion,
    required this.estado,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD7E3EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              16,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0F6),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
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
                      Text(
                        materia,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF123B6D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Mesa de examen',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F0EA),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    estado,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A8068),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Color(0xFFE5EAF0),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Fecha',
                        value: fecha,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoItem(
                        icon: Icons.access_time_outlined,
                        label: 'Horario',
                        value: hora,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: InfoItem(
                        icon: Icons.school_outlined,
                        label: 'Condición',
                        value: condicion,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InfoItem(
                        icon: Icons.check_circle_outline,
                        label: 'Estado',
                        value: estado,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            'Detalle de la mesa de $materia',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 19,
                    ),
                    label: const Text('Ver detalle'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF123B6D),
                      side: const BorderSide(
                        color: Color(0xFFB8CCDC),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text(
                              'Cancelar inscripción',
                            ),
                            content: Text(
                              '¿Estás seguro de que querés cancelar tu inscripción a la mesa de $materia?',
                            ),
                            actions: [
                              SizedBox(
                                width: 115,
                                height: 42,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      dialogContext,
                                    );
                                  },
                                  style:
                                      OutlinedButton.styleFrom(
                                    foregroundColor:
                                        const Color(
                                      0xFF123B6D,
                                    ),
                                    backgroundColor:
                                        const Color(
                                      0xFFF6F9FB,
                                    ),
                                    side:
                                        const BorderSide(
                                      color: Color(
                                        0xFFB8CCDC,
                                      ),
                                    ),
                                    padding: EdgeInsets.zero,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child:
                                      const Text('No'),
                                ),
                              ),
                              SizedBox(
                                width: 115,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      dialogContext,
                                    );
                                    onCancel();
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xFFB45353,
                                    ),
                                    foregroundColor:
                                        Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sí, cancelar',
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 19,
                    ),
                    label: const Text(
                      'Cancelar inscripción',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFFB45353),
                      side: const BorderSide(
                        color: Color(0xFFE0B5B5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 11,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE1E8EE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF1E5A94),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
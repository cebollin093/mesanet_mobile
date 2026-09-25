import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/inscripcion.dart';
import '../../models/materia.dart';
import '../../models/mesa_examen.dart';

class ExamSessionDetailScreen extends StatefulWidget {
  final MesaExamen mesa;
  final Materia materia;

  final String? initialCondition;
  final bool initialEnrolled;

  // Se ejecuta inmediatamente cuando se confirma la inscripción.
  final void Function(Inscripcion enrollment)?
      onEnrollmentConfirmed;

  const ExamSessionDetailScreen({
    super.key,
    required this.mesa,
    required this.materia,
    this.initialCondition,
    this.initialEnrolled = false,
    this.onEnrollmentConfirmed,
  });

  @override
  State<ExamSessionDetailScreen> createState() =>
      _ExamSessionDetailScreenState();
}

class _ExamSessionDetailScreenState
    extends State<ExamSessionDetailScreen> {
  late String? _condition;
  late bool _isEnrolled;

  Inscripcion? _newEnrollment;

  String get _formattedDate {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${widget.mesa.fecha.day} de ${months[widget.mesa.fecha.month - 1]}';
  }

  String? _validateEnrollment() {
    if (AppData.usuarios.isEmpty) {
      return 'No hay un usuario disponible para realizar la inscripción.';
    }

    final mesaExists = AppData.mesas.any(
      (mesa) => mesa.id == widget.mesa.id,
    );
    if (!mesaExists) {
      return 'La mesa de examen seleccionada ya no está disponible.';
    }

    final usuario = AppData.usuarios.first;
    final alreadyEnrolled = AppData.inscripciones.any(
      (inscripcion) =>
          inscripcion.usuarioId == usuario.id &&
          inscripcion.mesaExamenId == widget.mesa.id,
    );
    if (alreadyEnrolled) {
      return 'Ya estás inscripto a esta mesa de examen.';
    }

    final correlatividades = AppData.correlatividades.where(
      (correlatividad) => correlatividad.materiaId == widget.materia.id,
    );
    for (final correlatividad in correlatividades) {
      final aprobada = AppData.historialAcademico.any(
        (historial) =>
            historial.usuarioId == usuario.id &&
            historial.materiaId == correlatividad.materiaCorrelativaId &&
            historial.aprobada &&
            historial.nota >= 4,
      );
      if (!aprobada) {
        return 'No podés inscribirte porque no aprobaste la materia correlativa.';
      }
    }

    return null;
  }

  Inscripcion _createEnrollment() {
    return Inscripcion(
      id: 'inscripcion_${DateTime.now().microsecondsSinceEpoch}',
      usuarioId: AppData.usuarios.first.id,
      mesaExamenId: widget.mesa.id,
      fechaInscripcion: DateTime.now(),
      condicion: _condition!,
    );
  }

  @override
  void initState() {
    super.initState();

    _condition = widget.initialCondition;
    _isEnrolled = widget.initialEnrolled;
  }

  void _showConditionDialog() {
    String? selectedCondition = _condition;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Seleccioná la condición',
                style: TextStyle(
                  color: Color(0xFF123B6D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ConditionOption(
                    title: 'Regular',
                    description: 'Rendir como alumno regular',
                    value: 'Regular',
                    selectedCondition: selectedCondition,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCondition = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _ConditionOption(
                    title: 'Libre',
                    description: 'Rendir como alumno libre',
                    value: 'Libre',
                    selectedCondition: selectedCondition,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCondition = value;
                      });
                    },
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFC62828),
                          side: const BorderSide(
                            color: Color(0xFFC62828),
                            width: 1.5,
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            48,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancelar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedCondition == null
                            ? null
                            : () {
                                Navigator.pop(dialogContext);

                                setState(() {
                                  _condition = selectedCondition;
                                });

                                // La confirmación aparece
                                // inmediatamente después.
                                _showConfirmationDialog();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E5A94),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFFB8C9D8),
                          disabledForegroundColor: Colors.white,
                          minimumSize: const Size(
                            double.infinity,
                            48,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Continuar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog() {
    if (_condition == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Confirmar inscripción',
                style: TextStyle(
                  color: Color(0xFF123B6D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Revisá los datos de tu inscripción antes de confirmar.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),

                  _ConfirmationData(
                    icon: Icons.menu_book_outlined,
                    label: 'Materia',
                    value: widget.materia.nombre,
                  ),

                  const SizedBox(height: 10),

                  _ConfirmationData(
                    icon: Icons.calendar_today_outlined,
                    label: 'Fecha',
                    value: _formattedDate,
                  ),

                  const SizedBox(height: 10),

                  _ConfirmationData(
                    icon: Icons.access_time_outlined,
                    label: 'Horario',
                    value: widget.mesa.horario,
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F0EA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          color: Color(0xFF3A8068),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Condición',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _condition!,
                                style: const TextStyle(
                                  color: Color(0xFF285E4B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _showConditionDialog();
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 17,
                      ),
                      label: const Text(
                        'Cambiar condición',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            const Color(0xFF1E5A94),
                      ),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFC62828),
                          side: const BorderSide(
                            color: Color(0xFFC62828),
                            width: 1.5,
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            48,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancelar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final validationError = _validateEnrollment();
                          if (validationError != null) {
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(validationError)),
                            );
                            return;
                          }

                          final enrollment = _createEnrollment();

                          // Guardamos inmediatamente la inscripción
                          // en HomeScreen.
                          widget.onEnrollmentConfirmed
                              ?.call(enrollment);

                          setState(() {
                            _isEnrolled = true;
                            _newEnrollment = enrollment;
                          });

                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF3A8068),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(
                            double.infinity,
                            48,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Confirmar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _returnToPreviousScreen() {
    Navigator.pop(context, _newEnrollment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalle de mesa',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
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
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28C28),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.event,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.materia.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Información de la mesa',
              style: TextStyle(
                color: Color(0xFF123B6D),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFB8D0E2),
                ),
              ),
              child: Column(
                children: [
                  _DetailItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Fecha',
                    value: _formattedDate,
                  ),
                  const SizedBox(height: 12),
                  _DetailItem(
                    icon: Icons.access_time_outlined,
                    label: 'Horario',
                    value: widget.mesa.horario,
                  ),
                  const SizedBox(height: 12),
                  _DetailItem(
                    icon: Icons.event_available_outlined,
                    label: 'Estado',
                    value: _isEnrolled ? 'Inscripto' : 'Disponible',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            if (_isEnrolled)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F0EA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFC8E2D6),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF3A8068),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Inscripción confirmada',
                      style: TextStyle(
                        color: Color(0xFF285E4B),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ya estás inscripto a esta mesa de examen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4B6F62),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _ConfirmationItem(
                        label: 'Condición',
                        value: _condition ?? '',
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              if (_condition != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD7E3EC),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        color: Color(0xFF1E5A94),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Condición seleccionada: $_condition',
                          style: const TextStyle(
                            color: Color(0xFF123B6D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: !_isEnrolled
                      ? _showConditionDialog
                      : null,
                  icon: const Icon(
                    Icons.how_to_reg,
                  ),
                  label: Text(
                    _condition == null
                        ? 'Inscribirme'
                        : 'Cambiar condición',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5A94),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _returnToPreviousScreen,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF123B6D),
                  side: const BorderSide(
                    color: Color(0xFFB8CCDC),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEnrolled
                      ? 'Volver a mesas'
                      : 'Volver',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConditionOption extends StatelessWidget {
  final String title;
  final String description;
  final String value;
  final String? selectedCondition;
  final ValueChanged<String?> onChanged;

  const _ConditionOption({
    required this.title,
    required this.description,
    required this.value,
    required this.selectedCondition,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = selectedCondition == value;

    return Container(
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFE8F1F8)
            : const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? const Color(0xFF1E5A94)
              : const Color(0xFFD7E3EC),
        ),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedCondition,
        onChanged: onChanged,
        activeColor: const Color(0xFF1E5A94),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF123B6D),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
      ),
    );
  }
}

class _ConfirmationData extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ConfirmationData({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1E5A94),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF1E5A94),
            size: 20,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

class _ConfirmationItem extends StatelessWidget {
  final String label;
  final String value;

  const _ConfirmationItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.school_outlined,
          color: Color(0xFF3A8068),
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF285E4B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
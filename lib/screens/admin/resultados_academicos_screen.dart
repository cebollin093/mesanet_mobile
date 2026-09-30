import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/historial_academico.dart';
import '../../models/mesa_examen.dart';
import '../../models/usuario.dart';

class ResultadosAcademicosScreen extends StatefulWidget {
  const ResultadosAcademicosScreen({super.key});

  @override
  State<ResultadosAcademicosScreen> createState() =>
      _ResultadosAcademicosScreenState();
}

class _ResultadosAcademicosScreenState
    extends State<ResultadosAcademicosScreen> {
  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  String? _mesaId;

  String _nombreMateria(String materiaId) {
    final materias = AppData.materias.where(
      (materia) => materia.id == materiaId,
    );

    return materias.isEmpty
        ? 'Materia desconocida'
        : materias.first.nombre;
  }

  Usuario? _obtenerUsuario(String usuarioId) {
    for (final usuario in AppData.usuarios) {
      if (usuario.id == usuarioId) {
        return usuario;
      }
    }

    return null;
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  MesaExamen? _mesaSeleccionada() {
    if (_mesaId == null) {
      return null;
    }

    for (final mesa in AppData.mesas) {
      if (mesa.id == _mesaId) {
        return mesa;
      }
    }

    return null;
  }

  List<String> _alumnosInscritos(MesaExamen mesa) {
    return AppData.inscripciones
        .where((inscripcion) => inscripcion.mesaExamenId == mesa.id)
        .map((inscripcion) => inscripcion.usuarioId)
        .toSet()
        .toList();
  }

  HistorialAcademico? _historialActual(
    String usuarioId,
    String materiaId,
  ) {
    for (final historial in AppData.historialAcademico) {
      if (historial.usuarioId == usuarioId &&
          historial.materiaId == materiaId) {
        return historial;
      }
    }

    return null;
  }

  void _mostrarResultado({
    required Usuario alumno,
    required MesaExamen mesa,
  }) {
    final historial = _historialActual(
      alumno.id,
      mesa.materiaId,
    );

    final notaController = TextEditingController(
      text: historial == null ? '' : historial.nota.toString(),
    );

    bool presente = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: background,
              title: const Text(
                'Resultado académico',
                style: TextStyle(
                  color: darkerBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${alumno.apellido}, ${alumno.nombre}',
                      style: const TextStyle(
                        color: darkerBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _nombreMateria(mesa.materiaId),
                      style: const TextStyle(
                        color: darkerBlue,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'El alumno se presentó',
                      ),
                      value: presente,
                      activeColor: orange,
                      onChanged: (value) {
                        setDialogState(() {
                          presente = value;
                        });
                      },
                    ),
                    if (presente) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: notaController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Nota',
                          hintText: 'Ej. 8',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'La materia se considera aprobada con una nota igual o mayor a 4.',
                        style: TextStyle(
                          color: darkerBlue,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (!presente)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.orange.shade200,
                          ),
                        ),
                        child: const Text(
                          'Si el alumno estuvo ausente, no se registrará '
                          'una calificación y se eliminará el resultado '
                          'académico actual de esta materia.',
                          style: TextStyle(
                            color: darkerBlue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkerBlue,
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: darkerBlue,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: orange,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (!presente) {
                            _eliminarResultado(
                              alumno: alumno,
                              mesa: mesa,
                            );

                            Navigator.pop(dialogContext);
                            setState(() {});
                            return;
                          }

                          final nota = double.tryParse(
                            notaController.text.replaceAll(',', '.'),
                          );

                          if (nota == null || nota < 0 || nota > 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Ingresá una nota válida entre 0 y 10.',
                                ),
                              ),
                            );
                            return;
                          }

                          final aprobada = nota >= 4;

                          _guardarResultado(
                            alumno: alumno,
                            mesa: mesa,
                            nota: nota,
                            aprobada: aprobada,
                          );

                          Navigator.pop(dialogContext);

                          setState(() {});
                        },
                        child: const Text('Guardar'),
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

  void _guardarResultado({
    required Usuario alumno,
    required MesaExamen mesa,
    required double nota,
    required bool aprobada,
  }) {
    final index = AppData.historialAcademico.indexWhere(
      (historial) =>
          historial.usuarioId == alumno.id &&
          historial.materiaId == mesa.materiaId,
    );

    setState(() {
      if (index == -1) {
        AppData.historialAcademico.add(
          HistorialAcademico(
            id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
            usuarioId: alumno.id,
            materiaId: mesa.materiaId,
            nota: nota,
            aprobada: aprobada,
          ),
        );
      } else {
        final historial = AppData.historialAcademico[index];

        AppData.historialAcademico[index] = HistorialAcademico(
          id: historial.id,
          usuarioId: historial.usuarioId,
          materiaId: historial.materiaId,
          nota: nota,
          aprobada: aprobada,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Resultado académico guardado correctamente.',
        ),
      ),
    );
  }

  void _eliminarResultado({
    required Usuario alumno,
    required MesaExamen mesa,
  }) {
    AppData.historialAcademico.removeWhere(
      (historial) =>
          historial.usuarioId == alumno.id &&
          historial.materiaId == mesa.materiaId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'El resultado académico fue eliminado.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mesa = _mesaSeleccionada();
    final alumnosIds = mesa == null ? <String>[] : _alumnosInscritos(mesa);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Resultados académicos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Autocomplete<MesaExamen>(
              displayStringForOption: (mesa) =>
                  '${_nombreMateria(mesa.materiaId)} · '
                  '${_formatearFecha(mesa.fecha)} · '
                  '${mesa.horario}',
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<MesaExamen>.empty();
                }

                final busqueda = textEditingValue.text.toLowerCase();

                return AppData.mesas.where(
                  (mesa) => _nombreMateria(mesa.materiaId)
                      .toLowerCase()
                      .contains(busqueda),
                );
              },
              onSelected: (mesa) {
                setState(() {
                  _mesaId = mesa.id;
                });
              },
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Buscar mesa de examen',
                    hintText: 'Escribí el nombre de la materia',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: darkerBlue,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final mesa = options.elementAt(index);

                          return ListTile(
                            leading: const Icon(
                              Icons.event_note_outlined,
                              color: darkerBlue,
                            ),
                            title: Text(
                              _nombreMateria(mesa.materiaId),
                              style: const TextStyle(
                                color: darkerBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${_formatearFecha(mesa.fecha)} · '
                              '${mesa.horario}',
                            ),
                            onTap: () => onSelected(mesa),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (mesa != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nombreMateria(mesa.materiaId),
                      style: const TextStyle(
                        color: lightText,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${_formatearFecha(mesa.fecha)} · ${mesa.horario}',
                      style: const TextStyle(
                        color: lightText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${alumnosIds.length} alumno'
                      '${alumnosIds.length == 1 ? '' : 's'} inscripto'
                      '${alumnosIds.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: lightText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: mesa == null
                ? const Center(
                    child: Text(
                      'Seleccioná una mesa para cargar resultados.',
                      style: TextStyle(
                        color: darkerBlue,
                        fontSize: 16,
                      ),
                    ),
                  )
                : alumnosIds.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay alumnos inscriptos en esta mesa.',
                          style: TextStyle(
                            color: darkerBlue,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          20,
                        ),
                        itemCount: alumnosIds.length,
                        itemBuilder: (context, index) {
                          final alumno = _obtenerUsuario(
                            alumnosIds[index],
                          );

                          if (alumno == null) {
                            return const SizedBox.shrink();
                          }

                          final historial = _historialActual(
                            alumno.id,
                            mesa.materiaId,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: darkBlue,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: border,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: orange,
                                child: Text(
                                  alumno.nombre.isEmpty
                                      ? '?'
                                      : alumno.nombre[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                '${alumno.apellido}, ${alumno.nombre}',
                                style: const TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  historial == null
                                      ? 'Resultado pendiente'
                                      : 'Última nota: ${historial.nota} · '
                                          '${historial.aprobada ? 'Aprobada' : 'No aprobada'}',
                                  style: const TextStyle(
                                    color: lightText,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                tooltip: historial == null
                                    ? 'Cargar resultado'
                                    : 'Editar resultado',
                                icon: Icon(
                                  historial == null
                                      ? Icons.add_circle_outline
                                      : Icons.edit_outlined,
                                  color: lightText,
                                ),
                                onPressed: () {
                                  _mostrarResultado(
                                    alumno: alumno,
                                    mesa: mesa,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
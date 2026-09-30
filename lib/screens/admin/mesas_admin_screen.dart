import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/mesa_examen.dart';
import 'inscriptos_screen.dart';

class MesasAdminScreen extends StatefulWidget {
  const MesasAdminScreen({super.key});

  @override
  State<MesasAdminScreen> createState() => _MesasAdminScreenState();
}

class _MesasAdminScreenState extends State<MesasAdminScreen> {
  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  String? _filtroEstado;

  String _nombreMateria(String materiaId) {
    final materias = AppData.materias.where(
      (m) => m.id == materiaId,
    );

    return materias.isEmpty ? 'Materia desconocida' : materias.first.nombre;
  }

  String _nombreCarrera(String materiaId) {
    final materias = AppData.materias.where(
      (m) => m.id == materiaId,
    );

    if (materias.isEmpty) {
      return 'Carrera desconocida';
    }

    final carreras = AppData.carreras.where(
      (c) => c.id == materias.first.carreraId,
    );

    return carreras.isEmpty ? 'Carrera desconocida' : carreras.first.nombre;
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  Future<void> _mostrarFormulario({MesaExamen? mesa}) async {
    DateTime fecha = mesa?.fecha ?? DateTime.now();

    TimeOfDay horario = _parsearHorario(mesa?.horario);

    String? materiaId = mesa?.materiaId ??
        (AppData.materias.isNotEmpty
            ? AppData.materias.first.id
            : null);

    bool activa = mesa?.activa ?? true;

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: background,
              title: Text(
                mesa == null ? 'Nueva mesa' : 'Editar mesa',
                style: const TextStyle(
                  color: darkerBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: materiaId,
                      decoration: InputDecoration(
                        labelText: 'Materia',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: AppData.materias.map((materia) {
                        return DropdownMenuItem<String>(
                          value: materia.id,
                          child: Text(
                            materia.nombre,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          materiaId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final seleccionada = await showDatePicker(
                          context: context,
                          initialDate: fecha,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2035),
                        );

                        if (seleccionada != null) {
                          setDialogState(() {
                            fecha = seleccionada;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_formatearFecha(fecha)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final seleccionada = await showTimePicker(
                          context: context,
                          initialTime: horario,
                        );

                        if (seleccionada != null) {
                          setDialogState(() {
                            horario = seleccionada;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Horario',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '${horario.hour.toString().padLeft(2, '0')}:'
                          '${horario.minute.toString().padLeft(2, '0')} hs',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mesa activa'),
                      value: activa,
                      activeColor: orange,
                      onChanged: (value) {
                        setDialogState(() {
                          activa = value;
                        });
                      },
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
                        onPressed: () =>
                            Navigator.pop(dialogContext, false),
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
                          if (materiaId == null) {
                            return;
                          }

                          final horarioTexto =
                              '${horario.hour.toString().padLeft(2, '0')}:'
                              '${horario.minute.toString().padLeft(2, '0')} hs';

                          setState(() {
                            if (mesa == null) {
                              AppData.mesas.add(
                                MesaExamen(
                                  id: 'mesa_${DateTime.now().millisecondsSinceEpoch}',
                                  materiaId: materiaId!,
                                  fecha: fecha,
                                  horario: horarioTexto,
                                  activa: activa,
                                ),
                              );
                            } else {
                              final index = AppData.mesas.indexWhere(
                                (m) => m.id == mesa.id,
                              );

                              if (index != -1) {
                                AppData.mesas[index] = MesaExamen(
                                  id: mesa.id,
                                  materiaId: materiaId!,
                                  fecha: fecha,
                                  horario: horarioTexto,
                                  activa: activa,
                                );
                              }
                            }
                          });

                          Navigator.pop(dialogContext, true);
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

    if (resultado == true && mounted) {
      setState(() {});
    }
  }

  TimeOfDay _parsearHorario(String? horario) {
    if (horario == null || horario.isEmpty) {
      return const TimeOfDay(hour: 18, minute: 0);
    }

    final partes = horario.replaceAll(' hs', '').split(':');

    if (partes.length != 2) {
      return const TimeOfDay(hour: 18, minute: 0);
    }

    return TimeOfDay(
      hour: int.tryParse(partes[0]) ?? 18,
      minute: int.tryParse(partes[1]) ?? 0,
    );
  }

  void _cambiarEstado(MesaExamen mesa) {
    final index = AppData.mesas.indexWhere(
      (m) => m.id == mesa.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      AppData.mesas[index] = MesaExamen(
        id: mesa.id,
        materiaId: mesa.materiaId,
        fecha: mesa.fecha,
        horario: mesa.horario,
        activa: !mesa.activa,
      );
    });
  }

  Future<void> _eliminarMesa(MesaExamen mesa) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar mesa'),
          content: Text(
            '¿Querés eliminar la mesa de ${_nombreMateria(mesa.materiaId)}?',
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
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      AppData.mesas.removeWhere(
        (m) => m.id == mesa.id,
      );

      AppData.inscripciones.removeWhere(
        (i) => i.mesaExamenId == mesa.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mesas = AppData.mesas.where((mesa) {
      if (_filtroEstado == null) {
        return true;
      }

      if (_filtroEstado == 'activas') {
        return mesa.activa;
      }

      return !mesa.activa;
    }).toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Mesas de examen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        onPressed: AppData.materias.isEmpty
            ? null
            : () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: DropdownButtonFormField<String>(
              value: _filtroEstado,
              decoration: InputDecoration(
                labelText: 'Filtrar por estado',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.filter_list,
                  color: darkerBlue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('Todas'),
                ),
                DropdownMenuItem(
                  value: 'activas',
                  child: Text('Activas'),
                ),
                DropdownMenuItem(
                  value: 'inactivas',
                  child: Text('Inactivas'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _filtroEstado = value;
                });
              },
            ),
          ),
          Expanded(
            child: mesas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay mesas registradas.',
                      style: TextStyle(
                        color: darkerBlue,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: mesas.length,
                    itemBuilder: (context, index) {
                      final mesa = mesas[index];

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
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.event_note_outlined,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            _nombreMateria(mesa.materiaId),
                            style: const TextStyle(
                              color: lightText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${_formatearFecha(mesa.fecha)} · ${mesa.horario}\n'
                              '${_nombreCarrera(mesa.materiaId)}\n'
                              '${mesa.activa ? 'Activa' : 'Inactiva'}',
                              style: TextStyle(
                                color: mesa.activa
                                    ? lightText
                                    : Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: lightText,
                            ),
                            onSelected: (value) {
                              if (value == 'inscriptos') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InscriptosScreen(
                                      mesa: mesa,
                                    ),
                                  ),
                                );
                              } else if (value == 'editar') {
                                _mostrarFormulario(mesa: mesa);
                              } else if (value == 'estado') {
                                _cambiarEstado(mesa);
                              } else if (value == 'eliminar') {
                                _eliminarMesa(mesa);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'inscriptos',
                                child: Text('Ver inscriptos'),
                              ),
                              const PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'estado',
                                child: Text(
                                  mesa.activa
                                      ? 'Desactivar'
                                      : 'Activar',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'eliminar',
                                child: Text('Eliminar'),
                              ),
                            ],
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
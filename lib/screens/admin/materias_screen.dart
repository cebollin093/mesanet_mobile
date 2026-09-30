import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/materia.dart';
import '../../models/correlatividad.dart';

class MateriasScreen extends StatefulWidget {
  const MateriasScreen({super.key});

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  String? _carreraSeleccionada;

  String _nombreCarrera(String carreraId) {
    final carrera = AppData.carreras.where(
      (c) => c.id == carreraId,
    );

    return carrera.isEmpty ? 'Carrera desconocida' : carrera.first.nombre;
  }

  bool _tieneReferencias(String materiaId) {
    return AppData.mesas.any((mesa) => mesa.materiaId == materiaId) ||
        AppData.correlatividades.any(
          (correlatividad) =>
              correlatividad.materiaId == materiaId ||
              correlatividad.materiaCorrelativaId == materiaId,
        ) ||
        AppData.historialAcademico.any(
          (historial) => historial.materiaId == materiaId,
        );
  }

  Future<void> _eliminarMateria(Materia materia) async {
    if (_tieneReferencias(materia.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede eliminar la materia porque tiene datos asociados.',
          ),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: background,
          title: const Text(
            'Eliminar materia',
            style: TextStyle(
              color: darkerBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('¿Querés eliminar la materia "${materia.nombre}"?'),
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
                    onPressed: () => Navigator.pop(dialogContext, false),
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
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    if (_tieneReferencias(materia.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede eliminar la materia porque tiene datos asociados.',
          ),
        ),
      );
      return;
    }

    setState(() {
      AppData.materias.removeWhere((m) => m.id == materia.id);
    });
  }

  void _mostrarFormulario({Materia? materia}) {
    final nombreController = TextEditingController(
      text: materia?.nombre ?? '',
    );

    String? carreraId = materia?.carreraId ??
        (AppData.carreras.isNotEmpty
            ? AppData.carreras.first.id
            : null);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: background,
              title: Text(
                materia == null ? 'Nueva materia' : 'Editar materia',
                style: const TextStyle(
                  color: darkerBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la materia',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: carreraId,
                    decoration: InputDecoration(
                      labelText: 'Carrera',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: AppData.carreras.map((carrera) {
                      return DropdownMenuItem(
                        value: carrera.id,
                        child: Text(
                          carrera.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: materia == null
                        ? (value) {
                            setDialogState(() {
                              carreraId = value;
                            });
                          }
                        : null,
                  ),
                ],
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
                          final nombre = nombreController.text.trim();

                          if (nombre.isEmpty || carreraId == null) {
                            return;
                          }

                          setState(() {
                            if (materia == null) {
                              AppData.materias.add(
                                Materia(
                                  id: 'materia_${DateTime.now().millisecondsSinceEpoch}',
                                  nombre: nombre,
                                  carreraId: carreraId!,
                                ),
                              );
                            } else {
                              final index = AppData.materias.indexWhere(
                                (m) => m.id == materia.id,
                              );

                              if (index != -1) {
                                AppData.materias[index] = Materia(
                                  id: materia.id,
                                  nombre: nombre,
                                  carreraId: materia.carreraId,
                                );
                              }
                            }
                          });

                          Navigator.pop(dialogContext);
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

  bool _hayCaminoHasta({
    required String desdeMateriaId,
    required String hastaMateriaId,
    required String materiaEditadaId,
  }) {
    final visitadas = <String>{};

    bool recorrer(String materiaId) {
      if (materiaId == hastaMateriaId) {
        return true;
      }

      if (!visitadas.add(materiaId)) {
        return false;
      }

      for (final correlatividad in AppData.correlatividades) {
        if (correlatividad.materiaId == materiaEditadaId ||
            correlatividad.materiaId != materiaId) {
          continue;
        }

        if (recorrer(correlatividad.materiaCorrelativaId)) {
          return true;
        }
      }

      return false;
    }

    return recorrer(desdeMateriaId);
  }

  void _mostrarCorrelatividades(Materia materia) {
    final existentes = AppData.correlatividades
        .where((c) => c.materiaId == materia.id)
        .map((c) => c.materiaCorrelativaId)
        .toSet();

    final seleccionadas = Set<String>.from(existentes);

    final materiasDisponibles = AppData.materias
        .where(
          (m) =>
              m.id != materia.id &&
              m.carreraId == materia.carreraId,
        )
        .toList();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: background,
              title: Text(
                'Correlatividades',
                style: const TextStyle(
                  color: darkerBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: materiasDisponibles.isEmpty
                    ? const Text(
                        'No hay otras materias disponibles para establecer como correlativas.',
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: materiasDisponibles.map((m) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(m.nombre),
                              value: seleccionadas.contains(m.id),
                              activeColor: orange,
                              onChanged: (value) {
                                setDialogState(() {
                                  if (value == true) {
                                    seleccionadas.add(m.id);
                                  } else {
                                    seleccionadas.remove(m.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
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
                          final generaCiclo = seleccionadas.any(
                            (correlativaId) => _hayCaminoHasta(
                              desdeMateriaId: correlativaId,
                              hastaMateriaId: materia.id,
                              materiaEditadaId: materia.id,
                            ),
                          );

                          if (generaCiclo) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'La selección genera una correlatividad circular.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            AppData.correlatividades.removeWhere(
                              (c) => c.materiaId == materia.id,
                            );

                            for (final correlativaId in seleccionadas) {
                              AppData.correlatividades.add(
                                Correlatividad(
                                  id: 'corr_${DateTime.now().microsecondsSinceEpoch}',
                                  materiaId: materia.id,
                                  materiaCorrelativaId: correlativaId,
                                ),
                              );
                            }
                          });

                          Navigator.pop(dialogContext);
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

  @override
  Widget build(BuildContext context) {
    final materias = _carreraSeleccionada == null
        ? AppData.materias
        : AppData.materias
            .where(
              (m) => m.carreraId == _carreraSeleccionada,
            )
            .toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Materias',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        onPressed: AppData.carreras.isEmpty
            ? null
            : () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: DropdownButtonFormField<String>(
              value: _carreraSeleccionada,
              decoration: InputDecoration(
                labelText: 'Filtrar por carrera',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.school_outlined,
                  color: darkerBlue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Todas las carreras'),
                ),
                ...AppData.carreras.map(
                  (carrera) => DropdownMenuItem<String>(
                    value: carrera.id,
                    child: Text(
                      carrera.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _carreraSeleccionada = value;
                });
              },
            ),
          ),
          Expanded(
            child: materias.isEmpty
                ? const Center(
                    child: Text(
                      'No hay materias registradas.',
                      style: TextStyle(
                        color: darkerBlue,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: materias.length,
                    itemBuilder: (context, index) {
                      final materia = materias[index];

                      final correlativas = AppData.correlatividades
                          .where(
                            (c) => c.materiaId == materia.id,
                          )
                          .toList();

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
                              Icons.menu_book_outlined,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            materia.nombre,
                            style: const TextStyle(
                              color: lightText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${_nombreCarrera(materia.carreraId)}\n'
                              '${correlativas.length} correlatividad(es)',
                              style: const TextStyle(
                                color: lightText,
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
                              if (value == 'editar') {
                                _mostrarFormulario(
                                  materia: materia,
                                );
                              } else if (value == 'correlativas') {
                                _mostrarCorrelatividades(materia);
                              } else if (value == 'eliminar') {
                                _eliminarMateria(materia);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'correlativas',
                                child: Text(
                                  'Correlatividades',
                                ),
                              ),
                              PopupMenuItem(
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
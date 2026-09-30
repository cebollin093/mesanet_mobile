import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/carrera.dart';

class CarrerasScreen extends StatefulWidget {
  const CarrerasScreen({super.key});

  @override
  State<CarrerasScreen> createState() => _CarrerasScreenState();
}

class _CarrerasScreenState extends State<CarrerasScreen> {
  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  void _mostrarFormulario({Carrera? carrera}) {
    final nombreController = TextEditingController(
      text: carrera?.nombre ?? '',
    );

    bool activa = carrera?.activa ?? true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: background,
              title: Text(
                carrera == null ? 'Nueva carrera' : 'Editar carrera',
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
                      labelText: 'Nombre de la carrera',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Carrera activa'),
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

                          if (nombre.isEmpty) {
                            return;
                          }

                          setState(() {
                            if (carrera == null) {
                              AppData.carreras.add(
                                Carrera(
                                  id: 'carrera_${DateTime.now().millisecondsSinceEpoch}',
                                  nombre: nombre,
                                  activa: activa,
                                ),
                              );
                            } else {
                              final index = AppData.carreras.indexWhere(
                                (c) => c.id == carrera.id,
                              );

                              if (index != -1) {
                                AppData.carreras[index] = Carrera(
                                  id: carrera.id,
                                  nombre: nombre,
                                  activa: activa,
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

  void _cambiarEstado(Carrera carrera) {
    final index = AppData.carreras.indexWhere(
      (c) => c.id == carrera.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      AppData.carreras[index] = Carrera(
        id: carrera.id,
        nombre: carrera.nombre,
        activa: !carrera.activa,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final carreras = AppData.carreras;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Carreras',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
      body: carreras.isEmpty
          ? const Center(
              child: Text(
                'No hay carreras registradas.',
                style: TextStyle(
                  color: darkerBlue,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: carreras.length,
              itemBuilder: (context, index) {
                final carrera = carreras[index];

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
                        Icons.school_outlined,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      carrera.nombre,
                      style: const TextStyle(
                        color: lightText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        carrera.activa ? 'Activa' : 'Inactiva',
                        style: TextStyle(
                          color: carrera.activa
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: lightText,
                      ),
                      onSelected: (value) {
                        if (value == 'editar') {
                          _mostrarFormulario(carrera: carrera);
                        } else if (value == 'estado') {
                          _cambiarEstado(carrera);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        PopupMenuItem(
                          value: 'estado',
                          child: Text(
                            carrera.activa
                                ? 'Desactivar'
                                : 'Activar',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
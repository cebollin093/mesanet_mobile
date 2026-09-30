import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/usuario.dart';

class AlumnosScreen extends StatefulWidget {
  const AlumnosScreen({super.key});

  @override
  State<AlumnosScreen> createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  final TextEditingController _busquedaController =
      TextEditingController();

  String _busqueda = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Usuario> _obtenerAlumnos() {
    return AppData.usuarios.where((usuario) {
      if (usuario.rol != 'alumno') {
        return false;
      }

      final texto = _busqueda.toLowerCase().trim();

      if (texto.isEmpty) {
        return true;
      }

      return usuario.nombre.toLowerCase().contains(texto) ||
          usuario.apellido.toLowerCase().contains(texto) ||
          usuario.dni.toLowerCase().contains(texto);
    }).toList();
  }

  String _nombreCarrera(String carreraId) {
    final carreras = AppData.carreras.where(
      (carrera) => carrera.id == carreraId,
    );

    return carreras.isEmpty
        ? 'Carrera desconocida'
        : carreras.first.nombre;
  }

  int _materiasAprobadas(Usuario alumno) {
    return AppData.historialAcademico
        .where(
          (historial) =>
              historial.usuarioId == alumno.id &&
              historial.aprobada,
        )
        .map((historial) => historial.materiaId)
        .toSet()
        .length;
  }

  int _totalMaterias(Usuario alumno) {
    return AppData.materias
        .where((materia) => materia.carreraId == alumno.carreraId)
        .length;
  }

  double _progreso(Usuario alumno) {
    final total = _totalMaterias(alumno);

    if (total == 0) {
      return 0;
    }

    return _materiasAprobadas(alumno) / total;
  }

  void _mostrarPerfil(Usuario alumno) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _AlumnoDetalleScreen(
          alumno: alumno,
          nombreCarrera: _nombreCarrera(alumno.carreraId),
          materiasAprobadas: _materiasAprobadas(alumno),
          totalMaterias: _totalMaterias(alumno),
          progreso: _progreso(alumno),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alumnos = _obtenerAlumnos();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Alumnos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: TextField(
              controller: _busquedaController,
              onChanged: (value) {
                setState(() {
                  _busqueda = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, apellido o DNI',
                prefixIcon: const Icon(
                  Icons.search,
                  color: darkerBlue,
                ),
                suffixIcon: _busqueda.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _busquedaController.clear();
                          setState(() {
                            _busqueda = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: border,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${alumnos.length} alumno${alumnos.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: darkerBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: alumnos.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron alumnos.',
                      style: TextStyle(
                        color: darkerBlue,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: alumnos.length,
                    itemBuilder: (context, index) {
                      final alumno = alumnos[index];
                      final aprobadas = _materiasAprobadas(alumno);
                      final total = _totalMaterias(alumno);

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
                          onTap: () => _mostrarPerfil(alumno),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: orange,
                            child: Text(
                              alumno.nombre.isEmpty
                                  ? '?'
                                  : alumno.nombre[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                              'DNI: ${alumno.dni}\n'
                              '${_nombreCarrera(alumno.carreraId)}\n'
                              '$aprobadas de $total materias aprobadas',
                              style: const TextStyle(
                                color: lightText,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: lightText,
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

class _AlumnoDetalleScreen extends StatelessWidget {
  final Usuario alumno;
  final String nombreCarrera;
  final int materiasAprobadas;
  final int totalMaterias;
  final double progreso;

  const _AlumnoDetalleScreen({
    required this.alumno,
    required this.nombreCarrera,
    required this.materiasAprobadas,
    required this.totalMaterias,
    required this.progreso,
  });

  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  String _nombreMateria(String materiaId) {
    final materias = AppData.materias.where(
      (materia) => materia.id == materiaId,
    );

    return materias.isEmpty
        ? 'Materia desconocida'
        : materias.first.nombre;
  }

  List<dynamic> _historial() {
    return AppData.historialAcademico
        .where(
          (historial) =>
              historial.usuarioId == alumno.id &&
              AppData.materias.any(
                (materia) =>
                    materia.id == historial.materiaId &&
                    materia.carreraId == alumno.carreraId,
              ),
        )
        .toList();
  }

  List<dynamic> _materiasPendientes() {
    final aprobadas = AppData.historialAcademico
        .where(
          (historial) =>
              historial.usuarioId == alumno.id &&
              historial.aprobada,
        )
        .map((historial) => historial.materiaId)
        .toSet();

    return AppData.materias
        .where(
          (materia) =>
              materia.carreraId == alumno.carreraId &&
              !aprobadas.contains(materia.id),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final historial = _historial();
    final pendientes = _materiasPendientes();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Perfil del alumno',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: border,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: orange,
                  child: Text(
                    alumno.nombre.isEmpty
                        ? '?'
                        : alumno.nombre[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${alumno.apellido}, ${alumno.nombre}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: lightText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'DNI: ${alumno.dni}',
                  style: const TextStyle(
                    color: lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alumno.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: lightText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  nombreCarrera,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progreso académico',
                  style: TextStyle(
                    color: darkerBlue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progreso,
                          minHeight: 10,
                          backgroundColor: border,
                          color: orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progreso * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: darkerBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '$materiasAprobadas de $totalMaterias materias aprobadas',
                  style: const TextStyle(
                    color: darkerBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Seccion(
            titulo: 'Historial académico',
            icono: Icons.school_outlined,
            child: historial.isEmpty
                ? const Text(
                    'No hay resultados académicos registrados.',
                    style: TextStyle(
                      color: darkerBlue,
                    ),
                  )
                : Column(
                    children: historial.map((registro) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _nombreMateria(registro.materiaId),
                                style: const TextStyle(
                                  color: darkerBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Nota: ${registro.nota}',
                              style: const TextStyle(
                                color: darkerBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              registro.aprobada
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: registro.aprobada
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 16),
          _Seccion(
            titulo: 'Materias pendientes',
            icono: Icons.pending_actions_outlined,
            child: pendientes.isEmpty
                ? const Text(
                    'No hay materias pendientes.',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Column(
                    children: pendientes.map((materia) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          materia.nombre,
                          style: const TextStyle(
                            color: darkerBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Widget child;

  const _Seccion({
    required this.titulo,
    required this.icono,
    required this.child,
  });

  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color border = Color(0xFFB8D0E2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icono,
                color: darkerBlue,
              ),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  color: darkerBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
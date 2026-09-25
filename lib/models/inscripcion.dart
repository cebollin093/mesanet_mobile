class Inscripcion {
  final String id;
  final String usuarioId;
  final String mesaExamenId;
  final DateTime fechaInscripcion;
  final String condicion;

  Inscripcion({
    required this.id,
    required this.usuarioId,
    required this.mesaExamenId,
    required this.fechaInscripcion,
    required this.condicion,
  });
}
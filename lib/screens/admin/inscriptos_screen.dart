import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../../data/app_data.dart';
import '../../models/mesa_examen.dart';
import '../../models/usuario.dart';

class InscriptosScreen extends StatelessWidget {
  final MesaExamen mesa;

  const InscriptosScreen({
    super.key,
    required this.mesa,
  });

  static const Color background = Color(0xFFD0E2EF);
  static const Color darkBlue = Color(0xFF1E5A94);
  static const Color darkerBlue = Color(0xFF123B6D);
  static const Color orange = Color(0xFFF28C28);
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  String _nombreMateria() {
    final materias = AppData.materias.where(
      (m) => m.id == mesa.materiaId,
    );

    return materias.isEmpty ? 'Materia desconocida' : materias.first.nombre;
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  List<Map<String, dynamic>> _obtenerInscriptos() {
    final inscripciones = AppData.inscripciones
        .where((i) => i.mesaExamenId == mesa.id)
        .toList();

    final resultado = <Map<String, dynamic>>[];

    for (final inscripcion in inscripciones) {
      final usuarios = AppData.usuarios.where(
        (u) => u.id == inscripcion.usuarioId,
      );

      if (usuarios.isEmpty) {
        continue;
      }

      final usuario = usuarios.first;

      resultado.add({
        'usuario': usuario,
        'condicion': inscripcion.condicion,
        'fecha': inscripcion.fechaInscripcion,
      });
    }

    return resultado;
  }

  Future<void> _generarPdf(
    BuildContext context,
    List<Map<String, dynamic>> inscriptos,
  ) async {
    final pdf = pw.Document();

    final pdfDarkBlue = PdfColor.fromInt(0xFF123B6D);
    final pdfBlue = PdfColor.fromInt(0xFF1E5A94);
    final pdfOrange = PdfColor.fromInt(0xFFF28C28);
    final pdfLightBlue = PdfColor.fromInt(0xFFD0E2EF);
    final pdfBorder = PdfColor.fromInt(0xFFB8D0E2);
    final pdfText = PdfColor.fromInt(0xFF1F2937);
    final pdfWhite = PdfColors.white;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(
          40,
          35,
          40,
          45,
        ),
        header: (context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 20),
            padding: const pw.EdgeInsets.only(
              bottom: 12,
            ),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: pdfBorder,
                  width: 1,
                ),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 34,
                  height: 34,
                  decoration: pw.BoxDecoration(
                    color: pdfOrange,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'M',
                    style: pw.TextStyle(
                      color: pdfWhite,
                      fontSize: 19,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Text(
                  'MesaNet',
                  style: pw.TextStyle(
                    color: pdfDarkBlue,
                    fontSize: 21,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
        footer: (context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 20),
            padding: const pw.EdgeInsets.only(top: 10),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(
                  color: pdfBorder,
                  width: 1,
                ),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'MesaNet · Gestión de mesas de examen',
                  style: pw.TextStyle(
                    color: pdfDarkBlue,
                    fontSize: 8,
                  ),
                ),
                pw.Text(
                  'Página ${context.pageNumber} de ${context.pagesCount}',
                  style: pw.TextStyle(
                    color: pdfText,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          );
        },
        build: (context) {
          return [
            pw.Text(
              'Listado de alumnos inscriptos',
              style: pw.TextStyle(
                color: pdfDarkBlue,
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Registro de inscripción a mesa de examen',
              style: pw.TextStyle(
                color: pdfText,
                fontSize: 11,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: pdfLightBlue,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(
                  color: pdfBorder,
                  width: 1,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _nombreMateria(),
                    style: pw.TextStyle(
                      color: pdfDarkBlue,
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Fecha',
                              style: pw.TextStyle(
                                color: pdfBlue,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              _formatearFecha(mesa.fecha),
                              style: pw.TextStyle(
                                color: pdfText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Horario',
                              style: pw.TextStyle(
                                color: pdfBlue,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              mesa.horario,
                              style: pw.TextStyle(
                                color: pdfText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Inscriptos',
                              style: pw.TextStyle(
                                color: pdfBlue,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              '${inscriptos.length} alumno(s)',
                              style: pw.TextStyle(
                                color: pdfText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),
            pw.TableHelper.fromTextArray(
              headers: [
                'N.º',
                'Alumno',
                'DNI',
                'Condición',
              ],
              data: inscriptos.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final Usuario usuario = item['usuario'];

                return [
                  '${index + 1}',
                  '${usuario.apellido}, ${usuario.nombre}',
                  usuario.dni,
                  item['condicion'],
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color: pdfWhite,
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(
                color: pdfDarkBlue,
              ),
              cellStyle: pw.TextStyle(
                color: pdfText,
                fontSize: 9,
              ),
              cellPadding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 9,
              ),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
              },
              columnWidths: {
                0: const pw.FixedColumnWidth(35),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.5),
              },
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide(
                  color: pdfBorder,
                  width: 0.6,
                ),
                verticalInside: pw.BorderSide(
                  color: pdfBorder,
                  width: 0.6,
                ),
                top: pw.BorderSide(
                  color: pdfDarkBlue,
                  width: 1,
                ),
                bottom: pw.BorderSide(
                  color: pdfBorder,
                  width: 1,
                ),
                left: pw.BorderSide(
                  color: pdfBorder,
                  width: 1,
                ),
                right: pw.BorderSide(
                  color: pdfBorder,
                  width: 1,
                ),
              ),
              rowDecoration: pw.BoxDecoration(
                color: pdfWhite,
              ),
              oddRowDecoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF4F8FB),
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              decoration: pw.BoxDecoration(
                color: pdfBlue,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Documento generado por MesaNet',
                style: pw.TextStyle(
                  color: pdfWhite,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inscriptos = _obtenerInscriptos();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Text(
          'Inscriptos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Generar PDF',
            onPressed: inscriptos.isEmpty
                ? null
                : () => _generarPdf(context, inscriptos),
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nombreMateria(),
                  style: const TextStyle(
                    color: lightText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_formatearFecha(mesa.fecha)} · ${mesa.horario}',
                  style: const TextStyle(
                    color: lightText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${inscriptos.length} alumno(s) inscripto(s)',
                  style: const TextStyle(
                    color: lightText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: inscriptos.isEmpty
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
                      0,
                      20,
                      20,
                    ),
                    itemCount: inscriptos.length,
                    itemBuilder: (context, index) {
                      final item = inscriptos[index];
                      final Usuario usuario = item['usuario'];

                      final DateTime fecha =
                          item['fecha'] as DateTime;

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
                              usuario.nombre.isNotEmpty
                                  ? usuario.nombre[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            '${usuario.apellido}, ${usuario.nombre}',
                            style: const TextStyle(
                              color: lightText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'DNI: ${usuario.dni}\n'
                              'Condición: ${item['condicion']}\n'
                              'Inscripto: ${_formatearFecha(fecha)}',
                              style: const TextStyle(
                                color: lightText,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          isThreeLine: true,
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
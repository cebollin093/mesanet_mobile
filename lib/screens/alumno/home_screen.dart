import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/inscripcion.dart';
import '../../models/materia.dart';
import '../../models/mesa_examen.dart';
import 'exam_session_detail_screen.dart';
import 'inicio_screen.dart';
import 'mesas_screen.dart';
import 'carrera_screen.dart';
import 'inscripciones_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Inscripcion> _enrollments = AppData.inscripciones;

  int _currentIndex = 0;

  final List<String> _titles = const [
    'Inicio',
    'Mesas de examen',
    'Mi carrera',
    'Mis inscripciones',
  ];

  Future<void> _openExamDetail({
    required MesaExamen mesa,
    required Materia materia,
  }) async {
    final existingEnrollment = _enrollments.where(
      (enrollment) => enrollment.mesaExamenId == mesa.id,
    );

    final Inscripcion? enrollment =
        existingEnrollment.isNotEmpty ? existingEnrollment.first : null;

    final result = await Navigator.push<Inscripcion>(
      context,
      MaterialPageRoute(
        builder: (context) => ExamSessionDetailScreen(
          mesa: mesa,
          materia: materia,
          initialCondition: enrollment?.condicion,
          initialEnrolled: enrollment != null,

          // La inscripción se guarda inmediatamente
          // al confirmar desde ExamSessionDetailScreen.
          onEnrollmentConfirmed: (newEnrollment) {
            setState(() {
              _enrollments.removeWhere(
                (enrollment) => enrollment.mesaExamenId == mesa.id,
              );
              _enrollments.add(newEnrollment);
            });
          },
        ),
      ),
    );

    // Se mantiene como respaldo para cuando la pantalla
    // devuelve la inscripción mediante Navigator.pop().
    if (result != null) {
      setState(() {
        _enrollments.removeWhere(
          (enrollment) => enrollment.mesaExamenId == mesa.id,
        );
        _enrollments.add(result);
      });
    }
  }

  void _cancelEnrollment(String mesaExamenId) {
    setState(() {
      _enrollments.removeWhere(
        (enrollment) => enrollment.mesaExamenId == mesaExamenId,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La inscripción fue cancelada.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InicioScreen(
        enrollments: _enrollments,
      ),
      MesasScreen(
        enrollments: _enrollments,
        onOpenExamDetail: _openExamDetail,
      ),
      const CarreraScreen(),
      InscripcionesScreen(
        enrollments: _enrollments,
        onCancelEnrollment: _cancelEnrollment,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Mesas',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Carrera',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Inscripciones',
          ),
        ],
      ),
    );
  }
}
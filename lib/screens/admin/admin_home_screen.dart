import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/app_data.dart';
import '../auth/login_screen.dart';
import 'alumnos_screen.dart';
import 'carreras_screen.dart';
import 'materias_screen.dart';
import 'mesas_admin_screen.dart';
import 'resultados_academicos_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  static const Color background = AppTheme.backgroundColor;
  static const Color darkBlue = AppTheme.secondaryColor;
  static const Color darkerBlue = AppTheme.primaryColor;
  static const Color orange = AppTheme.accentColor;
  static const Color border = Color(0xFFB8D0E2);
  static const Color lightText = Color(0xFFEAF2F8);

  // Colores específicos de los paneles estadísticos.
  static const Color careersColor = Color(0xFF287D7A);
  static const Color subjectsColor = Color(0xFF5C5AA6);
  static const Color examsColor = Color(0xFFD97725);
  static const Color studentsColor = Color(0xFF356B7A);

  // Fondo específico de los accesos de gestión académica.
  static const Color optionBackground = Color(0xFFE8F0F5);
  static const Color optionText = AppTheme.primaryColor;

  @override
  Widget build(BuildContext context) {
    final carreras = AppData.carreras.length;
    final materias = AppData.materias.length;
    final mesas = AppData.mesas.length;
    final alumnos = AppData.usuarios
        .where((usuario) => usuario.rol == 'alumno')
        .length;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: darkerBlue,
        foregroundColor: lightText,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MesaNet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Panel administrativo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido, Administrador',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkerBlue,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Gestioná la información académica de MesaNet.',
                style: TextStyle(
                  fontSize: 15,
                  color: darkerBlue,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.school_outlined,
                      title: 'Carreras',
                      value: '$carreras',
                      color: careersColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.menu_book_outlined,
                      title: 'Materias',
                      value: '$materias',
                      color: subjectsColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.event_note_outlined,
                      title: 'Mesas',
                      value: '$mesas',
                      color: examsColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.people_outline,
                      title: 'Alumnos',
                      value: '$alumnos',
                      color: studentsColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Gestión académica',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkerBlue,
                ),
              ),
              const SizedBox(height: 14),
              _AdminOption(
                icon: Icons.school_outlined,
                title: 'Carreras',
                description: 'Crear y administrar carreras.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CarrerasScreen(),
                    ),
                  );
                },
              ),
              _AdminOption(
                icon: Icons.menu_book_outlined,
                title: 'Materias',
                description: 'Administrar materias y correlatividades.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MateriasScreen(),
                    ),
                  );
                },
              ),
              _AdminOption(
                icon: Icons.event_note_outlined,
                title: 'Mesas de examen',
                description: 'Crear y administrar mesas de examen.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MesasAdminScreen(),
                    ),
                  );
                },
              ),
              _AdminOption(
                icon: Icons.people_outline,
                title: 'Alumnos',
                description: 'Consultar alumnos y su progreso académico.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlumnosScreen(),
                    ),
                  );
                },
              ),
              _AdminOption(
                icon: Icons.assignment_turned_in_outlined,
                title: 'Resultados académicos',
                description: 'Registrar resultados de los exámenes.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResultadosAcademicosScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AdminHomeScreen.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AdminHomeScreen.lightText,
            size: 27,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AdminHomeScreen.lightText,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AdminHomeScreen.lightText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AdminOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AdminHomeScreen.optionBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AdminHomeScreen.border,
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
            color: AdminHomeScreen.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AdminHomeScreen.optionText,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            color: AdminHomeScreen.optionText,
            fontSize: 13,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AdminHomeScreen.optionText,
          size: 17,
        ),
        onTap: onTap,
      ),
    );
  }
}
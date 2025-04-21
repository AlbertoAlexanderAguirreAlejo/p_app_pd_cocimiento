import 'package:app_pd_cocimiento/domain/models/app/vista.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:app_pd_cocimiento/features/presion_agua/providers/presion_agua_provider.dart';
import 'package:app_pd_cocimiento/features/presion_agua/views/pa_columna_screen.dart';
import 'package:app_pd_cocimiento/features/presion_agua/views/pa_piscina_screen.dart';
import 'package:app_pd_cocimiento/widgets/custom_bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class PresionAguaScreen extends StatefulWidget {
  const PresionAguaScreen({super.key});

  @override
  State<PresionAguaScreen> createState() => _PresionAguaScreenState();
}

class _PresionAguaScreenState extends State<PresionAguaScreen> {
  int _currentIndex = 0;

  // Lista de Vistas
  static const List<Vista> _views = [
    Vista(
      screen: PAPiscinaScreen(),
      title: 'Presión Piscina',
      subtitle: 'Piscina',
      icon: FontAwesome.person_swimming_solid,
      color: AppTheme.blue,
    ),
    Vista(
      screen: PAColumnaScreen(),
      title: 'Presión Columna',
      subtitle: 'Columna',
      icon: FontAwesome.chart_simple_solid,
      color: AppTheme.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier dato necesario al cargar la pantalla.
    // Por ejemplo, cargar datos desde un provider o base de datos.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PresionAguaProvider>(context, listen: false);
      provider.initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: _views[_currentIndex].title,
      bottom: CustomBottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _views.map((vista) => CustomBottomNavigationBarItem(
          icon: vista.icon ?? Icons.circle,
          label: vista.subtitle,
          color: vista.color!,
        )).toList(),
      ),
      children: [
        _views[_currentIndex].screen,
      ],
    );
  }
}
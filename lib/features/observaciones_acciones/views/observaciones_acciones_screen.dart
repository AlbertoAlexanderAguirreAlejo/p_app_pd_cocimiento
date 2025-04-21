import 'package:app_pd_cocimiento/features/observaciones_acciones/views/oa_acciones_correctivas_screen.dart';
import 'package:app_pd_cocimiento/features/observaciones_acciones/views/oa_observaciones_screen.dart';
import 'package:app_pd_cocimiento/widgets/custom_fab_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/domain/models/app/vista.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:app_pd_cocimiento/widgets/custom_bottom_navigation_bar_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:icons_plus/icons_plus.dart';

class ObservacionesAccionesScreen extends StatefulWidget {
  const ObservacionesAccionesScreen({super.key});

  @override
  State<ObservacionesAccionesScreen> createState() =>
      _ObservacionesAccionesScreenState();
}

class _ObservacionesAccionesScreenState
    extends State<ObservacionesAccionesScreen> {
  int _currentIndex = 0;

  static const List<Vista> _views = [
    Vista(
      screen: OAObservacionesScreen(),
      title: 'Observaciones',
      subtitle: 'Observaciones',
      icon: FontAwesome.comments_solid,
      color: AppTheme.blue,
    ),
    Vista(
      screen: OAAccionesCorrectivasScreen(),
      title: 'Acciones Correctivas',
      subtitle: 'Acciones',
      icon: FontAwesome.wrench_solid,
      color: AppTheme.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final current = _views[_currentIndex];
    return CustomScaffoldWidget(
      title: current.title,
      floatingActionButton: CustomFloatingActionButtonWidget(
        onPressed: (){},
        icon: FontAwesome.plus_solid,
        backgroundColor: AppTheme.darkGreen,
      ),
      bottom: CustomBottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _views
            .map((v) => CustomBottomNavigationBarItem(
                  icon: v.icon!,
                  label: v.subtitle,
                  color: v.color!,
                ))
            .toList(),
      ),
      children: [
        current.screen,
      ],
    );
  }
}

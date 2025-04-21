import 'package:app_pd_cocimiento/domain/models/app/vista.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/providers/nivel_tanques_provider.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/views/nt_extension_screen.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/views/nt_tachos_screen.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/views/nt_vacuum_screen.dart';
import 'package:app_pd_cocimiento/widgets/custom_bottom_navigation_bar_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class NivelTanquesScreen extends StatefulWidget {

  const NivelTanquesScreen({super.key});

  @override
  State<NivelTanquesScreen> createState() => _NivelTanquesScreenState();
}

class _NivelTanquesScreenState extends State<NivelTanquesScreen> {
  int _currentIndex = 0;

  // Lista de Vistas
  static const List<Vista> _views = [
    Vista(
      screen: NTTachosScreen(),
      title: 'Nivel - Tachos',
      subtitle: 'Tachos',
      icon: FontAwesome.trash_solid,
      color: AppTheme.blue,
    ),
    Vista(
      screen: NTExtensionScreen(),
      title: 'Nivel - Extensión Miel',
      subtitle: 'Ext. Miel',
      icon: FontAwesome.jar_solid,
      color: AppTheme.orange,
    ),
    Vista(
      screen: NTVacuumScreen(),
      title: 'Nivel - Vacuumpanes',
      subtitle: 'Vacuumpanes',
      icon: FontAwesome.industry_solid,
      color: AppTheme.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Aquí puedes inicializar cualquier dato necesario al cargar la pantalla.
    // Por ejemplo, cargar datos desde un provider o base de datos.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NivelTanquesProvider>(context, listen: false);
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
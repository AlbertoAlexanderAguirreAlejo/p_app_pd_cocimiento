import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/widgets/custom_appbar_rocket_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_card_v_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:app_pd_cocimiento/widgets/side_menu.dart';
import 'package:app_pd_cocimiento/features/home/providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeProv = Provider.of<HomeProvider>(context, listen: false);

    // Helper para navegar y refrescar al volver
    Future<void> pushAndRefresh(String route, BuildContext ctx) async {
      await Navigator.pushNamed(ctx, route);
      setState(() {}); // dispara rebuild al volver
    }

    return PopScope(
      canPop: false,
      child: CustomScaffoldWidget(
        title: 'Inicio',
        drawer: SideMenu(onRoleChanged: (_) => setState(() {})),
        appBar: CustomAppBarRocketWidget(
          title: '¿Está seguro de enviar los registros a la base de datos?',
          description:
              'Esta opción realizará el envío del Parte Diario de Cocimiento del Turno 1 del 01/04/2025',
          function: () async {},
        ),
        children: [
          // Fila 1: Actividades Tachos & Presión Agua
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: FutureBuilder<bool>(
                  future: homeProv.validateDetalleForCabecera(),
                  builder: (ctx, snap) {
                    final color = (snap.hasData && snap.data == true)
                        ? AppTheme.darkGreen
                        : AppTheme.red;
                    return CustomCardVWidget(
                      title: 'Actividades\nTachos',
                      imageRoute: 'assets/images/actividades_tachos.png',
                      color: color,
                      onTap: () => pushAndRefresh('actividades_tachos', ctx),
                    );
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<bool>(
                  future: homeProv.validatePresionAgua(),
                  builder: (ctx, snap) {
                    final color = (snap.hasData && snap.data == true)
                        ? AppTheme.darkGreen
                        : AppTheme.red;
                    return CustomCardVWidget(
                      title: 'Presión\nAgua',
                      imageRoute: 'assets/images/presion_agua.png',
                      color: color,
                      onTap: () => pushAndRefresh('presion_agua', ctx),
                    );
                  },
                ),
              ),
            ],
          ),

          // Fila 2: Nivel Tachos y Tanques Miel & Nivel Graneros
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: FutureBuilder<bool>(
                  future: homeProv.validateNivelTachosTanques(),
                  builder: (ctx, snap) {
                    final color = (snap.hasData && snap.data == true)
                        ? AppTheme.darkGreen
                        : AppTheme.red;
                    return CustomCardVWidget(
                      title: 'Nivel Tachos\ny Tanques Miel',
                      imageRoute: 'assets/images/nivel_tanques.png',
                      color: color,
                      onTap: () => pushAndRefresh('nivel_tanques', ctx),
                    );
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<bool>(
                  future: homeProv.validateNivelGraneros(),
                  builder: (ctx, snap) {
                    final color = (snap.hasData && snap.data == true)
                        ? AppTheme.darkGreen
                        : AppTheme.red;
                    return CustomCardVWidget(
                      title: 'Nivel\nGraneros',
                      imageRoute: 'assets/images/nivel_granero.png',
                      color: color,
                      onTap: () => pushAndRefresh('nivel_graneros', ctx),
                    );
                  },
                ),
              ),
            ],
          ),

          // Fila 3: Nivel Cristalizadores & Observaciones
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: FutureBuilder<bool>(
                  future: homeProv.validateNivelCristalizadores(),
                  builder: (ctx, snap) {
                    final color = (snap.hasData && snap.data == true)
                        ? AppTheme.darkGreen
                        : AppTheme.red;
                    return CustomCardVWidget(
                      title: 'Nivel\nCristalizadores',
                      imageRoute: 'assets/images/nivel_cristalizador.png',
                      color: color,
                      onTap: () => pushAndRefresh('nivel_cristalizadores', ctx),
                    );
                  },
                ),
              ),
              Expanded(
                child: CustomCardVWidget(
                  title: 'Observaciones\ny Acciones Corr.',
                  imageRoute: 'assets/images/observaciones.png',
                  color: AppTheme.silverBlue,
                  onTap: () => pushAndRefresh('observaciones_acciones', context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/date_formatter.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/widgets/at_item_widget.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/widgets/at_filtros_modal_widget.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/widgets/at_filter_chips_widget.dart';
import 'package:app_pd_cocimiento/app.dart';
import 'package:app_pd_cocimiento/widgets/custom_appbar_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_fab_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_provider.dart';

class ActividadesTachosScreen extends StatefulWidget {
  const ActividadesTachosScreen({super.key});

  @override
  State<ActividadesTachosScreen> createState() => _ActividadesTachosScreenState();
}

class _ActividadesTachosScreenState extends State<ActividadesTachosScreen> {
  void _mostrarFiltroGlobal() {
    // Utilizando el navigatorKey global definido en main.dart
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      builder: (_) => const ATFiltrosModalWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<ActividadesTachosProvider>(context, listen: false);
      provider.loadFilterOptions();
      provider.fetchDetalles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Actividades Tachos',
      appBar: CustomAppBarWidget(
        actions: [
          IconButton(
            icon: Icon(FontAwesome.filter_solid),
            onPressed: _mostrarFiltroGlobal,
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButtonWidget(
        onPressed: () {
          Navigator.pushNamed(context, 'at_registro', arguments: null);
        },
        icon: FontAwesome.plus_solid,
        backgroundColor: AppTheme.darkGreen,
      ),
      children: [
        Consumer<ActividadesTachosProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                const ATFilterChipsWidget(),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (provider.detalles.isEmpty)
                  const SizedBox()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.detalles.length,
                    itemBuilder: (context, index) {
                      final detalle = provider.detalles[index];
                      return ActividadesTachosItemWidget(
                        key: ValueKey(detalle.idFabConPdDet),
                        fecha: formatIsoDate(detalle.fechaNotificacion, pattern: 'dd MMM ~ hh:mm a'),
                        actividad: detalle.descripcionActividad.toString(),
                        recipiente: detalle.descripcionRecipiente.toString(),
                        tipoMasa: detalle.descripcionTipoMasa.toString(),
                        onDelete: () async {
                          await Provider.of<ActividadesTachosProvider>(context, listen: false)
                              .eliminarDetalle(detalle);
                        },
                        // Dentro del onTap del item:
                        onEdit: () {
                          Navigator.pushNamed(context, 'at_registro', arguments: detalle);
                        },
                      );
                    },
                  )
              ],
            );
          },
        ),
      ],
    );
  }
}
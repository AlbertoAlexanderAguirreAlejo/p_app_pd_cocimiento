import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/date_formatter.dart';
import 'package:app_pd_cocimiento/core/utils/message_toast.dart';
import 'package:app_pd_cocimiento/features/mantenimiento/providers/mantenimiento_provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_appbar_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_icon_button_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:app_pd_cocimiento/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class MantenimientoScreen extends StatefulWidget {

  const MantenimientoScreen({super.key});

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MantenimientoProvider>(context, listen: false)
          .fetchMaintenanceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Mantenimiento',
      appBar: CustomAppBarWidget(
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<MantenimientoProvider>(context, listen: false)
                    .updateAllModules();
                messageToast(descripcion: "Actualización global realizada");
              } catch (e) {
                // Muestra un mensaje de error si ocurre alguna excepción.
                messageToast(descripcion: "Error en actualización global", color: AppTheme.red);
              }
            },
            icon: const Icon(FontAwesome.rotate_solid),
            tooltip: "Actualizar todo",
          )
        ],
      ),
      children: [
        Consumer<MantenimientoProvider>(
          builder: (context, mantenimientoProvider, child) {
            if (mantenimientoProvider.isLoading) {
              return LoadingIndicator(texto: 'Actualizando Maestros',);
            }
            if (mantenimientoProvider.maintenanceItems.isEmpty) {
              return const Center(child: Text("No hay información de Mantenimiento."));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: mantenimientoProvider.maintenanceItems.length,
              itemBuilder: (context, index) {
                final item = mantenimientoProvider.maintenanceItems[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      item.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blue,
                      ),
                    ),
                    subtitle: Text(
                      "Última actualización:\n${item.ultimaActualizacion.isNotEmpty ? formatIsoDate(item.ultimaActualizacion) : 'Nunca sincronizado'}",
                    ),
                    trailing: CustomIconButton(
                      icon: FontAwesome.rotate_solid,
                      backgroundColor: AppTheme.orange,
                      onPressed: () async {
                        try {
                          await Provider.of<MantenimientoProvider>(context, listen: false)
                              .updateModule(item.tabla);
                          messageToast(descripcion: "Actualización de ${item.titulo} realizada");
                        } catch (e) {
                          messageToast(descripcion: "Error en actualización de ${item.titulo}", color: AppTheme.red);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
import 'package:app_pd_cocimiento/domain/models/db/actividad.dart';
import 'package:app_pd_cocimiento/domain/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/domain/models/db/tipo_masa.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_det.dart';
import 'package:app_pd_cocimiento/core/shared/utils/message_toast.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_provider.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_registro_provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_button_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_date_time_picker_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_dropdown_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ATRegistroScreen extends StatefulWidget {
  const ATRegistroScreen({super.key});

  @override
  State<ATRegistroScreen> createState() => _ATRegistroScreenState();
}

class _ATRegistroScreenState extends State<ATRegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializa los datos en el provider y verifica si se pasó un registro para edición.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registroProvider = Provider.of<ActividadesTachosRegistroProvider>(context, listen: false);
      registroProvider.initData();
      final detalle = ModalRoute.of(context)!.settings.arguments;
      if (detalle != null) {
        registroProvider.cargarDetalleParaEdicion(detalle as ConPdDet);
      } else {
        registroProvider.editingDetalle = null;
        registroProvider.selectedDateTime = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el provider para calcular si estamos en modo edición.
    final registroProvider = Provider.of<ActividadesTachosRegistroProvider>(context);
    final bool isEditing = registroProvider.editingDetalle != null;
    return CustomScaffoldWidget(
      title: isEditing ? 'Actualizar Actividad' : 'Registrar Actividad',
      children: [
        Consumer<ActividadesTachosRegistroProvider>(
          builder: (context, provider, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Paso 1: Seleccionar Tacho (siempre se muestra)
                    CustomDropdownWidget<Recipiente, int>(
                      label: "Tacho:",
                      hintText: "Seleccione el Tacho",
                      selectedItem: provider.selectedTacho,
                      items: provider.tachos,
                      valueExtractor: (item) => item.idFabRecipiente,
                      itemLabel: (item) => item.descripcion,
                      onChanged: (value) => provider.selectTacho(value),
                    ),
                    // Paso 2: Fecha y Hora (se muestra siempre)
                    CustomDateTimePickerWidget(
                      label: "Fecha y Hora:",
                      hintText: "Seleccione fecha y hora",
                      initialDateTime: provider.selectedDateTime,
                      onChanged: (newDateTime) {
                        debugPrint("Nueva fecha: $newDateTime");
                        provider.selectedDateTime = newDateTime;
                      },
                      dateFormat: 'd MMM yyyy hh:mm:ss a',
                    ),
                    // Paso 3: Seleccionar Tipo de Masa (siempre se muestra)
                    if (provider.selectedTacho != null)
                      FutureBuilder<List<TipoMasa>>(
                        future: provider.fetchFilteredTiposMasa(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const CircularProgressIndicator();
                          return CustomDropdownWidget<TipoMasa, int>(
                            label: "Tipo de Masa:",
                            hintText: "Seleccione el Tipo de Masa",
                            selectedItem: provider.selectedTipoMasa,
                            items: snapshot.data!,
                            valueExtractor: (item) => item.idFabTipoMasa,
                            itemLabel: (tm) => tm.descripcion,
                            onChanged: (value) => provider.selectTipoMasa(value),
                          );
                        },
                      ),
                    // Solo en modo creación se muestran los siguientes pasos.
                    if (!isEditing) ...[
                      // Paso 4: Seleccionar Actividad (si se seleccionó Tipo de Masa)
                      if (provider.selectedTipoMasa != null)
                        FutureBuilder<List<Actividad>>(
                          future: provider.fetchFilteredActividades(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const CircularProgressIndicator();
                            return CustomDropdownWidget<Actividad, int>(
                              label: "Actividad:",
                              hintText: "Seleccione la Actividad",
                              selectedItem: provider.selectedActividad,
                              items: snapshot.data!,
                              valueExtractor: (item) => item.idFabActividad,
                              itemLabel: (a) => a.descripcion,
                              onChanged: (value) => provider.selectActividad(value),
                            );
                          },
                        ),
                      // Paso 5: Tacho Destino (si la actividad requiere)
                      if (provider.selectedActividad != null && provider.selectedActividad!.flagDestinoActividad != 0)
                        FutureBuilder<List<Recipiente>>(
                          future: provider.fetchFilteredTachosDestino(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const CircularProgressIndicator();
                            return CustomDropdownWidget<Recipiente, int>(
                              hintText: "Seleccione el tacho destino",
                              label: "Tacho Destino:",
                              selectedItem: provider.selectedTachoDestino,
                              items: snapshot.data!,
                              valueExtractor: (r) => r.idFabRecipiente,
                              itemLabel: (r) => r.descripcion,
                              onChanged: provider.selectTachoDestino,
                            );
                          },
                        ),
                      // Paso 6: Cristalizador (si la actividad requiere)
                      if (provider.selectedActividad != null && provider.selectedActividad!.flagCristalizador == 1)
                        FutureBuilder<List<Recipiente>>(
                          future: provider.fetchFilteredCristalizadores(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const CircularProgressIndicator();
                            return CustomDropdownWidget<Recipiente, int>(
                              hintText: "Seleccione el cristalizador",
                              label: "Cristalizador:",
                              selectedItem: provider.selectedCristalizador,
                              items: snapshot.data!,
                              valueExtractor: (r) => r.idFabRecipiente,
                              itemLabel: (r) => r.descripcion,
                              onChanged: provider.selectCristalizador,
                            );
                          },
                        ),
                    ],
                    // Botón para registrar o actualizar
                    CustomButtonWidget(
                      text: isEditing ? 'Actualizar Actividad' : 'Registrar Actividad',
                      extendWidth: true,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await provider.registrarActividad();
                            await Provider.of<ActividadesTachosProvider>(context, listen: false).fetchDetalles();
                            messageToast(
                              descripcion: isEditing ? 'Actividad Actualizada' : 'Actividad Registrada'
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            messageToast(descripcion: "Error: ${e.toString()}");
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
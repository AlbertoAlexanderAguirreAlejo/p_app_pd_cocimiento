import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_dropdown_widget.dart';
import 'package:app_pd_cocimiento/widgets/custom_filter_modal_widget.dart';

class ATFiltrosModalWidget extends StatelessWidget {
  const ATFiltrosModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActividadesTachosProvider>(context);
    return CustomFilterModalWidget(
      dropdowns: [
        // Dropdown para Tacho
        CustomDropdownWidget<String, String>(
          label: 'Filtrar por Tacho',
          hintText: 'Seleccione Tacho',
          selectedItem: provider.filterRecipiente,
          items: provider.filterRecipientes,
          valueExtractor: (item) => item,
          itemLabel: (item) => item,
          onChanged: (value) => provider.filterRecipiente = value,
        ),
        // Dropdown para Actividad
        CustomDropdownWidget<String, String>(
          label: 'Filtrar por Actividad',
          hintText: 'Seleccione Actividad',
          selectedItem: provider.filterActividad,
          items: provider.filterActividades,
          valueExtractor: (item) => item,
          itemLabel: (item) => item,
          onChanged: (value) => provider.filterActividad = value,
        ),
        // Dropdown para Tipo de Masa
        CustomDropdownWidget<String, String>(
          label: 'Filtrar por Tipo de Masa',
          hintText: 'Seleccione Tipo de Masa',
          selectedItem: provider.filterTipoMasa,
          items: provider.filterTiposMasa,
          valueExtractor: (item) => item,
          itemLabel: (item) => item,
          onChanged: (value) => provider.filterTipoMasa = value,
        ),
      ],
      onApply: () => provider.fetchDetalles(),
      onClear: () {
        provider.filterActividad = null;
        provider.filterTipoMasa = null;
        provider.filterRecipiente = null;
        provider.fetchDetalles();
      },
    );
  }
}
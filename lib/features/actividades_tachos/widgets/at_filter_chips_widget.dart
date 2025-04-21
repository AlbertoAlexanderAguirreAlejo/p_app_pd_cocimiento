import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/features/actividades_tachos/providers/actividades_tachos_provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_chip_widget.dart';

class ATFilterChipsWidget extends StatelessWidget {
  const ATFilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActividadesTachosProvider>(context);
    final List<Widget> chips = [];

    if (provider.filterRecipiente != null && provider.filterRecipiente!.isNotEmpty) {
      chips.add(
        CustomChipWidget(
          label: provider.filterRecipiente!,
          leading: const Icon(FontAwesome.filter_solid),
          onDeleted: () {
            provider.filterRecipiente = null;
            provider.fetchDetalles();
          },
        ),
      );
    }
    if (provider.filterActividad != null && provider.filterActividad!.isNotEmpty) {
      chips.add(
        CustomChipWidget(
          label: provider.filterActividad!,
          leading: const Icon(FontAwesome.filter_solid),
          onDeleted: () {
            provider.filterActividad = null;
            provider.fetchDetalles();
          },
        ),
      );
    }
    if (provider.filterTipoMasa != null && provider.filterTipoMasa!.isNotEmpty) {
      chips.add(
        CustomChipWidget(
          label: provider.filterTipoMasa!,
          leading: const Icon(FontAwesome.filter_solid),
          onDeleted: () {
            provider.filterTipoMasa = null;
            provider.fetchDetalles();
          },
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }
}
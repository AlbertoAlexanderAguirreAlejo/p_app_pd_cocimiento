import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/providers/nivel_tanques_provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_tank_level_card_widget_slider.dart';
import 'package:app_pd_cocimiento/core/models/db/con_pd_nivel.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';

class NTVacuumScreen extends StatelessWidget {
  const NTVacuumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NivelTanquesProvider>(
      builder: (context, provider, child) {
        final items = provider.nivelItemsVacuum;
        if (items.isEmpty) {
          return const Center(child: Text('No hay datos disponibles'));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final ConPdNivel record = items[i];
            final Recipiente rec = provider.recipientesVacuum.firstWhere(
              (r) => r.idFabRecipiente == record.idFabConPdRecipiente,
            );
            return CustomTankLevelCardSliderWidget(
              title: rec.descripcion,
              initialLevel: record.nivel,
              pasos: 20,
              onLevelChanged: (newValue) {
                provider.updateNivel(record.idFabConPdNivel, newValue);
              },
            );
          },
        );
      },
    );
  }
}
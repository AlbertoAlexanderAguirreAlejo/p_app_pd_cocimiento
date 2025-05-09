import 'package:app_pd_cocimiento/features/nivel_tanques/widgets/custom_tank_level_card_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/features/nivel_tanques/providers/nivel_tanques_provider.dart';
import 'package:app_pd_cocimiento/domain/models/db/material.dart';
import 'package:app_pd_cocimiento/domain/models/db/con_pd_nivel.dart';
import 'package:app_pd_cocimiento/domain/models/db/recipiente.dart';

class NTTachosScreen extends StatelessWidget {
  const NTTachosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NivelTanquesProvider>(
      builder: (context, provider, child) {
        final items = provider.nivelItemsTachos;
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
            final Recipiente rec = provider.recipientesTachos.firstWhere(
              (r) => r.idFabRecipiente == record.idFabConPdRecipiente,
            );
            return CustomTankLevelCardHorizontalWidget<Materiales>(
              leftHeaderText: rec.descripcion,
              dropdownItems: provider.listaMateriales,
              selectedDropdownItem: record.idFabMaterial == 0
                ? null
                : Materiales(
                    idFabMaterial: record.idFabMaterial,
                    descripcion: '',
                    descCorta: '',
                    flagEstado: 1,
                  ),
              onDropdownChanged: (mat) {
                if (mat != null) {
                  provider.updateMaterial(
                    record.idFabConPdNivel,
                    mat.idFabMaterial,
                  );
                }
              },
              initialLevel: record.nivel,
              onLevelChanged: (value) =>
                provider.updateNivel(record.idFabConPdNivel, value),
            );
          },
        );
      },
    );
  }
}

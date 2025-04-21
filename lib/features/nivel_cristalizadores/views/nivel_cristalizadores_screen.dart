import 'package:app_pd_cocimiento/widgets/custom_tank_level_card_widget_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_scaffold_widget.dart';
import 'package:app_pd_cocimiento/features/nivel_cristalizadores/providers/nivel_cristalizadores_provider.dart';
import 'package:app_pd_cocimiento/core/models/db/con_pd_nivel.dart';
import 'package:app_pd_cocimiento/core/models/db/recipiente.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';

class NivelCristalizadoresScreen extends StatefulWidget {
  const NivelCristalizadoresScreen({super.key});

  @override
  State<NivelCristalizadoresScreen> createState() => _NivelCristalizadoresScreenState();
}

class _NivelCristalizadoresScreenState extends State<NivelCristalizadoresScreen> {
  @override
  void initState() {
    super.initState();
    // Inicializar datos mediante el provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NivelCristalizadoresProvider>(context, listen: false).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Nivel Cristalizadores',
      children: [
        Consumer<NivelCristalizadoresProvider>(
          builder: (context, provider, child) {
            if (provider.nivelItems.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            // Mostrar los items en un ListView.
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.nivelItems.length,
              itemBuilder: (context, index) {
                ConPdNivel nivelRecord = provider.nivelItems[index];
                // Buscar el recipiente correspondiente.
                Recipiente? rec = provider.recipientes.firstWhere(
                  (element) => element.idFabRecipiente == nivelRecord.idFabConPdRecipiente,
                  orElse: () => Recipiente(
                    idFabRecipiente: nivelRecord.idFabConPdRecipiente,
                    descripcion: "Recipiente ${nivelRecord.idFabConPdRecipiente}",
                    flagTipo: 6,
                    flagEstado: 1,
                  ),
                );
                return CustomTankLevelCardSliderWidget(
                  title: rec.descripcion,
                  headerColor: AppTheme.darkGreen,
                  initialLevel: nivelRecord.nivel,
                  onLevelChanged: (newValue) {
                    // newValue es un double entre 0 y 1; se actualiza el registro.
                    provider.updateNivel(nivelRecord.idFabConPdNivel, newValue);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
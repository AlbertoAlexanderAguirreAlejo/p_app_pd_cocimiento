import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/date_formatter.dart';
import 'package:app_pd_cocimiento/features/presion_agua/widgets/pa_item_widget.dart';
import 'package:app_pd_cocimiento/features/presion_agua/providers/presion_agua_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PAColumnaScreen extends StatefulWidget {
  const PAColumnaScreen({super.key});

  @override
  State<PAColumnaScreen> createState() => _PAColumnaScreenState();
}

class _PAColumnaScreenState extends State<PAColumnaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PresionAguaProvider>(context, listen: false).fetchPresionAgua();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PresionAguaProvider>(
      builder: (context, provider, child) {
        final items = provider.presionColumna;
        if (items.isEmpty) {
          return const Center(child: Text("No hay registros para Columna"));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final String timeLabel = formatIsoDate(item.fechaNotificacion, pattern: 'hh:mm a');
            return PAItemWidget(
              timeLabel: timeLabel,
              psigValue: item.pSig == 0? '' : item.pSig.toString(),
              selectedTacho: (item.idFabRecipiente == 0 || provider.tachos.isEmpty)
                  ? null
                  : provider.tachos.firstWhere((t) => t.idFabRecipiente == item.idFabRecipiente,
                      orElse: () => provider.tachos.first),
              tachos: provider.tachos,
              onTachoChanged: (newTacho) async {
                if (newTacho != null) {
                  await Provider.of<PresionAguaProvider>(context, listen: false)
                      .updateTacho(item.idFabConPdAgua, newTacho.idFabRecipiente);
                }
              },
              onPsigChanged: (newValue) async {
                double? parsed = double.tryParse(newValue);
                if (parsed != null) {
                  await Provider.of<PresionAguaProvider>(context, listen: false)
                      .updatePsig(item.idFabConPdAgua, parsed);
                }
              },
              // Define el color del header según la condición
              headerColor: (item.idFabRecipiente == 0 || item.pSig == 0)
                  ? AppTheme.red
                  : AppTheme.darkGreen,
            );
          },
        );
      },
    );
  }
}

import 'package:app_pd_cocimiento/core/constants/app_constants.dart';
import 'package:app_pd_cocimiento/core/utils/custom_alert.dart';
import 'package:app_pd_cocimiento/widgets/custom_item_card_widget.dart';
import 'package:flutter/material.dart';

class ActividadesTachosItemWidget extends StatelessWidget {
  final String fecha;
  final String recipiente;
  final String tipoMasa;
  final String actividad;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ActividadesTachosItemWidget({
    super.key,
    required this.fecha,
    required this.recipiente,
    required this.tipoMasa,
    required this.actividad,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      onLongPress: () {
        // Llama a la alerta personalizada para confirmar la eliminación.
        showCustomAlert(
          info: false,
          descripcion: [
            const WidgetSpan(
              child: Icon(
                Icons.delete,
                size: 60,
                color: Colors.red,
              ),
            ),
            const TextSpan(
              text: '\n\nELIMINAR REGISTRO\n\n',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const TextSpan(
              text: 'Fecha: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '$fecha\n'),
            const TextSpan(
              text: 'Recipiente: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '$recipiente\n'),
            const TextSpan(
              text: 'Tipo de masa: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '$tipoMasa\n'),
            const TextSpan(
              text: 'Actividad: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '$actividad\n\n'),
            const TextSpan(
              text: '¿Está seguro de proceder? Esta acción no se puede deshacer.',
            ),
          ],
          funcion: () async {
            Navigator.pop(context);
            onDelete();
          },
        );
      },
      child: CustomItemCardWidget(
        headerTitle: fecha,
        headerColor: Colors.blue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.delete, color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      recipiente,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: AppConstants.subTitleSize,
                      ),
                    ),
                  ],
                ),
                Text(
                  tipoMasa,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                    fontSize: AppConstants.subTitleSize,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                actividad,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.subTitleSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
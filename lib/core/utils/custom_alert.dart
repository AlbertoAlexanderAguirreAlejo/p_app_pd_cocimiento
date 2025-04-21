import 'package:app_pd_cocimiento/widgets/custom_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/app.dart'; // Asegúrate de importar el archivo donde definiste navigatorKey

void showCustomAlert({
  required bool info,
  required List<InlineSpan> descripcion,
  Function()? funcion,
  bool? danger,
}) {
  final context = navigatorKey.currentContext;
  if (context == null) return; // Si no hay context, aborta la llamada.

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.75),
            dismissible: false,
          ),
          AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            clipBehavior: Clip.antiAlias,
            scrollable: true,
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: CustomAlertWidget(
              info: info,
              descripcion: descripcion,
              funcion: funcion,
              danger: danger ?? false,
            ),
          ),
        ],
      );
    },
  );
}

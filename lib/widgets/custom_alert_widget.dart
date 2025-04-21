import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAlertWidget extends StatelessWidget {

  final List<InlineSpan> descripcion;
  final bool info;
  final Function()? funcion;
  final bool danger;

  const CustomAlertWidget({
    super.key,
    required this.descripcion,
    required this.info,
    this.funcion,
    required this.danger,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: RichText(textAlign: TextAlign.center, text: TextSpan(style: TextStyle(fontSize: 22, height: 1.5, color: AppTheme.shellColor), children: descripcion)
          ),
        ),
        Row(
          children: [
            if(!info) Expanded(
              flex: 1,
              child: InkWell(
                child: Ink(
                  padding: const EdgeInsets.all(15),
                  color: AppTheme.red,
                  child: const Text(
                    'Cancelar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      shadows: [Shadow(color: Colors.black12, offset: Offset(2, 2))]
                    ),
                  ),
                  ),
                  onTap: () {Navigator.pop(context);},
                )
              ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: !info? funcion : () => Navigator.pop(context),
                child: Ink(
                  padding: const EdgeInsets.all(15),
                  color: !info? AppTheme.green : (danger? AppTheme.red : AppTheme.green),
                  child: const Text(
                    'Aceptar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      shadows: [Shadow(color: Colors.black12, offset: Offset(2, 2))]
                    ),
                  ),
                  ),
                )
              ),
          ],
        )
      ],
    );
  }
}
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/shared/utils/loading_status.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String texto;

  const LoadingIndicator({super.key, required this.texto});


  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    LoadingStatus estados = LoadingStatus();

    return Material(
      color: AppTheme.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          estados.cargando(),
          Container(
              margin: const EdgeInsets.only(bottom: 20, top: 20),
              child: Center(child: Text(texto,style: const TextStyle(letterSpacing: 2,fontSize: 21),))),
        ],
      ),
    );
  }
}
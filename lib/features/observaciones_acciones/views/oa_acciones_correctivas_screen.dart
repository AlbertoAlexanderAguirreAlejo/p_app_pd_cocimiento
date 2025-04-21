import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';

class OAAccionesCorrectivasScreen extends StatefulWidget {
  const OAAccionesCorrectivasScreen({super.key});

  @override
  State<OAAccionesCorrectivasScreen> createState() =>
      _OAAccionesCorrectivasScreenState();
}

class _OAAccionesCorrectivasScreenState
    extends State<OAAccionesCorrectivasScreen> {
  @override
  void initState() {
    super.initState();
    // Si en el futuro tienes un provider:
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<AccionesProvider>(context, listen: false).fetchAll();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Reemplaza con un ListView.builder usando tu provider cuando lo tengas
    return Center(
      child: Text(
        'No hay acciones correctivas registradas.',
        style: TextStyle(color: AppTheme.orange),
      ),
    );
  }
}

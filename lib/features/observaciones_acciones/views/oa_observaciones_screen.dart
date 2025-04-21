import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';

class OAObservacionesScreen extends StatefulWidget {
  const OAObservacionesScreen({super.key});

  @override
  State<OAObservacionesScreen> createState() => _OAObservacionesScreenState();
}

class _OAObservacionesScreenState extends State<OAObservacionesScreen> {
  @override
  void initState() {
    super.initState();
    // Si en el futuro tienes un provider:
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ObservacionesProvider>(context, listen: false).fetchAll();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Reemplaza con un ListView.builder usando tu provider cuando lo tengas
    return Center(
      child: Text(
        'No hay observaciones registradas.',
        style: TextStyle(color: AppTheme.silverBlue),
      ),
    );
  }
}

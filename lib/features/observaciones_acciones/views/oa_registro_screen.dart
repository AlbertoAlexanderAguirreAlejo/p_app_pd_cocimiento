import 'package:flutter/material.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';

class OARegistroScreen extends StatefulWidget {
  const OARegistroScreen({super.key});

  @override
  State<OARegistroScreen> createState() => _OARegistroScreenState();
}

class _OARegistroScreenState extends State<OARegistroScreen> {
  @override
  void initState() {
    super.initState();
    // Si en el futuro tienes un provider:
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<OARegistroProvider>(context, listen: false).fetchAll();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Reemplaza con un ListView.builder usando tu provider cuando lo tengas
    return Center(
      child: Text(
        'No hay OARegistro registradas.',
        style: TextStyle(color: AppTheme.silverBlue),
      ),
    );
  }
}

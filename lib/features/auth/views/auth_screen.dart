import 'package:app_pd_cocimiento/data/services/update_service.dart';
import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/shared/utils/custom_alert.dart';
import 'package:app_pd_cocimiento/features/auth/providers/auth_provider.dart';
import 'package:app_pd_cocimiento/features/auth/widgets/login_form.dart';
import 'package:app_pd_cocimiento/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthProvider authProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startUpdateService();
    });
  }

  Future<void> _startUpdateService() async {
    try {
      if (!kIsWeb) {
        await UpdateService.startImmediateUpdate();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authProvider.loading
          ? const LoadingIndicator(texto: 'Iniciando Sesión...')
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_login.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Image(
                      image: AssetImage('assets/images/logoAipsa.png'),
                      width: 300,
                    ),
                    SizedBox(height: 50),
                    LoginForm(onLogin: (value) {
                      if (value) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        showCustomAlert(info: true, danger: true, descripcion: [
                          const WidgetSpan(child: Icon(FontAwesome.circle_xmark, size: 60, color: AppTheme.red,)),
                          const TextSpan(text: '\n\nCredenciales Incorrectas\n\n', style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'El usuario o la clave de acceso son incorrectos.'),
                        ]);
                      }
                    },),
                  ],
                ),
              ),
            ),
    );
  }
}

import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/features/auth/providers/auth_provider.dart';
import 'package:app_pd_cocimiento/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {

  final Function(bool) onLogin;

  const LoginForm({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: authProvider.authFormKey,
          child: Column(
            spacing: 20,
            children: [
              const Text(
                'Parte Diario de Cocimiento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.dark,
                ),
              ),
              // Campo para el Usuario
              TextFormField(
                initialValue: authProvider.user,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su Usuario';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: Icon(EvaIcons.person_outline, color: AppTheme.blue),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z]')),
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (value) => authProvider.updateUser(value), // Usar updateUser
              ),
              // Campo para la Clave de acceso
              TextFormField(
                initialValue: authProvider.pass,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: !authProvider.isVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su Clave de acceso';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Clave de acceso',
                  prefixIcon: const Icon(EvaIcons.lock_outline, color: AppTheme.blue),
                  suffixIcon: IconButton(
                    onPressed: authProvider.showPass,
                    icon: authProvider.iconEye,
                  ),
                ),
                onChanged: (value) => authProvider.updatePass(value), // Usar updatePass
              ),
              // Botón para iniciar sesión
              Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      text: 'Iniciar sesión',
                      onTap: () async {
                        if (!authProvider.authFormKey.currentState!.validate()) return;

                        // Activa el loading y realiza el login.
                        bool success = await authProvider.login();
                        onLogin(success);
                      },
                    ),
                  ),
                ],
              ),
              const Text('ISI Mobile', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

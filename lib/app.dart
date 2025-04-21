// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/config/bootstrap.dart';
import 'core/preferences/preferences_service.dart';
import 'core/preferences/app_preferences.dart';
import 'core/theme/app_theme.dart';

import 'app/providers.dart';
import 'app/routes.dart';

/// Clave global para navegar desde cualquier parte de la app.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Creamos el PreferencesService y AppPreferences a partir de SharedPreferences ya cargadas en Bootstrap
    final preferencesService = PreferencesService(Bootstrap.prefs);
    final appPreferences = AppPreferences(preferencesService);

    return MultiProvider(
      providers: [
        // Primero inyectamos las preferencias
        Provider<PreferencesService>.value(value: preferencesService),
        Provider<AppPreferences>.value(value: appPreferences),

        // Luego todos los providers modulados
        ...repositoryProviders,
        ...serviceProviders,
        ...uiProviders,
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'PD Cocimiento',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: Routes.auth,
        routes: appRoutes,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'ES'),
        ],
        builder: (context, child) {
          // Fuerza escala de texto lineal
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: child!,
          );
        },
      ),
    );
  }
}
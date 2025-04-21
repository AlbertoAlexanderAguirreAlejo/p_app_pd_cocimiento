import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/core/utils/date_formatter.dart';
import 'package:app_pd_cocimiento/data/services/auth_service.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/data/services/cabecera_service.dart';
import 'package:app_pd_cocimiento/data/services/ora_service.dart';
import 'package:app_pd_cocimiento/data/services/sync_service.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class AuthProvider extends ChangeNotifier {
  final authFormKey = GlobalKey<FormState>();

  bool isVisible = false;
  bool loading = false;
  String user;
  String pass;
  Icon iconEye = const Icon(
    EvaIcons.eye_off_2_outline,
    color: AppTheme.red,
  );

  final AppPreferences _appPreferences;
  final SyncService _syncService;
  final AuthService _authService;
  final CabeceraService _cabeceraService;

  OraService oraService = OraService();

  AuthProvider({
    required AppPreferences appPreferences,
    required SyncService syncService,
    required AuthService authService,
    required CabeceraService cabeceraService,
  })  : _appPreferences = appPreferences,
        _syncService = syncService,
        _authService = authService,
        _cabeceraService = cabeceraService,
        user = appPreferences.user,
        pass = appPreferences.pass;

  void updateUser(String newUser) {
    user = newUser;
    notifyListeners();
  }

  void updatePass(String newPass) {
    pass = newPass;
    notifyListeners();
  }

  void showPass() {
    isVisible = !isVisible;
    iconEye = isVisible
        ? const Icon(EvaIcons.eye_outline, color: AppTheme.red)
        : const Icon(EvaIcons.eye_off_2_outline, color: AppTheme.red);
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<bool> login() async {
    setLoading(true);
    try {
      final response = await _authService.login(user: user, pass: pass);

      if (response.estado == true) {
        // Actualiza las preferencias de usuario.
        await _appPreferences.setUser(user);
        await _appPreferences.setPass(pass);
        await _appPreferences.setNombres(response.nombre);
        await _appPreferences.setNroDoc(response.nrodoc);

        int turno = _appPreferences.activeTurno;
        if (turno == 0) {
          turno = 1; // Por defecto se usa 1 si no hay asignación.
        }

        DateTime now = DateTime.now();
        String headerText;
        String activeFecha;

        if (turno == 0) {
          final yesterday = now.subtract(const Duration(days: 1));
          final String datePart = DateFormat('yyyy-MM-dd').format(yesterday);
          headerText = "${formatIsoDate(datePart, pattern: 'd MMM yyyy')} ~ Turno 3";
          activeFecha = datePart;
        } else {
          final String datePart = DateFormat('yyyy-MM-dd').format(now);
          headerText = "${formatIsoDate(datePart, pattern: 'd MMM yyyy')} ~ Turno $turno";
          activeFecha = datePart;
        }

        // Llama al servicio de cabecera para buscar o crear el registro y obtener su id.
        int cabeceraId = await _cabeceraService.getOrCreateCabecera(now, turno);

        // Actualiza las preferencias con el turno, header, id de cabecera y fecha.
        await _appPreferences.setActiveTurno(turno, headerText, cabeceraId, activeFecha);

        await _syncService.syncAllMaestros();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

}
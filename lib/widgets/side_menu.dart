// side_menu.dart
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/date_formatter.dart';
import 'package:app_pd_cocimiento/core/utils/message_toast.dart';
import 'package:app_pd_cocimiento/data/services/cabecera_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  final Function(String)? onRoleChanged;
  const SideMenu({super.key, this.onRoleChanged});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final AppPreferences preferences = Provider.of<AppPreferences>(context, listen: true);
    // Inyecta el servicio de cabecera.
    final CabeceraService cabeceraService =
        Provider.of<CabeceraService>(context, listen: false);

    return Drawer(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/logoAipsa.png')),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesome.user_tie_solid, color: AppTheme.blue, size: 30),
            title: Text(preferences.nombres, style: const TextStyle(fontSize: 16, color: AppTheme.silverBlue)),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(FontAwesome.rotate_solid, color: AppTheme.orange, size: 30),
            title: const Text('Actualizar Maestros', style: TextStyle(fontSize: 16, color: AppTheme.silverBlue)),
            onTap: () => Navigator.pushNamed(context, 'mantenimiento'),
          ),
          const Divider(height: 0),
          // Opción de selección de turno
          ListTile(
            leading: const Icon(FontAwesome.clock_solid, color: AppTheme.darkGreen, size: 30),
            title: const Text('Turno Activo:', style: TextStyle(fontSize: 16, color: AppTheme.silverBlue)),
            trailing: DropdownButton<int>(
              value: preferences.activeTurno,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Turno 0')),
                DropdownMenuItem(value: 1, child: Text('Turno 1')),
                DropdownMenuItem(value: 2, child: Text('Turno 2')),
                DropdownMenuItem(value: 3, child: Text('Turno 3')),
              ],
              onChanged: (int? newTurno) async {
                if (newTurno == null) return;
                DateTime now = DateTime.now();
                String headerText;
                String activeFecha;

                if (newTurno == 0) {
                  final yesterday = now.subtract(const Duration(days: 1));
                  final String datePart = DateFormat('yyyy-MM-dd').format(yesterday);
                  headerText = "${formatIsoDate(datePart, pattern: 'd MMM yyyy')} ~ Turno 3";
                  activeFecha = datePart;
                } else {
                  final String datePart = DateFormat('yyyy-MM-dd').format(now);
                  headerText = "${formatIsoDate(datePart, pattern: 'd MMM yyyy')} ~ Turno $newTurno";
                  activeFecha = datePart;
                }

                int cabeceraId = await cabeceraService.getOrCreateCabecera(now, newTurno);
                await preferences.setActiveTurno(newTurno, headerText, cabeceraId, activeFecha);
                widget.onRoleChanged?.call(headerText);
                messageToast(descripcion: "Turno actualizado a ${newTurno == 0 ? "Turno 3 de ayer" : "Turno $newTurno"}");
              },
            ),
          ),
          const Divider(height: 0),
          const Spacer(),
          const Divider(height: 0),
          const ListTile(
            leading: Icon(EvaIcons.info_outline, size: 30, color: AppTheme.silverBlue),
            title: Text('Versión: 1.0.0', style: TextStyle(fontSize: 16, color: AppTheme.silverBlue)),
          ),
          const Divider(height: 0),
          InkWell(
            highlightColor: AppTheme.red.withValues(alpha: 0.1),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, 'auth', (route) => false),
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: AppTheme.red,
              child: const ListTile(
                leading: Icon(EvaIcons.log_out, color: Colors.white, size: 30),
                title: Text(
                  'Salir',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

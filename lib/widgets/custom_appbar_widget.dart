import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool? leading;
  final List<Widget>? actions;

  const CustomAppBarWidget({
    super.key,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {

    final String header = Provider.of<AppPreferences>(context, listen: true).activeHeader;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.blue, AppTheme.purpleLight]),
      ),
      child: AppBar(
        automaticallyImplyLeading: leading ?? true,
        centerTitle: true,
        title: Text(
          header.isEmpty ? "-" : header,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: actions ?? [],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

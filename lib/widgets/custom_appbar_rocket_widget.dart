// ignore_for_file: use_build_context_synchronously

import 'package:app_pd_cocimiento/core/preferences/app_preferences.dart';
import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:app_pd_cocimiento/core/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class CustomAppBarRocketWidget extends StatefulWidget implements PreferredSizeWidget{

  final String title;
  final String description;
  final Future<void> Function() function;

  const CustomAppBarRocketWidget({ super.key, required this.title, required this.description, required this.function });

  @override
  State<CustomAppBarRocketWidget> createState() => _CustomAppBarRocketWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarRocketWidgetState extends State<CustomAppBarRocketWidget> {
  @override
  Widget build(BuildContext context) {

    final String header = Provider.of<AppPreferences>(context, listen: true).activeHeader;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.blue, AppTheme.purpleLight])),
      child: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(header, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        elevation: 0,
        titleTextStyle: const TextStyle(fontSize: 16),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () async {
            showCustomAlert(info: false, descripcion: [
              const WidgetSpan(child: Icon(HeroIcons.rocket_launch, size: 60, color: AppTheme.blue,)),
              TextSpan(text: '\n\n${widget.title}\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: widget.description),
            ],
            funcion: () async {
              Navigator.pop(context);
              widget.function();
            },);
          }, icon: const Icon(HeroIcons.rocket_launch))
        ],
      ),
    );
  }
}
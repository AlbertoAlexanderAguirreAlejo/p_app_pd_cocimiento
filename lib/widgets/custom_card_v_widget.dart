import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomCardVWidget extends StatelessWidget {
  const CustomCardVWidget({
    super.key,
    required this.title,
    this.description,
    this.color,
    required this.imageRoute,
    this.onTap,
  });

  final String title;
  final String? description;
  final Color? color;
  final String imageRoute;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap?? () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color?? AppTheme.blue, width: 1.5),
          borderRadius: BorderRadius.circular(30)
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image(
              image: AssetImage(imageRoute),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            // const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color?? AppTheme.blue, fontSize: 22), textAlign: TextAlign.center,),
            if(description != null) Text(description!, softWrap: true, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
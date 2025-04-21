import 'package:app_pd_cocimiento/core/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoadingStatus extends ChangeNotifier {
  List<Widget> loadingGraph = [
    LoadingAnimationWidget.waveDots(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.inkDrop(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.twistingDots(
      leftDotColor: AppTheme.red,
      rightDotColor: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.threeRotatingDots(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.staggeredDotsWave(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.fourRotatingDots(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.fallingDot(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.discreteCircle(
        color: AppTheme.blue,
        size: 100,
        secondRingColor: AppTheme.red,
        thirdRingColor: AppTheme.blue),
    LoadingAnimationWidget.threeArchedCircle(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.bouncingBall(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.flickr(
      leftDotColor: AppTheme.red,
      rightDotColor: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.hexagonDots(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.beat(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.twoRotatingArc(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.horizontalRotatingDots(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.newtonCradle(
      color: AppTheme.blue,
      size: 2 * 100,
    ),
    LoadingAnimationWidget.stretchedDots(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.halfTriangleDot(
      color: AppTheme.blue,
      size: 100,
    ),
    LoadingAnimationWidget.dotsTriangle(
      color: AppTheme.blue,
      size: 100,
    ),
  ];

  Widget cargando() => getRandom();

  Widget getRandom() {
    var random = Random();
    var randomNumber = random.nextInt(19);
    return loadingGraph[randomNumber];
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  double _width;
  double _height;
  double _inchScreen;
  EdgeInsets _safeAreaPaddings;
  bool _isTablet;

  double get width => _width;
  double get height => _height;
  double get inchScreen => _inchScreen;
  EdgeInsets get safeAreaPaddings => _safeAreaPaddings;
  bool get isTablet => _isTablet;

  Responsive.init(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    _safeAreaPaddings = mediaQueryData.padding;
    _width = mediaQueryData.size.width;
    _height = mediaQueryData.size.height;
    _inchScreen = math.sqrt(math.pow(width, 2) + math.pow(height, 2));
    // The equivalent of the "smallestWidth" qualifier on Android.
    var shortestSide = mediaQueryData.size.shortestSide;

// Determine if we should use mobile layout or not. The
// number 600 here is a common breakpoint for a typical
// 7-inch tablet.
    final bool useMobileLayout = shortestSide < 600;
    _isTablet = !useMobileLayout;
  }

  double wp(double porcentaje) {
    return width * (porcentaje / 100);
  }

  double hp(double porcentaje) {
    return height * (porcentaje / 100);
  }

  double ip(double porcentaje) {
    return inchScreen * (porcentaje / 100);
  }
}

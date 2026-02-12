// lib/web_svg_helpers_stub.dart
import 'package:flutter/material.dart';

/// Stub non-web : on retourne un container vide (ce code n'est jamais appelé sur web)
Widget buildNativeSvg(String assetPath, {double? height, double? width}) {
  return const SizedBox.shrink();
}

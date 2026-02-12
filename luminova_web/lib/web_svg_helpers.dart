// lib/web_svg_helpers.dart
// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui; // ✅ CORRECTION : utiliser dart:ui_web, pas dart:ui
import 'package:flutter/material.dart';

Widget buildNativeSvg(String assetPath, {double? height, double? width}) {
  final viewType =
      'svg-${assetPath.hashCode}-${DateTime.now().microsecondsSinceEpoch}';

  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final img =
        html.ImageElement()
          ..src = _resolveAssetUrl(assetPath)
          ..style.objectFit = 'contain'
          ..style.height = '100%'
          ..style.width = '100%'
          ..style.display = 'block';

    final wrapper =
        html.DivElement()
          ..style.height = (height != null) ? '${height}px' : '100%'
          ..style.width = (width != null) ? '${width}px' : 'auto'
          ..style.display = 'inline-block'
          ..style.overflow = 'hidden'
          ..append(img);

    return wrapper;
  });

  return SizedBox(
    height: height,
    width: width,
    child: HtmlElementView(viewType: viewType),
  );
}

String _resolveAssetUrl(String asset) {
  final base = html.window.document.baseUri ?? html.window.location.origin;
  return Uri.parse(base).resolve(asset).toString();
}

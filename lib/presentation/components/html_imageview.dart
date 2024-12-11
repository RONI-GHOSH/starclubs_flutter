import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui;
import 'dart:html' as html;

class HtmlImageView extends StatelessWidget {
  final String imageUrl;

  HtmlImageView({super.key, required this.imageUrl}) {
    if (kIsWeb) {
      // Check if the platform is web before using platformViewRegistry
      ui.platformViewRegistry.registerViewFactory(
        'image-view',
        (int viewId) => html.ImageElement()
          ..src = imageUrl
          ..style.width = '100%'
          ..style.height = '200px'
          ..style.objectFit = 'fit',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox(
        width: 100,
        height: 100,
        child: HtmlElementView(viewType: 'image-view'),
      );
    } else {
      return const Center(child: Text("This is only supported on the web."));
    }
  }
}

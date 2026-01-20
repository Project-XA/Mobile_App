import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  final String? imagePath;
  final String defaultAssetPath;
  final BoxFit fit;
  final int? cacheWidth;
  final int? cacheHeight;

  const AdaptiveImage({
    super.key,
    required this.imagePath,
    required this.defaultAssetPath,
    this.fit = BoxFit.cover,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildAssetImage(defaultAssetPath);
    }

    if (imagePath!.contains('/')) {
      return _buildFileImage(imagePath!);
    }

    return _buildAssetImage(imagePath!);
  }

  Widget _buildFileImage(String path) {
    final file = File(path);

    if (!file.existsSync()) {
      return _buildAssetImage(defaultAssetPath);
    }

    return Image.file(
      file,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Error loading file image: $error');
        return _buildAssetImage(defaultAssetPath);
      },
    );
  }

  Widget _buildAssetImage(String assetPath) {
    return Image.asset(
      assetPath,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.person,
          size: (cacheWidth?.toDouble() ?? 50) / 2,
          color: Colors.grey,
        );
      },
    );
  }
}
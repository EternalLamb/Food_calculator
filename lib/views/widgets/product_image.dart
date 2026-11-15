import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String path;
  final double size;

  const ProductImage({super.key, required this.path, this.size = 50});

  Widget _placeholder() => Container(
    width: size,
    height: size,
    color: Colors.grey[300],
    child: const Icon(Icons.fastfood, color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (path.isEmpty) {
      child = _placeholder();
    } else if (path.startsWith('/') || path.startsWith('file:')) {
      child = Image.file(
        File(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else {
      child = Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return ClipRRect(borderRadius: BorderRadius.circular(8), child: child);
  }
}

import 'package:flutter/material.dart';

const Color primaryGreen = Color(0xFF14532D);
const Color bgGray = Color(0xFFF1F5F9);

final BoxDecoration cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);

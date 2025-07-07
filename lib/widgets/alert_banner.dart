import 'package:flutter/material.dart';

class AlertBanner extends StatelessWidget {
  final String message;
  const AlertBanner({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    if (message == 'Normal') return const SizedBox.shrink();
    return Container(
      color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Text(
        '⚠️ $message',
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
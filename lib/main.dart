import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PillReminderApp());
}

class PillReminderApp extends StatelessWidget {
  const PillReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill Reminder',
      theme: AppTheme.light,
      home: const Placeholder(),
    );
  }
}
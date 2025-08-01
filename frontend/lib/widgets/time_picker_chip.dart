import 'package:flutter/material.dart';

class TimePickerChip extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onDeleted;

  const TimePickerChip({
    Key? key,
    required this.time,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDeleted,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

class GlassDateTimePicker extends StatefulWidget {
  final void Function(DateTime?) onDateTimeSelected;
  double height = 60;
  double blur = 10;
  double borderRadius = 16;

  GlassDateTimePicker({
    super.key,
    required this.onDateTimeSelected,
    this.height = 60,
    this.blur = 10,
    this.borderRadius = 16,
  });

  @override
  _GlassDateTimePickerState createState() => _GlassDateTimePickerState();
}

class _GlassDateTimePickerState extends State<GlassDateTimePicker> {
  DateTime? _selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(picked.year, picked.month, picked.day,
              pickedTime.hour, pickedTime.minute);
        });

        widget.onDateTimeSelected(
            _selectedDateTime); // Invoke the callback function
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat.yMd(Platform.localeName).add_Hm();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      height: widget.height,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      blur: widget.blur,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _selectedDateTime != null
                    ? _formatDateTime(_selectedDateTime!)
                    : "date-picker".i18n(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDateTime(context),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// RadioListTile padding is best use when taking full width
/// For Radio and label with smaller padding to put on a Row, use this
class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    this.label,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final T groupValue;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Row(
        children: <Widget>[
          Radio<T>(
            groupValue: groupValue,
            value: value,
            onChanged: onChanged,
          ),
          Text(label),
        ],
      ),
    );
  }
}

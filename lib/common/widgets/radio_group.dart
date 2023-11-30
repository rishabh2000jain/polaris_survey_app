import 'package:flutter/material.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';

class RadioButtonGroup extends StatefulWidget {
  const RadioButtonGroup(
      {required this.properties, required this.onChanged, Key? key})
      : super(key: key);
  final RadioGroupProperties properties;
  final void Function(String id) onChanged;

  @override
  State<RadioButtonGroup> createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.properties.label,
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context)
                  .colorScheme
                  .onBackground,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        ...widget.properties.options
            .map(
              (e) => RadioListTile<String>(
                selected: e.name == selectedOption,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  e.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                value: e.name,
                onChanged: (value) {
                  if(value==null)return;
                  selectedOption = value;
                  widget.onChanged.call(selectedOption!);
                  setState(() {

                  });
                },
                groupValue: () {
                  return selectedOption;
                }(),
              ),
            )
            .toList()
      ],
    );
  }
}

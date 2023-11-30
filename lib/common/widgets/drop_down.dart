import 'package:flutter/material.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({required this.properties,required this.onSelect, Key? key}) : super(key: key);
  final DropDownProperties properties;
  final void Function(String id) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          properties.label,
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
        DropdownButtonFormField<Option>(
          decoration: InputDecoration(
            hintText: properties.label,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))
            )
          ),
          onChanged: (selected) {
            if(selected==null)return;
            onSelect.call(selected.name);
          },
          items: [
            ...properties.options.map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onBackground
                    )
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

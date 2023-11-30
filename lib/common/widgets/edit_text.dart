import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polaris_survey_app/core/enums/input_type_enum.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField({
    required this.onChange,
    required this.properties,
    Key? key,
  }) : super(key: key);
  final void Function(String? value) onChange;
  final EditTextProperties properties;

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  late TextEditingController controller ;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.properties.label,
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          keyboardType: switch (widget.properties.inputType) {
            WidgetInputType.text => TextInputType.text,
            WidgetInputType.integer => TextInputType.number,
          },
          controller: controller,
          onChanged: widget.onChange,
          inputFormatters: widget.properties.inputType == WidgetInputType.integer
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            label: Text(
              widget.properties.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}

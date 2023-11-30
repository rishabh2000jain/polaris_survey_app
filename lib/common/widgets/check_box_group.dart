import 'package:flutter/material.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';

class CheckBoxGroup extends StatefulWidget {
  const CheckBoxGroup({required this.properties, required this.onUpdate,Key? key}) : super(key: key);
  final CheckBoxProperties properties;
  final void Function(List<String> selectedOptions) onUpdate;
  @override
  State<CheckBoxGroup> createState() => _CheckBoxGroupState();
}

class _CheckBoxGroupState extends State<CheckBoxGroup> {
  Map<String,bool> selectedOptions = {};

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
              (e) => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(e.name,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onBackground
                ),),
                value: selectedOptions[e.name]!=null,
                onChanged: (value) {
                  if(value==true){
                    selectedOptions[e.name] = true;
                  }else{
                    selectedOptions.removeWhere((key, value) => key==e.name);
                  }
                  widget.onUpdate.call(selectedOptions.keys.toList());
                  setState(() {

                  });
                },
              ),
            )
            .toList()
      ],
    );
  }
}

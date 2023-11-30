import 'dart:async';

import 'package:flutter/material.dart';

class SolidButtonWidget extends StatefulWidget {
  const SolidButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;
  final Future<void>Function()? onPressed;
  final String text;

  @override
  State<SolidButtonWidget> createState() => _SolidButtonWidgetState();
}

class _SolidButtonWidgetState extends State<SolidButtonWidget> {

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: MaterialButton(
        height: widget.height,
        minWidth: widget.width,
        color: Theme.of(context).colorScheme.primary,
        disabledColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        disabledTextColor: Theme.of(context).colorScheme.onSecondary,
        disabledElevation: 0,
        onPressed: ()async{
          setState(() {
            _loading = true;
          });
          try{
            await widget.onPressed?.call();
          }catch(e){
            rethrow;
          }finally{
            setState(() {
              _loading = false;
            });
          }

        },
        child: _loading
            ? Center(
              child: SizedBox(
                height: 23,
                width: 23,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
            : Text(
          widget.text,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }
}

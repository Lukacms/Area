import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

// This file contains the implementation of the ActionParameterField widget,
// which is a stateful widget that displays a single parameter field for an 
// AreaAction object. The ActionParameterField widget takes in an AreaAction object,
// a field name, and a callback function to update the field value. The widget displays the
// field name and a TextField widget to edit the field value. The ActionParameterField 
// widget is used to display a single parameter field for an action block in the mobile app.

class ActionParameterField extends StatefulWidget {
  final AreaAction action;
  final String fieldName;
  final Function onChanged;
  const ActionParameterField({
    super.key,
    required this.action,
    required this.fieldName,
    required this.onChanged,
  });

  @override
  State<ActionParameterField> createState() => _ActionParameterFieldState();
}

class _ActionParameterFieldState extends State<ActionParameterField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.fieldName == "Timer"
        ? textEditingController.text = widget.action.timer.toString()
        : textEditingController.text =
            widget.action.configuration[widget.fieldName] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.fieldName,
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        SizedBox(
          width: blockWidth,
          child: TextField(
            textAlign: TextAlign.right,
            controller: textEditingController,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.white.withOpacity(0.5),
                ),
              ),
            ),
            style: TextStyle(color: AppColors.white),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

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
    textEditingController.text =
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

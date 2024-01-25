import "package:flutter/material.dart";

class CheckBoxFormField extends FormField<void> {
  CheckBoxFormField({
    required final Widget widget,
    required final String? Function(void) validate,
  }) : super(
          enabled: true,
          validator: validate,
          builder: (final FormFieldState<void> state) => Column(
            children: <Widget>[
              widget,
              if (state.hasError)
                Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        );
}

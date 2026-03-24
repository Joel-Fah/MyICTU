import 'package:flutter/material.dart';
import '../../../../shared/widgets/bden_text_field.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return BdenTextField(
      label: label,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
    );
  }
}

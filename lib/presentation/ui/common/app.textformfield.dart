import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isObscured;
  final void Function(String)? onChanged;
  final String hintText;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;

  const AppPasswordField({
    super.key,
    required this.controller,
    required this.isObscured,
    this.onChanged,
    this.hintText = '******',
    this.validator,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          controller: controller,
          obscureText: isObscured.value,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: IconButton(
              onPressed: () {
                isObscured.value = !isObscured.value;
              },
              icon: Icon(
                isObscured.value ? LucideIcons.eye : LucideIcons.eyeOff,
              ),
            ),
          ),
        ));
  }
}

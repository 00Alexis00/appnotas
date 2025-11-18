import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sizer/sizer.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({super.key, required this.nombre, required this.hint, required this.label, this.obscure, this.validacion});

  final String nombre;
  final String hint;
  final String label;
  final bool? obscure;
  final String? Function (String?)? validacion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: nombre,
        validator: validacion,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          label: Text(label),
          labelStyle: TextStyle(color: Colors.lightBlue, fontSize: 18.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}

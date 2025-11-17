import 'package:appnotas/screen/custom/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login ({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 100.h,
            width: 100.w,
            child: Image.asset('assets/imagenes/fondo-4.jpg', fit: BoxFit.cover,),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      ImagenLogo(),
                      CustomFormTextField(
                        nombre: 'correo',
                      ),
                      CustomFormTextField(
                        nombre: 'password',
                      ),
                    ]
                  )
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}



class ImagenLogo extends StatelessWidget {
  const ImagenLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.blueAccent,
        // borderRadius: BorderRadius.circular(200),
      ),
      margin: EdgeInsets.only(top: 2.h, bottom: 5.h),
      padding: EdgeInsets.all(3.w),
      height: 30.w,
      width: 30.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.asset(
          'assets/imagenes/logo-nota.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
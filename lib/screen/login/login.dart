import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/services/auth_services.dart';
import 'package:appnotas/screen/custom/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login ({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormBuilderState>();
  var prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina ='login';
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
            child: Image.asset('assets/imagenes/fondo-2.jpeg', fit: BoxFit.cover,),
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
                        hint: 'example@example.com',
                        label: 'Correo', initialValue: '',
                      ),
                      CustomFormTextField(
                        nombre: 'password',
                        hint: 'Enter your password',
                        label: 'Password', initialValue: '',
                      ),
                      SizedBox(
                        child: ElevatedButton(onPressed: ()async{
                          // boton para iniciar sesion
                          SmartDialog.showLoading(
                            msg: 'Iniciando sesion...',
                            maskColor: Colors.lightBlue
                          );
                          _formKey.currentState?.save();
                          if(_formKey.currentState!.validate()==true){
                            final formulario = _formKey.currentState?.value;
                            var response = await AuthServices().singInEmailAndPassword(
                              formulario!['correo'],
                              formulario['password'],);
                            if(response == 3){
                              SmartDialog.dismiss();
                              if(context.mounted){
                                Navigator.pushReplacementNamed(context, 'dashboard');
                              }
                            } else{
                              SmartDialog.dismiss();
                              print('error');
                            }
                          }
                        },
                        child: Text('Iniciar Sesion'),),
                      ),
                      SizedBox(
                        height: 2.h
                      ),
                      Text('O tambien puedes', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            // boton para registrarse
                            Navigator.pushReplacementNamed(context, '/crear_cuenta');
                          },
                          child: Text('Registrarte'),
                        ),
                      ),
                    ],
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
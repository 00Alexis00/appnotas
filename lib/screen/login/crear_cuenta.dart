import 'package:appnotas/config/services/auth_services.dart';
import 'package:appnotas/screen/custom/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sizer/sizer.dart';

class CrearCuenta extends StatefulWidget {
  const CrearCuenta({super.key});

  @override
  State<CrearCuenta> createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        child: ElevatedButton(
          onPressed: () async {
          SmartDialog.showLoading(
            msg: 'Crear usuario...',
            maskColor: Colors.red
          );
          _formKey.currentState?.save();
          if(_formKey.currentState!.validate()==true){
            final formulario = _formKey.currentState?.value;
            var response = await AuthServices().createAcount(
              formulario!['correo'],
              formulario['password'],
              formulario['nombre'],
              formulario['apellido'],
              formulario['edad']
            );
            if(response == 3){
              SmartDialog.dismiss();
              if(context.mounted){
                Navigator.pushNamed(context, 'dashboard');
              }
            } else{
              SmartDialog.dismiss();
              print('error');
            }
          }
        },
        child: Text('Crear cuenta',))
      ),
      appBar: AppBar(
        title: Text('Crea tu cuenta',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              CustomFormTextField(
                nombre: 'nombre',
                hint: 'Ingresa tu nombre',
                label: 'Nombre',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              CustomFormTextField(
                nombre: 'apellido',
                hint: 'Ingresa tu apellido',
                label: 'Apellido',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              CustomFormTextField(
                nombre: 'edad',
                hint: 'Ingresa tu edad',
                label: 'Edad',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(errorText: 'Ingresa un número para la edad'),
                ]),
              ),
              CustomFormTextField(
                nombre: 'correo',
                hint: 'Ingresa tu correo',
                label: 'Correo',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(errorText: 'Correo no válido'),
                ]),
              ),
              CustomFormTextField(
                nombre: 'password',
                hint: 'Ingresa tu contraseña',
                obscure: true,
                label: 'Contraseña',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(4, errorText:'La contraseña debe tener al menos 4 caracteres'),
                ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
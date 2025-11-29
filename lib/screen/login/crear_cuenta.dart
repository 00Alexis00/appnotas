// appnotas/lib/screen/login/crear_cuenta.dart
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
  final _formKey2 = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        child: ElevatedButton(
          // Reemplaza el onPressed del botón 'Crear cuenta' por este bloque completo:
          onPressed: () async {
            SmartDialog.showLoading(
              msg: 'Crear usuario...',
              maskColor: Colors.greenAccent,
            );
            try {
              _formKey2.currentState?.save();
              if (_formKey2.currentState!.validate() == true) {
                final formulario = _formKey2.currentState?.value;
                var response = await AuthServices().createAcount(
                  formulario!['correo'],
                  formulario['password'],
                  formulario['nombre'],
                  formulario['apellido'],
                  formulario['edad'],
                );
                // response codes: 3 = success, 2 = email exists / db error, 1 = weak password, 0 = other error
                if (response == 3) {
                  if (context.mounted) {
                    SmartDialog.dismiss();
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  }
                } else {
                  SmartDialog.dismiss();
                  String msg = 'Error al crear usuario';
                  if (response == 1)
                    msg = 'Contraseña demasiado débil';
                  else if (response == 2)
                    msg =
                        'El correo ya está en uso o hubo un error en la base de datos';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              } else {
                // formulario no válido: asegurar que se cierre el loading
                try {
                  SmartDialog.dismiss();
                } catch (e) {
                  // ignorar
                }
              }
            } catch (e, st) {
              // asegurar que se remueva el loading aunque ocurra un error
              try {
                SmartDialog.dismiss();
              } catch (_) {}
              print('Error en crear cuenta UI: $e\n$st');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ocurrió un error inesperado')),
              );
            } finally {
              // Llamada adicional a dismiss protegida por try/catch para evitar usar getters inexistentes
              try {
                SmartDialog.dismiss();
              } catch (e) {
                // si no hay diálogo abierto o ocurre cualquier error, lo ignoramos
              }
            }
          },
          child: Text('Crear cuenta'),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Crea tu cuenta',
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // botón para regresar a login
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // volver a la ruta principal de login (usa la ruta registrada '/login')
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey2,
          child: Column(
            children: [
              CustomFormTextField(
                nombre: 'nombre',
                hint: 'Ingresa tu nombre',
                label: 'Nombre',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                initialValue: '',
              ),
              CustomFormTextField(
                nombre: 'apellido',
                hint: 'Ingresa tu apellido',
                label: 'Apellido',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                initialValue: '',
              ),
              CustomFormTextField(
                nombre: 'edad',
                hint: 'Ingresa tu edad',
                label: 'Edad',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(
                    errorText: 'Ingresa un número para la edad',
                  ),
                ]),
                initialValue: '',
              ),
              CustomFormTextField(
                nombre: 'correo',
                hint: 'Ingresa tu correo',
                label: 'Correo',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(errorText: 'Correo no válido'),
                ]),
                initialValue: '',
              ),
              CustomFormTextField(
                nombre: 'password',
                hint: 'Ingresa tu contraseña',
                obscure: true,
                label: 'Contraseña',
                validacion: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(
                    4,
                    errorText: 'La contraseña debe tener al menos 4 caracteres',
                  ),
                ]),
                initialValue: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

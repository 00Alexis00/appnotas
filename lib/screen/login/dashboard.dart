import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/services/database_services.dart';
import 'package:appnotas/screen/custom/custom_form_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sizer/sizer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final _auth = FirebaseAuth.instance;
  var prefs = PreferenciasUsuario();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina ='dashboard';
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'floating1',
            onPressed: (){},
            child: const Icon(Icons.sunny),
            ),
            SizedBox(
              height: 2.h,
              ),
          FloatingActionButton(
            heroTag: 'floating2',
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: FormBuilder(
                      key: _formKey,
                      child: CustomFormTextField(
                        nombre: 'nota',
                        label: 'Notas',
                        hint: 'Escribe tu nota',
                        validacion: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(4),
                        ]),
                      )
                    ),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text('Cancelar')),
                      TextButton(onPressed: (){
                        _formKey.currentState?.save();
                        if(_formKey.currentState?.validate()==true){
                          final formulario = _formKey.currentState!.value;
                          DatabaseServices().agregarNota(formulario['nota']);
                          Navigator.pop(context);
                          _formKey.currentState?.reset();
                        }
                      }, child: const Text('Guardar')),
                    ],
                  );
                }
              );
            },
            child: const Icon(Icons.add),
            ),
        ],
      ),
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: (){
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
              icon: const Icon(Icons.logout),
            )
        ],
      ),
    );
  }
}
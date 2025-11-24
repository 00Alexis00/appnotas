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
              mostrarDialogAgregar(context);
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
      body: SafeArea(
        child: Center(
          child: Container(
            height: 80.h,
            width: 70.w,
            child: StreamBuilder(
              stream: DatabaseServices().listarNotas(),
              builder: (context, AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }else{
                  var notas = snapshot.data.docs;
                  return ListView.builder(
                    itemCount: notas.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10.sp),
                        margin: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.teal
                          ),
                        height: 6.h,
                        color: Colors.teal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: Text(notas[index]['texto'])
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      DatabaseServices().borrarNota(notas[index].id);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
            ),
          ),
        ),
      );
  }

  Future<dynamic> mostrarDialogAgregar(BuildContext context) {
    return showDialog(
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
                      ]), initialValue: '',//talvez quitarlo
                    )
                  ),
                  actions: [
                    TextButton(onPressed: ()async{
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
  }

  Future<dynamic> mostrarDialogEditar(BuildContext context, String valorInicial, String uidNota) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: FormBuilder(
            key: _formKey,
            child: CustomFormTextField(
              initialValue: valorInicial,
              nombre: 'nota',
              label: 'Notas',
              hint: 'Escribe tu nota',
              validacion: FormBuilderValidators.compose([
                FormBuilderValidators.minLength(4),
              ]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: ()async {
                _formKey.currentState?.save();
                if (_formKey.currentState?.validate() == true) {
                  final formulario = _formKey.currentState!.value;
                  await DatabaseServices().editarNota(uidNota, formulario['nota']);
                  Navigator.pop(context);
                  _formKey.currentState?.reset();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
// appnotas/lib/screen/login/dashboard.dart
import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/services/database_services.dart';
import 'package:appnotas/screen/custom/custom_form_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  var prefs = PreferenciasUsuario();
  final _formKey = GlobalKey<FormBuilderState>();
  final _dbService = DatabaseServices();

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina = 'dashboard';

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'floating1',
            onPressed: () {},
            child: const Icon(Icons.sunny),
          ),
          SizedBox(height: 2.h),
          FloatingActionButton(
            heroTag: 'floating2',
            onPressed: () {
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
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        // Primero, escuchamos el estado de autenticación
        child: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              // todavía esperando el estado de auth
              return const Center(child: CircularProgressIndicator());
            }
            final user = authSnapshot.data;
            if (user == null) {
              // No hay usuario: redirigimos al login (o mostramos mensaje)
              // Usamos WidgetsBinding.addPostFrameCallback para no llamar Navigator dentro de build inmediatamente
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
              return const Center(child: Text('Redirigiendo a login...'));
            }

            // Si tenemos usuario, construimos el StreamBuilder de notas con su uid
            return Center(
              child: Container(
                height: 80.h,
                width: 70.w,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _dbService.listarNotasForUid(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // Muestra un mensaje de error si la consulta falla (por ejemplo reglas)
                      return Center(
                        child: Text('Error al cargar notas: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // snapshot has data (puede ser lista vacía)
                    final notas = snapshot.data?.docs ?? [];
                    if (notas.isEmpty) {
                      return Center(
                        child: Text(
                          'No tienes notas aún',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: notas.length,
                      itemBuilder: (context, index) {
                        final doc = notas[index];
                        final texto = doc['texto'] ?? '';
                        return Container(
                          padding: EdgeInsets.all(10.sp),
                          margin: EdgeInsets.only(bottom: 2.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.teal,
                          ),
                          height: 6.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 40.w, child: Text(texto)),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // abrir diálogo editar con valor actual
                                      mostrarDialogEditar(
                                        context,
                                        texto,
                                        doc.id,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _dbService.borrarNota(doc.id);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ... mantener mostrarDialogAgregar y mostrarDialogEditar sin cambios ...
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
              ]),
              initialValue: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                _formKey.currentState?.save();
                if (_formKey.currentState?.validate() == true) {
                  final formulario = _formKey.currentState!.value;
                  try {
                    await DatabaseServices().agregarNota(formulario['nota']);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al guardar nota: $e')),
                    );
                  }
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

  Future<dynamic> mostrarDialogEditar(
    BuildContext context,
    String valorInicial,
    String uidNota,
  ) {
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
              onPressed: () async {
                _formKey.currentState?.save();
                if (_formKey.currentState?.validate() == true) {
                  final formulario = _formKey.currentState!.value;
                  await DatabaseServices().editarNota(
                    uidNota,
                    formulario['nota'],
                  );
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

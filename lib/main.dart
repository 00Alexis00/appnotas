import 'package:appnotas/config/routes/routes.dart';
import 'package:appnotas/firebase_options.dart';
// import 'package:appnotas/screen/login/login.dart';
// import 'package:appnotas/screen/screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:appnotas/config/preferencias/preferencias.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuario.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (p0,p1,p2) {
        return MaterialApp(
          title: 'Material App',
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          initialRoute: PreferenciasUsuario().ultimaPagina,
          routes: routes,
        );
      },
    );
  }
}
// appnotas/lib/config/services/auth_services.dart
import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var prefs = PreferenciasUsuario();

  // Mantengo el nombre createAcount para no romper llamadas existentes
  Future<int> createAcount(
    String correo,
    String password,
    String nombre,
    String apellido,
    String edad,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: correo.trim(),
        password: password,
      );

      if (userCredential.user?.uid != null) {
        final uid = userCredential.user!.uid;

        // guardar uid en preferencias local
        prefs.uid = uid;

        // parseo edad con control (si falla se considera 0)
        int e = 0;
        try {
          e = int.parse(edad);
        } catch (_) {
          e = 0;
        }

        // Llamo a DatabaseServices y le paso el uid para que el documento quede asociado
        bool response = await DatabaseServices().addUsuario(
          uid,
          nombre,
          apellido,
          e,
          correo,
        );
        if (!response) {
          // error al escribir en Firestore
          return 2;
        }

        // Opcional: enviar verificación
        try {
          final user = userCredential.user;
          if (user != null && !user.emailVerified) {
            await user.sendEmailVerification();
          }
        } catch (e) {
          // no crítico, sólo logueamos (no interrumpimos el registro)
          print('No se pudo enviar email verification: $e');
        }

        return 3; // éxito
      } else {
        return 0; // sin user inesperado
      }
    } on FirebaseAuthException catch (e) {
      // códigos correctos de Firebase: 'weak-password' y 'email-already-in-use'
      if (e.code == 'weak-password') {
        return 1;
      } else if (e.code == 'email-already-in-use') {
        return 2;
      } else {
        print(
          'FirebaseAuthException en createAcount: ${e.code} - ${e.message}',
        );
        return 0;
      }
    } catch (e, st) {
      print('Error inesperado en createAcount: $e\n$st');
      return 0;
    }
  }

  Future<int> singInEmailAndPassword(String correo, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: correo.trim(),
        password: password,
      );

      if (userCredential.user?.uid != null) {
        prefs.uid = userCredential.user!.uid;
        return 3;
      } else {
        return 0;
      }
    } on FirebaseAuthException catch (e) {
      print('Auth signIn error: ${e.code} ${e.message}');
      return 1;
    } catch (e) {
      print('Sign in error: $e');
      return 1;
    }
  }
}

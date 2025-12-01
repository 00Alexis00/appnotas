import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? '/login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  String get uid {
    return _prefs.getString('uid') ?? '';
  }

  set uid(String value) {
    _prefs.setString('uid', value);
  }

  bool get theme{
    return _prefs.getBool('theme') ?? true;
  }

  set theme(bool value){
    _prefs.setBool('theme', value);
  }
}
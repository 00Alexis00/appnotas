import 'package:appnotas/config/preferencias/preferencias.dart';
import 'package:appnotas/config/theme/theme.dart';
import 'package:flutter/material.dart';

  var prefs = PreferenciasUsuario();
class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = prefs.theme ? modoLight : modoDark;
  ThemeData get themeData => _themeData;

  set themeData (ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void switchTheme(){
    if(_themeData == modoLight){
      themeData = modoDark;
      prefs.theme = false;
    }else{
      themeData = modoLight;
      prefs.theme = true;
    }
  }
}
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  //todo: Data
  String appLanguage = 'en';

  void ChangeLanguage (String NewLanguage) {
    if (appLanguage == NewLanguage){
      return ;
    }
    appLanguage = NewLanguage ;
    notifyListeners();
  }
}
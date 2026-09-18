import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //todo: Data
  ThemeMode themeProvider = ThemeMode.light ;

  void ChangeTheme (ThemeMode NewTheme) {
    if (themeProvider == NewTheme){
      return ;
    }
    themeProvider = NewTheme ;
    notifyListeners();
  }

  bool isDarkMode (){
    return themeProvider == ThemeMode.dark ;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
    Locale _appLocale = Locale('es');

    Locale get appLocal => _appLocale ?? Locale('es');
    fetchLocale() async {
        var prefs = await SharedPreferences.getInstance();
        if (prefs.getString('language_code') == null) {
            _appLocale = Locale('es');
            return Null;
        }
        _appLocale = Locale(prefs.getString('language_code'));
        return Null;
    }


    void changeLanguage(Locale type) async {
        var prefs = await SharedPreferences.getInstance();

        if (_appLocale == type) {
            return;
        }
        if (type == Locale("ca")) {
            _appLocale = Locale("ca");
            await prefs.setString('language_code', 'ca');
            await prefs.setString('countryCode', 'CA');
        }
        else if (type == Locale("es")) {
            _appLocale = Locale("es");
            await prefs.setString('language_code', 'es');
            await prefs.setString('countryCode', 'ES');
        }
        else {
            _appLocale = Locale("en");
            await prefs.setString('language_code', 'en');
            await prefs.setString('countryCode', 'EN');
        }
        notifyListeners();
    }
}
import 'package:flutter/foundation.dart';

class Settings with ChangeNotifier {
  double _fontSize;

  Settings(this._fontSize);

  double get fontSize {
    return _fontSize;
  }

  set fontSize(fontSize) {
    _fontSize = fontSize;
    notifyListeners();
  }
}

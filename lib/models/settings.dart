import 'package:flutter/foundation.dart';

class Settings with ChangeNotifier {
  double _fontSize = 12.0;

  double get fontSize {
    return _fontSize;
  }

  set fontSize(fontSize) {
    _fontSize = fontSize;
    notifyListeners();
  }
}

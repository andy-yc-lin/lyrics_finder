import 'package:flutter/foundation.dart';

class Song with ChangeNotifier {
  String _name;
  List<String> _artists;
  bool _currentlyPlaying;

  String get name => _name;
  List<String> get artists => _artists;
  bool get currentlyPlaying => _currentlyPlaying;

  var updated = false;

  set name(String name) {
    if (_name != name) {
      _name = name;
      notifyListeners();
    }
  }

  set artists(List<String> artists) {
    if (_artists != artists) {
      _artists = artists;
      notifyListeners();
    }
  }

  set currentlyPlaying(bool currentlyPlaying) {
    if (_currentlyPlaying != currentlyPlaying) {
      _currentlyPlaying = currentlyPlaying;
      notifyListeners();
    }
  }

  songFromJson(Map<String, dynamic> json) {
    if (json == null) {
      _currentlyPlaying = false;
      notifyListeners();
      return;
    }

    final item = json['item'];
    _name = item['name'];
    final artists = item['artists'].map((artist) => artist['name']);
    _artists = new List<String>.from(artists);
    _currentlyPlaying = json['is_playing'];
    notifyListeners();
  }
}

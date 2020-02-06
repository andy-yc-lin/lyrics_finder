import 'package:flutter/foundation.dart';

class Song with ChangeNotifier {
  String _name;
  List<String> _artists;
  bool _currentlyPlaying;
  int _duration;

  String get name => _name;
  List<String> get artists => _artists;
  bool get currentlyPlaying => _currentlyPlaying;
  int get duration => _duration;

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
      print('songFromJson $json');
      _currentlyPlaying = false;
      return notifyListeners();
    }

    final item = json['item'];
    _name = item['name'];
    _duration = item['duration_ms'] - json['progress_ms'];
    print(_duration);
    final artists = item['artists'].map((artist) => artist['name']);
    _artists = new List<String>.from(artists);
    _currentlyPlaying = json['is_playing'];
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import './components/choose_mode.dart';
import './models/song.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromPath("assets/keys.json");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Lyrics Finder';

    return ChangeNotifierProvider(
      builder: (context) => Song(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            backgroundColor: Colors.deepPurple,
          ),
          body: ChooseMode(),
        ),
      ),
    );
  }
}

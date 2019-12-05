import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './components/choose_mode.dart';
import './components/side_menu.dart';
import './models/settings.dart';
import './models/song.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromPath("assets/keys.json");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double fontSize = prefs.getDouble("fontSize") ?? 12.0;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => Song()),
        ChangeNotifierProvider(builder: (context) => Settings(fontSize)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Lyrics Finder';
    final settings = Provider.of<Settings>(context);

    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontSize: settings.fontSize),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          backgroundColor: Colors.deepPurple,
        ),
        body: ChooseMode(),
        drawer: SideMenu(),
      ),
    );
  }
}

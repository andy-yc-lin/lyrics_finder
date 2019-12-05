import 'package:flutter/material.dart';
import 'package:lyrics_finder/models/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.grey.withOpacity(0.5),
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white.withOpacity(0.7),
              child: ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                enabled: false,
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.7),
              child: ListTile(
                title: Text(
                  'Font Size',
                  textAlign: TextAlign.center,
                  softWrap: false,
                ),
                leading: IconButton(
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    settings.fontSize -= 3.0;
                    prefs.setDouble("fontSize", settings.fontSize);
                  },
                  icon: Icon(Icons.remove),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    settings.fontSize += 3.0;
                    prefs.setDouble("fontSize", settings.fontSize);
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

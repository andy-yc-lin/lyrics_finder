import 'package:flutter/material.dart';
import 'package:lyrics_finder/models/settings.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        // Set the transparency here
        canvasColor: Colors.grey.withOpacity(
            0.5), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
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
                  onPressed: () {
                    settings.fontSize -= 3;
                  },
                  icon: Icon(Icons.remove),
                ),
                trailing: IconButton(
                  onPressed: () {
                    settings.fontSize += 3;
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

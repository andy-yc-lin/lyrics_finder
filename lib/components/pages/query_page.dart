import 'package:flutter/material.dart';

import 'package:lyrics_finder/components/query_form.dart';
import 'package:lyrics_finder/components/side_menu.dart';
import 'package:lyrics_finder/components/lyrics.dart';

class QueryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                QueryForm(),
                Lyrics(),
              ],
            ),
          ),
        ),
      ),
      endDrawer: SideMenu(),
    );
  }
}

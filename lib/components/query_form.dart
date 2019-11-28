import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';

class QueryForm extends StatefulWidget {
  @override
  QueryFormState createState() => QueryFormState();
}

class QueryFormState extends State<QueryForm> {
  final _songController = TextEditingController();
  final _artistController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _artistController.dispose();
    _songController.dispose();
    super.dispose();
  }

  validateIsEmpty(value) {
    return value.isEmpty ? 'Required *' : null;
  }

  @override
  Widget build(BuildContext context) {
    Song song = Provider.of<Song>(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter artist name'),
              controller: _artistController,
              validator: (value) => validateIsEmpty(value),
            ),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter song title'),
              controller: _songController,
              validator: (value) => validateIsEmpty(value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (this._formKey.currentState.validate()) {
                    song.artists = [_artistController.text];
                    song.name = _songController.text;
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

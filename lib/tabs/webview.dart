import 'package:flutter/material.dart';

class WebViewTy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            new Icon(
              Icons.airport_shuttle,
              size: 160.0,
              color: Colors.blue,
            ),
            new Text('webview tab')
          ],
        ),
      ),
    );
  }
}
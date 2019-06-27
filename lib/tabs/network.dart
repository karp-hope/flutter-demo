import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Network extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Column(
          // center the children
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.favorite,
              size: 160.0,
              color: Colors.red,
            ),
            new Text('First Tab'),
            RaisedButton(
              onPressed: () {
                print("clicked");
                loadData();
              },
              child: Text("button click"),
            ),
          ],
        ),
      ),
    );
  }

  loadData() async{
    String dataURL = "http://www.qq.com";

    http.Response response = await http.get(dataURL);
    
    print('result' + response.body);

  }
}

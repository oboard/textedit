import 'package:flutter/material.dart';
import 'package:textedit/main.dart';

TextEditingController _cc = new TextEditingController(),
    _rc = new TextEditingController();
bool _dotSelected = false;
class NumPage extends StatelessWidget {
  const NumPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Center(
          child: new Wrap(
            children: <Widget>[
              Checkbox(
                value: _dotSelected,
                activeColor: Colors.blue, //选中时的颜色
                onChanged: (value) {
                  _dotSelected = value;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

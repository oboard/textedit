import 'package:flutter/material.dart';
import 'package:textedit/main.dart';

TextEditingController _cc = new TextEditingController(),
    _rc = new TextEditingController();
FocusNode fn1 = new FocusNode(),
    fn2 = new FocusNode();

class ReplacePage extends StatelessWidget {
  const ReplacePage({Key key, this.title}) : super(key: key);
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
              child: new Column(children: <Widget>[
                new TextField(
                  decoration: InputDecoration(labelText: '从'),
                  controller: _cc, focusNode: fn1,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    fn1.unfocus();
                    FocusScope.of(context).requestFocus(fn2);
                  },
                ),
                new TextField(
                    decoration: InputDecoration(labelText: '替换'),
                    controller: _rc, focusNode: fn2
                ),
                new FlatButton(
                    color: Colors.blue,
                    child: new Text(
                      '替换',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context,
                          getcontent().text.replaceAll(_cc.text, _rc.text));
                    }),
              ]))),
    );
  }
}

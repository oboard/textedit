import 'package:flutter/material.dart';
import 'package:textedit/main.dart';

TextEditingController _cc = new TextEditingController(),
    _rc = new TextEditingController();
FocusNode fn1 = new FocusNode(), fn2 = new FocusNode();

class ReplacePage extends StatefulWidget {
  const ReplacePage({Key key}) : super(key: key);

  @override
  ReplacePageState createState() => ReplacePageState();
}

class ReplacePageState extends State<ReplacePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('替换'),
      ),
      body: new Center(
        child: new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    decoration: InputDecoration(labelText: '从'),
                    controller: _cc,
                    focusNode: fn1,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      fn1.unfocus();
                      FocusScope.of(context).requestFocus(fn2);
                    },
                  ),
                  new TextField(
                      decoration: InputDecoration(labelText: '替换'),
                      controller: _rc,
                      focusNode: fn2),
                  new PopupMenuButton<int>(
                    child: new FlatButton.icon(
                      icon: new Icon(Icons.add),
                      onPressed: null,
                      label: new Text('特殊格式'),
                    ),
                    onSelected: (int result) {},
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text('Working a lot harder'),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text('Being a lot smarter'),
                      ),
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text('Being a self-starter'),
                      ),
                      const PopupMenuItem<int>(
                        value: 3,
                        child: Text('Placed in charge of trading charter'),
                      ),
                    ],
                  ),
                  new FlatButton(
                      color: Colors.blue,
                      child: new Text(
                        '替换',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context,
                            content.text.replaceAll(_cc.text, _rc.text));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

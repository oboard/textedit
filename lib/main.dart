import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '文本编辑',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '文本编辑'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

TextEditingController _content = new TextEditingController();

class _HomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double _screenWidth() {
      return MediaQuery.of(context).size.width;
    }

    double _screenHeight() {
      return MediaQuery.of(context).size.height;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: new Column(children: <Widget>[
        Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              new FlatButton(
                  onPressed: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FindPage(
                                  title: '查找',
                                )));
                    _content.selection = TextSelection(
                        baseOffset: int.parse('$result'),
                        extentOffset:
                            int.parse('$result') + _searchcontent.text.length);
                    print('$result');
                  },
                  child: new Icon(Icons.find_in_page)),
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReplacePage(
                                  title: '替换',
                                )));
                  },
                  child: new Icon(Icons.find_replace)),
              new FlatButton(
                  onPressed: () {
                    print('点钮事件');
                  },
                  child: new Icon(Icons.format_list_numbered)),
              new FlatButton(
                  onPressed: () {
                    print('点钮事件');
                  },
                  child: new Icon(Icons.expand_more)),
            ]),
        new Expanded(
            child: ListView(children: <Widget>[
          new ConstrainedBox(
              constraints: BoxConstraints(minHeight: _screenHeight() / 2),
              child: new Container(
                  decoration: new BoxDecoration(
                    //border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                    color: Color(0xFFFFFFFF), // 底色  //
                    //shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                    shape: BoxShape.rectangle, // 默认值也是矩形
                    //borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    style: new TextStyle(
                        fontSize: 25, color: Color.fromARGB(255, 0, 0, 0)),
                    controller: _content,
                  )))
        ]))
      ]),
      floatingActionButton: FloatingActionButton(
        tooltip: '新建',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

TextEditingController _searchcontent = new TextEditingController();
List<String> itemsL = new List<String>(), itemsR = new List<String>();
List<int> itemsN = new List<int>();
class FindPage extends StatelessWidget {
  const FindPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  Widget build(BuildContext context) {
    searchfor(String s, String c, int i) {
      int start = c.indexOf(s, i);
      int end = start + s.length;
      if (start < 10) {
        itemsL.add(c.substring(0, start));
      } else {
        itemsL.add(c.substring(start - 10, start));
      }
      if (c.length - end < 10) {
        itemsR.add(c.substring(end, c.length));
      } else {
        itemsR.add(c.substring(end, end + 10));
      }
      itemsN.add(start);
      if (c.length - i >= s.length) searchfor(s, c, end + 1);
    }

    _search() {
      FocusScope.of(context).requestFocus(FocusNode());
      itemsL.clear();
      itemsR.clear();
      print(_searchcontent.text);

      String s = _searchcontent.text, c = _content.text;
      searchfor(s, c, 0);
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        body: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                    //border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                    color: Colors.black12, // 底色  //
                    //shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                    shape: BoxShape.rectangle, // 默认值也是矩形
                    borderRadius: new BorderRadius.circular((90.0)), // 圆角度
                  ),
                  child: new Padding(
                      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                              child: new TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: _searchcontent,
                            textInputAction: TextInputAction.search,
                            onEditingComplete: _search,
                          )),
                          new IconButton(
                              icon: Icon(Icons.search), onPressed: _search)
                        ],
                      ))),
              new Flexible(
                  child: new ListView.builder(
                itemCount: itemsL.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                      onTap: () {
                        Navigator.pop(context, itemsN[index]);
                      },
                      title: new RichText(
                          text: TextSpan(
                              style: new TextStyle(color: Colors.black),
                              children: <TextSpan>[
                            new TextSpan(text: itemsL[index]),
                            new TextSpan(
                                text: _searchcontent.text,
                                style: new TextStyle(
                                    background: new Paint()
                                      ..color =
                                          Color.fromARGB(100, 255, 255, 0))),
                            new TextSpan(text: itemsR[index])
                          ])));
                },
              )),
            ],
          ),
        ));
  }
}

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
      body: new Center(
        child: new FlatButton(
            color: Colors.blue,
            child: new Text('返回第一个页面'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}

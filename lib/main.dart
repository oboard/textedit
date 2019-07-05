import 'package:flutter/material.dart';
import 'package:textedit/ReplacePage.dart';
import 'package:textedit/tool.dart';
import 'package:textedit/draggable_scrollbar.dart';
import 'package:flutter/services.dart';
import 'package:textedit/NumPage.dart';
import 'dart:ui';

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
TextSelection _textSelection;

TextEditingController getcontent() {
  return _content;
}

ScrollController textScrollontroller = new ScrollController();
String _count =
    '${fnGetCpmisWords(_content.text)} 个字 ${_content.text.length} 个字符 ${_content.text.split('\n').length}段'; // ${fnGetNumWords(_content.text)}个数字';;

final key = new GlobalKey<ScaffoldState>();

class _HomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //double _screenWidth() {
    //  return MediaQuery.of(context).size.width;
    //}

    double _screenHeight() {
      return MediaQuery.of(context).size.height;
    }

    freshState() {
      setState(
        () {
          _count =
              '${fnGetCpmisWords(_content.text)} 个字 ${_content.text.length} 个字符 ${_content.text.split('\n').length}段'; // ${fnGetNumWords(_content.text)}个数字';;
        },
      );
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 2.0,
        title:
            new ListView(scrollDirection: Axis.horizontal, children: <Widget>[
          new Row(
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () async {
                  _textSelection = _content.selection;
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FindPage(
                                title: '查找',
                              )));
                  if (result != null) {
                    //_content.selection = TextSelection.fromPosition(TextPosition(offset:int.parse('$result')));
                    _content.selection = TextSelection(
                        baseOffset: int.parse('$result'),
                        extentOffset:
                            int.parse('$result') + _searchcontent.text.length);
                  } else {
                    _content.selection = _textSelection;
                  }
                },
              ),
              new IconButton(
                icon: new Icon(Icons.find_replace),
                onPressed: () async {
                  _textSelection = _content.selection;
                  _content.text = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReplacePage(
                            title: '替换',
                          ),
                    ),
                  );
                  _content.selection = _textSelection;
                  freshState();
                },
              ),
              new IconButton(
                icon: new Icon(Icons.content_copy),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: _content.text));
                  key.currentState
                      .showSnackBar(new SnackBar(content: new Text('已复制到剪辑版')));
                },
              ),
              new IconButton(
                icon: new Icon(Icons.format_list_numbered),
                onPressed: () async {
                  _textSelection = _content.selection;
                  _content.text = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NumPage(
                            title: '添加序号',
                          ),
                    ),
                  );
                  _content.selection = _textSelection;
                  freshState();
                },
              ),
            ],
          )
        ]),
      ), //Text(widget.title)),
      body: new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Expanded(
                child: DraggableScrollbar.arrows(
                  backgroundColor: Colors.blue,
                  controller: textScrollontroller,
                  child: new ListView(
                    controller: textScrollontroller,
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: _screenHeight() / 2),
                        child: new Container(
                          decoration: new BoxDecoration(
                            //border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                            color: Color(0xFFFFFFFF),

                            // 底色  //
                            //shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                            shape: BoxShape.rectangle, // 默认值也是矩形
                            //borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                          ),
                          child: new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              //autofocus: true,
                              style: new TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              controller: _content,
                              onChanged: (s) {
                                freshState();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          new Align(
            alignment: Alignment.topRight,
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Card(
                elevation: 2.0,
                color: Colors.blue,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(90.0), // 圆角度
                ),
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: new Text(
                    _count,
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  title: new Text("提示"),
                  content: new Text("要清空所有内容吗？"),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _content.text = '';
                      },
                      child: new Text("确认"),
                    ),
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("取消"),
                    ),
                  ],
                );
              });
        },
        tooltip: '新建',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

ScrollController searchScrollontroller = new ScrollController();
TextEditingController _searchcontent = new TextEditingController();
List<String> itemsL = new List<String>(), itemsR = new List<String>();
List<int> itemsN = new List<int>();
String titlea = '';

class FindPage extends StatelessWidget {
  const FindPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  Widget build(BuildContext context) {
    searchfor(String s, String c, int i) async {
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
      itemsN.clear();
      itemsL.clear();
      itemsR.clear();
      print(_searchcontent.text);

      String s = _searchcontent.text, c = _content.text;
      searchfor(s, c, 0);
      titlea = '${itemsN.length}条结果';
    }

    return new Scaffold(
      appBar: new AppBar(
          elevation: 2.0,
          title: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                style: new TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _searchcontent,
                textInputAction: TextInputAction.search,
                onEditingComplete: _search,
              )),
              new IconButton(
                icon: Icon(Icons.search),
                onPressed: _search,
                color: Colors.white,
              )
            ],
          ) //new Text(title + titlea),
          ),
      body: new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Flexible(
                child: DraggableScrollbar.arrows(
                  backgroundColor: Colors.blue,
                  controller: searchScrollontroller,
                  child: new ListView.builder(
                    itemCount: itemsL.length,
                    controller: searchScrollontroller,
                    itemBuilder: (context, index) {
                      return new ListTile(
                        onTap: () {
                          Navigator.pop(context, itemsN[index]);
                        },
                        title: new RichText(
                          text: TextSpan(
                            style: new TextStyle(
                                color: Colors.black, fontSize: 20),
                            children: <TextSpan>[
                              new TextSpan(text: itemsL[index]),
                              new TextSpan(
                                  text: _searchcontent.text,
                                  style: new TextStyle(
                                      background: new Paint()
                                        ..color =
                                            Color.fromARGB(100, 255, 255, 0))),
                              new TextSpan(text: itemsR[index])
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          new Align(
            alignment: Alignment.topRight,
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Card(
                color: Colors.blue,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(90.0), // 圆角度
                ),
                child: new Padding(
                  padding: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: new Text(
                    titlea,
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shortcut_keys/shortcut_keys.dart';
import 'package:textedit/FindPage.dart';
import 'package:textedit/NumPage.dart';
import 'package:textedit/ReplacePage.dart';
import 'package:textedit/main.dart';
import 'package:textedit/tool.dart';
import 'dart:ui';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);

  @override
  EditPageState createState() => new EditPageState();
}

class EditPageState extends State<EditPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double slider = 0, rotateAngle = 1;
  TextEditingController content = new TextEditingController();
  TextSelection textSelection;
  FocusNode textFocusNode = FocusNode();
  double textSize = 20;
  TextStyle textStyle = new TextStyle(fontSize: 20);
  ScrollController textScrollController = new ScrollController();
  String _count = '0 个字 0 个字符 0 段'; // ${fnGetNumWords(content.text)}个数字';;

  final key = new GlobalKey<ScaffoldState>();
  int index = 0;

  freshState() {
    setState(
      () {
        _count =
            '${fnGetCpmisWords(content.text)} 个字 ${content.text.length} 个字符 ${content.text.split('\n').length} 段'; // ${fnGetNumWords(content.text)}个数字';;
        textStyle = new TextStyle(fontSize: textSize);
        turnFocus();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    epsList.add(this);
    index = epsList.length - 1;

    super.initState();
  }

  @override
  void dispose() {
    epsList.removeAt(index);
    super.dispose();
  }

  void turnFocus() {
    Content = content;
  }

  void toFind() async {
    turnFocus();
    textSelection = content.selection;
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FindPage()),
    );
    if (result != null) {
      //content.selection = TextSelection.fromPosition(TextPosition(offset:int.parse('$result')));
      content.selection = TextSelection(
          baseOffset: int.parse('$result'),
          extentOffset: int.parse('$result') + searchContent.text.length);
    } else {
      content.selection = textSelection;
    }
  }

  @override
  Widget build(BuildContext context) {
    //double _screenWidth() {
    //  return MediaQuery.of(context).size.width;
    //}t
//
//    double _screenHeight() {
//      return MediaQuery.of(context).size.height;
//    }
    super.build(context);
    return new GestureDetector(
      onTap: () {
        turnFocus();
      },
      child: Scaffold(
        key: key,
        appBar: new AppBar(
          elevation: 2.0,
          title: new Stack(
            children: <Widget>[
              new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new IconButton(
                          tooltip: '查找',
                          icon: new Icon(Icons.search),
                          onPressed: () => toFind()),
                      new IconButton(
                        tooltip: '替换',
                        icon: new Icon(Icons.find_replace),
                        onPressed: () async {
                          turnFocus();
                          textSelection = content.selection;
                          content.text = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReplacePage(),
                            ),
                          );
                          content.selection = textSelection;
                          freshState();
                        },
                      ),
                      new IconButton(
                        tooltip: '添加序号',
                        icon: new Icon(Icons.format_list_numbered),
                        onPressed: () async {
                          turnFocus();
                          textSelection = content.selection;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NumPage(),
                            ),
                          );
                          content.selection = textSelection;
                          freshState();
                        },
                      ),
                      new IconButton(
                        tooltip: '字体变大',
                        icon: new Stack(
                          children: <Widget>[
                            new Icon(Icons.title),
                            new Icon(
                              Icons.trending_up,
                              color: Colors.white70,
                            )
                          ],
                        ),
                        onPressed: () async {
                          textSize++;
                          freshState();
                        },
                      ),
                      new IconButton(
                        tooltip: '字体变小',
                        icon: new Stack(
                          children: <Widget>[
                            new Icon(Icons.title),
                            new Icon(
                              Icons.trending_down,
                              color: Theme.of(context).backgroundColor,
                            )
                          ],
                        ),
                        onPressed: () async {
                          textSize--;
                          freshState();
                        },
                      ),
                      new IconButton(
                        tooltip: '旋转',
                        icon: new Icon(Icons.rotate_left),
                        onPressed: () {
                          rotateAngle = -rotateAngle;
                          freshState();
                        },
                      ),
                      new IconButton(
                        tooltip: '粘贴',
                        icon: new Icon(Icons.content_paste),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return new AlertDialog(
                                title: new Text("提示"),
                                content: new Text("确认从剪辑版粘贴吗？"),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: new Text("取消"),
                                  ),
                                  new FlatButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      var clipboardData =
                                          await Clipboard.getData(
                                              Clipboard.kTextPlain);
                                      if (clipboardData != null)
                                        content.text = clipboardData.text;
                                    },
                                    child: new Text("确认"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      new IconButton(
                        tooltip: '复制',
                        icon: new Icon(Icons.content_copy),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return new AlertDialog(
                                title: new Text("提示"),
                                content: new Text("确认复制到剪辑版吗？"),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: new Text("取消"),
                                  ),
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Clipboard.setData(new ClipboardData(
                                          text: content.text));
                                      key.currentState.showSnackBar(
                                          new SnackBar(
                                              content: new Text('已复制到剪辑版')));
                                    },
                                    child: new Text("确认"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      new IconButton(
                        tooltip: '删除',
                        icon: new Icon(Icons.delete_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return new AlertDialog(
                                title: new Text("提示"),
                                content: new Text("确认删除所有内容吗？"),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: new Text("取消"),
                                  ),
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      content.text = '';
                                    },
                                    child: new Text("确认"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        body: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Expanded(
                  child: new CupertinoScrollbar(
                    child: new ListView(
                      controller: textScrollController,
                      children: <Widget>[
                        new Transform(
                          transform: Matrix4.identity()
                            ..scale(rotateAngle, rotateAngle, 1.0),
                          alignment: Alignment.center,
                          // 旋转的中心点
                          child: new Container(
                            decoration: new BoxDecoration(
                              //border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                              color: Theme.of(context).cardColor,
                              //shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                              shape: BoxShape.rectangle, // 默认值也是矩形
                              //borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                            ),
                            child: new Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 30.0, 10.0, 30.0),
                              child: ShortcutKeysListener(
                                needFocus: false,
                                focusNode: textFocusNode,
                                onKey: (event) {
                                  RawKeyEventDataLinux rawKeyEventDataLinux = event.data;
                                  print(rawKeyEventDataLinux.keyCode);
                                },
                                shortcutData: [
                                  // 无鼠标
                                  ShortcutData(
                                      shortcuts: [
                                        ShortcutKeys.CTRL_LEFT,
                                        ShortcutKeys.F,
                                      ],
                                      trigger: () {
                                        print('find');
                                        toFind();
                                      }),
                                ],
                                child: new TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  focusNode: textFocusNode,
                                  autofocus: true,
                                  style: textStyle,
                                  controller: content,
                                  onChanged: (s) {
                                    freshState();
                                  },
                                ),
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
                child: new Opacity(
                  opacity: 0.9,
                  child: new Card(
                    elevation: 2.0,
                    color: Theme.of(context).primaryColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(90.0), // 圆角度
                    ),
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: new Text(
                        _count,
                        style:
                            new TextStyle(color: Theme.of(context).cardColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  TextEditingController content;
  TextSelection textSelection;
  FocusNode textFocusNode = FocusNode();
  double textSize = 20;
  TextStyle textStyle =
      new TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0));
  ScrollController textScrollController = new ScrollController();
  String _count = '0 个字 0 个字符 0 段'; // ${fnGetNumWords(content.text)}个数字';;

  final key = new GlobalKey<ScaffoldState>();
  int index = 0;

  freshState() {
    setState(
      () {
        _count =
            '${fnGetCpmisWords(content.text)} 个字 ${content.text.length} 个字符 ${content.text.split('\n').length} 段'; // ${fnGetNumWords(content.text)}个数字';;
        textStyle = new TextStyle(
            fontSize: textSize, color: Color.fromARGB(255, 0, 0, 0));
        print(index);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    epsList.add(this);
    index = epsList.length - 1;
    this.content = contents.last;

    super.initState();
  }

  @override
  void dispose() {
    epsList.removeAt(index);
    contents.removeAt(index);
    super.dispose();
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
    return Scaffold(
      key: key,
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
                          ..scale(rotateAngle, rotateAngle, 1.0), // 旋转的角度
                        alignment: Alignment.center, // 旋转的中心点
                        child: new Container(
                          decoration: new BoxDecoration(
                            //border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                            color: Color(0xFFFFFFFF),
                            //shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
                            shape: BoxShape.rectangle, // 默认值也是矩形
                            //borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                          ),
                          child: new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 30.0, 10.0, 30.0),
                            child: new TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              focusNode: textFocusNode,
                              autofocus: true,
                              style: textStyle,
                              controller: content,
                              onTap: () {
                                setFocus(index);
                              },
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
              child: new Opacity(
                opacity: 0.9,
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
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:flutter/material.dart';
import 'main.dart';
import 'draggable_scrollbar.dart';

ScrollController searchScrollController = new ScrollController();
TextEditingController searchContent = new TextEditingController();
List<String> itemsL = new List<String>(), itemsR = new List<String>();
List<int> itemsN = new List<int>();
String titleCount = '0';

class FindPage extends StatefulWidget {
  const FindPage({Key key}) : super(key: key);

  @override
  FindPageState createState() => FindPageState();
}

class FindPageState extends State<FindPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    searchfor(String s, String c, int i) async {
      if (s.isEmpty || c.isEmpty) return;
      int start = c.indexOf(s, i);
      int end = start + s.length;

      if (0 <= start) {
        if (start < 10) {
                print(start);
                itemsL.add(c.substring(0, start));
              } else {
                itemsL.add(c.substring(start - 10, start));
              }
      }
      if (c.length - end < 10) {
        itemsR.add(c.substring(end, c.length));
      } else {
        itemsR.add(c.substring(end, end + 10));
      }
      itemsN.add(start);
      if (c.length - i >= s.length) searchfor(s, c, end);
    }

    _search() {
      FocusScope.of(context).requestFocus(FocusNode());
      itemsN.clear();
      itemsL.clear();
      itemsR.clear();

      String s = searchContent.text, c = content.text;
      print(c);
      searchfor(s, c, 0);
      titleCount = '${itemsN.length}条结果';
    }

    super.build(context);
    return new Scaffold(
      appBar: new AppBar(
          elevation: 2.0,
          title: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                style: new TextStyle(fontSize: 20, color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: searchContent,
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
                  controller: searchScrollController,
                  child: new ListView.builder(
                    itemCount: itemsL.length,
                    controller: searchScrollController,
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
                                  text: searchContent.text,
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
                    titleCount,
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

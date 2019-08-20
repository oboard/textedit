import 'package:flutter/material.dart';
import 'package:textedit/main.dart';
import 'package:textedit/draggable_scrollbar.dart';

String numform = '(n)';
TextEditingController _controller = new TextEditingController(text: numform);
TextSelection textSelection;
ScrollController numScrollController = new ScrollController();
List<String> itemsL = new List<String>(), itemsR = new List<String>();

class NumPage extends StatefulWidget {
  const NumPage({Key key}) : super(key: key);

  @override
  NumPageState createState() => new NumPageState();
}

class NumPageState extends State<NumPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  fresh() {
    setState(() {
      itemsL.clear();
      itemsR.clear();
      List<String> data = content.text.split('\n');
      for (int i = 0; i < data.length; i++) {
        itemsR.add(data[i]);
        itemsL.add(numform.replaceAll('n', '${i + 1}'));
      }
    });
  }

  int groupValue = 1;

  ///更新group的值,Radio的value==groupValue时候,则按钮选中
  void updateGroupValue(int e) {
    setState(() {
      groupValue = e;
      fresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget widget = new Scaffold(
      appBar: new AppBar(
        title: new Text("添加序号"),
      ),
      body: new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              autofocus: true,
              controller: _controller,
              onChanged: (s) {
                numform = s;
                fresh();
              },
            ),
            new RadioListTile<int>(
              title: const Text('添加至左侧'),
              value: 1,
              groupValue: groupValue,
              onChanged: (int e) => updateGroupValue(e),
            ),
            new RadioListTile<int>(
              title: const Text('添加至右侧'),
              value: 2,
              groupValue: groupValue,
              onChanged: (int e) => updateGroupValue(e),
            ),
            new Flexible(
              child: DraggableScrollbar.arrows(
                backgroundColor: Colors.blue,
                controller: numScrollController,
                child: new ListView.builder(
                  itemCount: itemsL.length,
                  controller: numScrollController,
                  itemBuilder: (context, index) {
                    return new ListTile(
                      title: new RichText(
                        text: TextSpan(
                          style:
                              new TextStyle(color: Colors.black, fontSize: 20),
                          children: (groupValue == 1)
                              ? <TextSpan>[
                                  new TextSpan(
                                    text: itemsL[index],
                                    style: new TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  new TextSpan(text: itemsR[index])
                                ]
                              : <TextSpan>[
                                  new TextSpan(text: itemsR[index]),
                                  new TextSpan(
                                    text: itemsL[index],
                                    style: new TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  title: new Text("提示"),
                  content: new Text("确定添加序号吗？"),
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
                        for (int i = 0; i < itemsL.length; i++) {
                          if (groupValue == 1) {
                            content.text += itemsL[i] + itemsR[i];
                          } else {
                            content.text += itemsR[i] + itemsL[i];
                          }
                          if (i != itemsL.length - 1) content.text += '\n';
                        }
                        itemsL.clear();
                        itemsR.clear();
                        Navigator.pop(context);
                      },
                      child: new Text("确认"),
                    ),
                  ],
                );
              });
        },
        tooltip: '新建',
        child: Icon(Icons.check),
      ),
    );
    if (itemsL.length == 0) {
      fresh();
    }
    return widget;
  }

  @override
  void didUpdateWidget(NumPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (itemsL.length == 0) {
      fresh();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fresh();
    }
  }
}

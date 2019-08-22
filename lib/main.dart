import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:textedit/EditPage.dart';
import 'package:textedit/ReplacePage.dart';
import 'package:textedit/PopupMenuButtonE.dart';
import 'package:textedit/NumPage.dart';
import 'package:textedit/FindPage.dart';
import 'package:flutter/foundation.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(App());
}

TextEditingController content;
TabBar tabBar;
TabBarView tabBarView;
List<EditPageState> epsList = new List<EditPageState>();
List<String> strList = new List<String>();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '文本编辑',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    add();
    super.initState();
    /*if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }*/
  }

  void add() {
    setState(() {
      EditPage b = new EditPage();
      choices.add(new Choice(
        title: '${choices.length + 1}',
        page: b,
      ));
    });
    setState(() {
      if (choices.length > 0) {
        TabController tabControllerE =
            new TabController(length: choices.length, vsync: this);
        List<Widget> tabs = choices.map((Choice choice) {
          return new Tab(text: choice.title);
        }).toList();
        List<Widget> childs = choices.map((Choice choice) {
          return new ChoiceCard(choice: choice);
        }).toList();

        tabBar = new TabBar(
          isScrollable: true,
          tabs: tabs,
          controller: tabControllerE,
        );
        tabBarView = new TabBarView(
          controller: tabControllerE,
          children: childs,
        );

        tabControllerE.addListener(() {
          print('${tabControllerE.index}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new DefaultTabController(
      length: choices.length,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          elevation: 0.0,
          title: new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: new PopupMenuButtonE<int>(
                  child: new Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: new StadiumBorder(),
                      color: Colors.white,
                    ),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.text_format,
                            color: Theme.of(context).primaryColor),
                        new Text(
                          '开始',
                          style: new TextStyle(
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  elevation: 100,
                  onSelected: (int result) async {
                    switch (result) {
                      case 1:
                        add();
                        break;
                      case 2:
                        var clipboardData =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (clipboardData != null)
                          content.text = clipboardData.text;
                        break;
                      case 3:
                        content.text = '';
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItemE<int>(
                      value: 0,
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.close),
                          new Text('  取消'),
                        ],
                      ),
                    ),
                    PopupMenuItemE<int>(
                      value: 1,
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.add_box),
                          new Text('  新标签页')
                        ],
                      ),
                    ),
                    PopupMenuItemE<int>(
                      value: 2,
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.content_paste),
                          new Text('  从剪辑版导入')
                        ],
                      ),
                    ),
                    PopupMenuItemE<int>(
                      value: 3,
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.close),
                          new Text('  清空')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new Expanded(
                child: tabBar,
              ),
            ],
          ),
        ),
        body: tabBarView,
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.page});

  final String title;
  final Widget page;
}

List<Choice> choices = new List<Choice>();

class ChoiceCard extends StatefulWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChoiceState();
  }
}

class ChoiceState extends State<ChoiceCard> {
  @override
  Widget build(BuildContext context) {
    return widget.choice.page;
  }
}

import 'package:flutter/material.dart';
import 'package:project/write.dart';

import 'data/database.dart';
import 'data/todo.dart';
import 'data/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final dbHelper = DatabaseHelper.instance;
  int selectIndex = 0;

  List<Todo> todos = [];
  List<Todo> allTodos = [];

  void getTodayTodo() async {
    todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {});
  }

  void getAllTodo() async {
    allTodos = await dbHelper.getAllTodo();
    setState(() {});
  }

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child:AppBar(),
        preferredSize: Size.fromHeight(0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // 추가 화면으로 이동
          Todo todo = await Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => TodoWritePage(todo: Todo(
                title: "",
                memo : "",
                color: 0,
                done: 0,
                category: "",
                date: Utils.getFormatTime(DateTime.now())
              ))
          ));
          getTodayTodo();
        },
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              label: "오늘"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: "기록"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "더보기"
          )
        ],
        currentIndex: selectIndex,
        onTap: (idx) {
          if(idx == 1) {
            getAllTodo();
          }
          setState(() {
            selectIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if(selectIndex == 0) {
      return getMain();
    } else {
      return getHistory();
    }
  }

  Widget getMain() {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Container(
            child: Text("오늘하루", style: TextStyle(fontWeight: FontWeight.bold, fontSize:  20)),
            margin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          );
        } else if (idx == 1) {
          List<Todo> undoneList = todos.where((t){
            return t.done == 0;
          }).toList();

          return Container(
            child: Column(
              children: List.generate(undoneList.length, (_idx) {
                Todo t = undoneList[_idx];

                return InkWell(child : TodoCardWidget(t:t),
                  onTap: () async {
                    setState(() {
                      if(t.done == 0) {
                        t.done = 1;
                      } else {
                        t.done = 0;
                      }
                    });
                    await dbHelper.modifyTodo(t);
                  },
                  onLongPress: () async {
                    getTodayTodo();
                  },
                );
              }),
            ),
          );
        } else if (idx == 2) {
          return Container(
            child: Text("완료", style: TextStyle(fontWeight: FontWeight.bold, fontSize:  20)),
            margin: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
          );
        } else if (idx == 3) {
          List<Todo> doneList = todos.where((t){
            return t.done == 1;
          }).toList();

          return Container(
            child: Column(
              children: List.generate(doneList.length, (_idx) {
                Todo t = doneList[_idx];

                return InkWell(child : TodoCardWidget(t:t),
                  onTap: () async {
                    setState(() {
                      if(t.done == 0) {
                        t.done = 1;
                      } else {
                        t.done = 0;
                      }
                    });
                    await dbHelper.modifyTodo(t);
                  },
                  onLongPress: () async {
                    getTodayTodo();
                  },
                );
              }),
            ),
          );
        }
        return Container();
      },
      itemCount: 4,
    );
  }

  List<Todo> allTodo = [];

  Widget getHistory() {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        return TodoCardWidget(t: allTodo[idx]);
      },
      itemCount: allTodo.length,
    );
  }
}

class TodoCardWidget extends StatelessWidget {
  final Todo t;
  TodoCardWidget({Key key, this.t}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int now = Utils.getFormatTime(DateTime.now());
    DateTime time = Utils.numToDateTime(t.date);

    return Container(
      decoration: BoxDecoration(
          color: Color(t.color),
          borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize:  18, color: Colors.white),),
              Text(t.done == 0 ? "미완료" : "완료", style: TextStyle(color: Colors.white),)
            ],
          ),
          Container(height: 8),
          Text(t.memo, style: TextStyle(color: Colors.white),),
          now == t.date ? Container() : Text("${time.month}월 ${time.day}일", style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }
}
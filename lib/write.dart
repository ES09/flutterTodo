import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/todo.dart';

class TodoWritePage extends StatefulWidget {

  final Todo todo;
  TodoWritePage({Key key, this.todo}): super(key: key);

  @override
  State<StatefulWidget> createState(){
    return _TodoWritePageState();
  }
}

class _TodoWritePageState extends State<TodoWritePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  int colorIndex = 0;
  int categoryIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: (){
                //내용 저장
                widget.todo.title = titleController.text;
                widget.todo.memo = memoController.text;

                Navigator.of(context).pop(widget.todo);
              },
              child: Text("Save", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) {
          if(idx == 0) {
            return Container(
              child: Text("제목",
                style: TextStyle(fontSize: 20),
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            );
          } else if(idx == 1) {
            return Container(
              child: TextField(
                controller: titleController,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
            );
          } else if(idx == 2) {
            return InkWell(child : Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("색상",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    color: Color(widget.todo.color),
                  )
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
              onTap: (){
                List<Color> colors = [
                  Color(0xFF80d3f4),
                  Color(0xFFa794fa),
                  Color(0xFFfb91d1),
                  Color(0xFFfb8a94),
                  Color(0xFFfebd9a),
                  Color(0xFF51e29d),
                  Color(0xFFFFFFFF),
                ];

                widget.todo.color = colors[colorIndex].value;
                colorIndex++;
                setState(() {
                  colorIndex = colorIndex % colors.length;
                });
              }
            );
          } else if(idx == 3) {
            return InkWell(child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("카테고리",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(widget.todo.category)
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
              onTap: (){
                List<String> category = [
                  "study",
                  "exercise",
                  "game",
                  "reading"
                ];

                widget.todo.category = category[categoryIndex];
                categoryIndex++;
                setState(() {
                  categoryIndex = categoryIndex % category.length;
                });

              },
            );
          } else if(idx == 4) {
            return Container(
              child: Text("메모",
                style: TextStyle(fontSize: 20),
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            );
          } else if(idx == 5) {
            return Container(
              child: TextField(
                controller: memoController,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black
                    )
                  )
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
            );
          }
          return Container();
        },
        itemCount: 6,
      ),
    );
  }
}
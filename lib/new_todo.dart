import 'package:apk_todo_test/todo.dart';
import 'package:flutter/material.dart';

class NewTodoView extends StatefulWidget {
  final Todo item;

  NewTodoView({this.item});

  @override
  _NewTodoViewState createState() => _NewTodoViewState();
}

class _NewTodoViewState extends State<NewTodoView> {
  DateTime now = new DateTime.now();
  TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(
        text: widget.item != null ? widget.item.title : null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            widget.item != null ? 'Edit Todo' : 'New Todo',
            style: TextStyle(fontFamily: 'Spartan', fontSize: 24.0),
            key: Key('new-item-title'),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  maxLines: 5,
                  controller: titleController,
                  autofocus: true,
                  onEditingComplete: submit,
                  decoration: InputDecoration(
                    labelText: 'Enter todo here',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Spartan',
                        fontSize: 14.0),
                    contentPadding: EdgeInsets.fromLTRB(15.0, .10, 15.0, 10.0),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurple, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
              new Padding(padding: EdgeInsets.only(top: 20)),
              RaisedButton(
                color: Colors.pink,
                child: Text(widget.item != null ? 'UPDATE' : 'ADD',
                    style: TextStyle(fontFamily: 'Spartan', fontSize: 18.0)),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                onPressed: () => submit(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(titleController.text);
  }
}

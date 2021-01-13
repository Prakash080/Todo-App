import 'package:apk_todo_test/new_todo.dart';
import 'package:apk_todo_test/todo.dart';
import 'package:flutter/material.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterTodo',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  DateTime now = new DateTime.now();

  List<Todo> items = new List<Todo>();
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  AnimationController emptyListController;

  @override
  void initState() {
    emptyListController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    emptyListController.forward();
    super.initState();
  }

  @override
  void dispose() {
    emptyListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Todo List',
            style: TextStyle(fontFamily: 'Spartan', fontSize: 28.0),
            key: Key('main-app-title'),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: Icon(Icons.add),
          onPressed: () => goToNewItemView(),
        ),
        body: renderBody());
  }

  Widget renderBody() {
    if (items.length > 0) {
      return buildListView();
    } else {
      return emptyList();
    }
  }

  Widget emptyList() {
    return Center(
        child: FadeTransition(
            opacity: emptyListController,
            child: Text('No Tasks Created',
                style: TextStyle(fontFamily: 'Spartan', fontSize: 18.0))));
  }

  Widget buildListView() {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: items.length,
      itemBuilder: (BuildContext context, int index, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: buildListTile(items[index], index),
        );
      },
    );
  }

  Widget buildListTile(item, index) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Card(
            child: ListTile(
          leading: Checkbox(
            value: items[index].completed,
            onChanged: (value) => changeItemCompleteness(item),
          ),
          title: Text(
            item.title,
            key: Key('item-$index'),
            style: TextStyle(
                fontFamily: 'Spartan',
                fontSize: 18.0,
                color: item.completed ? Colors.grey : Colors.black,
                decoration: item.completed ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text('Created on:${now.day}/${now.month}/${now.year}'),
          trailing: IconButton(
              icon: Icon(
                  items[index].completed ? Icons.delete_forever : Icons.edit),
              onPressed: () {
                setState(() {
                  if (items[index].completed)
                    removeItemFromList(item, index);
                  else
                    goToEditItemView(item);
                });
              }),
        )));
  }

  void changeItemCompleteness(Todo item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView();
    })).then((title) {
      if (title != null) {
        setState(() {
          addItem(Todo(title: title));
        });
      }
    });
  }

  void addItem(Todo item) {
    items.insert(0, item);
    if (animatedListKey.currentState != null)
      animatedListKey.currentState.insertItem(0);
  }

  void goToEditItemView(Todo item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoView(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item, String title) {
    item.title = title;
  }

  void removeItemFromList(Todo item, int index) {
    animatedListKey.currentState.removeItem(index, (context, animation) {
      return SizedBox(
        width: 0,
        height: 0,
      );
    });
    deleteItem(item);
  }

  void deleteItem(Todo item) {
    items.remove(item);
    if (items.isEmpty) {
      if (emptyListController != null) {
        emptyListController.reset();
        setState(() {});
        emptyListController.forward();
      }
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app1/new_todo.dart';
import 'package:todo_app1/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'dart:async';

//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  List<Todo> items = new List<Todo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TodoList',
          key: Key('main-app-title'),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>goToNewItemView(),
      ),
      body: renderBody()
    );
  }

  /*
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'todo_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE task(id INTEGER PRIMARY KEY, title TEXT, completed INTEGER, reminder INTEGER, time TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  static String getDatabasesPath() {
    return './path';
  }
  */

  Widget renderBody(){
//    if(items.length == 0) {
//      Todo item = new Todo();
//      item.title = 'First Task';
//      item.completed = false;
//      items.add(item);
//
//      item = new Todo();
//      item.title = 'Second Task';
//      item.completed = false;
//      items.add(item);
//
//      item = new Todo();
//      item.title = 'Three Task';
//      item.completed = false;
//      items.add(item);
//    }
    print('items' + items.asMap().toString());
    if(items.length > 0){
      return buildListView();
    }else{
      return emptyList();
    }
  }
  
  Widget emptyList(){
    return Center(
    child: Text('Empty Todo List !'),
    );
  }


  Widget buildListView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context,int index){
        return buildItem(items[index], index);
      },
    );
  }

  Widget buildItem(Todo item, index){
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(color: Colors.red[700]),
      onDismissed: (direction) => _removeItemFromList(item),
      direction: DismissDirection.horizontal,//smissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(item, index){
    return ListTile(
      onTap: () => changeItemCompleteness(item),
      onLongPress: () => goToEditItemView(item),
      title: Text(
        item.title,
        key: Key('item-$index'),
        style: TextStyle(
          color: item.completed ? Colors.grey : Colors.black,
          decoration: item.completed ? TextDecoration.lineThrough : null
        ),
      ),
      trailing: Icon(item.completed
        ? Icons.check_box
        : Icons.check_box_outline_blank,
        key: Key('completed-icon-$index'),
      ),
    );
  }

  void changeItemCompleteness(Todo item){
    setState(() {
      item.completed = !item.completed;
    });
  }

  void goToNewItemView(){
    // Here we are pushing the new view into the Navigator stack. By using a
    // MaterialPageRoute we get standard behaviour of a Material app, which will
    // show a back button automatically for each platform on the left top corner
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodoView();
    })).then((title){
      if(title != null) {
        setState(() {
          addItem(Todo(title: title));
        });
      }
    })//.then((value) => renderBody())
    ;
    //build(context);
  }

  void addItem(Todo item){
    // Insert an item into the top of our list, on index zero
    setState(() {
      items.insert(0, item);
    });
  }

  void goToEditItemView(item){
    // We re-use the NewTodoView and push it to the Navigator stack just like
    // before, but now we send the title of the item on the class constructor
    // and expect a new title to be returned so that we can edit the item
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodoView(item: item);
    })).then((title){
      if(title != null) {
        setState(() {
          editItem(item, title);
        });
      }
    })//.then((value) => renderBody())
    ;
    //build(context);
  }

  void editItem(Todo item ,String title){
    item.title = title;
  }

  void _removeItemFromList(item) {
    setState(() {
      deleteItem(item);
    });
    //renderBody();
    //build(context);
  }

  void deleteItem(item){
    // We don't need to search for our item on the list because Dart objects
    // are all uniquely identified by a hashcode. This means we just need to
    // pass our object on the remove method of the list
    items.remove(item);
  }
}
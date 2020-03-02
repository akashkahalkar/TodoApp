import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  bool isDarkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        brightness: isDarkModeEnabled ? Brightness.dark : Brightness.light
      ),
      debugShowCheckedModeBanner: false,
      home: MyTodoApp(),
    );
  }

  updateDarkModeState(value) {
    setState(() {
      isDarkModeEnabled = value;
    });
  }
}

class MyTodoApp extends StatefulWidget {

  @override
  _MyTodoAppState createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  
  List<String> todos = [];
  TextEditingController inputController = TextEditingController();
  bool iconButtonVisible = false;
  bool isDarkModeEnable = false;
  GlobalKey<MyAppState> myAppState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo's"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.green
              ),
            ),
            ListTile(
              title: Text('Switch dark mode'),
              trailing: Switch(
                value: isDarkModeEnable,
                onChanged: (newValue) {
                   myAppState.currentState.updateDarkModeState(newValue);
                  // setState(() {
                   
                  // });
                },
              ),
            )
          ],
        ),
      ),
      body: todoListContainer(),
    );
  }

  Widget stackBehindDismiss(index) {
  return Container(
    key: ValueKey(index),
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 20.0),
    color: Colors.red,
    child: Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
}

  Widget todoListContainer() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: _headerRow()
            ),
          Expanded(
            child: _todoReorderableListView()
          ),
        ],
      ),
    );
  }

  Widget _headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Flexible(
                  child: TextField(
                    controller: inputController,
                    onChanged:(text) {
                      setState(() {
                        iconButtonVisible = false;
                      });
                    },
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Todo here',
            ),          
          ),
        ),
        IconButton(
          icon:Icon(Icons.add), 
          onPressed: (){
           setState(() {
             _addTodoItem(inputController.text);
           }); 
          }
        ),
      ],
    );
  }

  Widget _todoReorderableListView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
      child: ReorderableListView(
        children: List.generate(todos.length, (index) {
           return Dismissible(
             background: stackBehindDismiss(index),
             key: ValueKey(index),
             onDismissed: (direction) {
              setState(() {
                _removeItemAtIndex(index);
              });
            },
             child: Card(
               child: ListTile(
                 onTap: (){
                   setState(() {
                    _showDialog(todos[index]);
                   });
                 },
                    key: ValueKey(index),
                    leading: Text('$index'),
                    title: Text(
                      todos[index],
                    ),
                  ),
               ),
           ); 
        }), 
        onReorder: (oldIndex, newIndex){
          setState(() {
            _reorderTodos(oldIndex, newIndex);
          });
        }
      ),
    );
  }

  void _showDialog(textString) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Todo"),
          content: new Text(textString),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reorderTodos(oldIndex, newIndex) {
    var temp = todos[oldIndex];
    todos[oldIndex] = todos[newIndex];
    todos[newIndex] = temp;

  }
  void _removeItemAtIndex(index) {
    todos.removeAt(index);
  }

  void _addTodoItem(item) {
    if (inputController.text.isNotEmpty) {
      todos.add(item);
      inputController.clear();

    }
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/todo.dart';
import 'package:flutter_laravel/providers/todo_provider.dart';
import 'package:flutter_laravel/screens/create_screen.dart';
import 'package:flutter_laravel/screens/update_screen.dart';
import 'package:jiffy/jiffy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.microtask(
      () => {Provider.of<TodoProvider>(context, listen: false).getTodoList()},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Row(
          children: [
            FlutterLogo(size: 40),
            SizedBox(width: 6),
            Text(
              'Flutter',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<TodoProvider>(context, listen: false).getTodoList();
        },
        child: Consumer<TodoProvider>(
          builder:
              (
                BuildContext context,
                TodoProvider todoProvider,
                Widget? widget,
              ) {
                return ListView.builder(
                  itemCount: todoProvider.todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    Todo todo = todoProvider.todos[index];

                    return Card(
                      elevation: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Colors.grey.shade300,
                            ),
                            child: Image.network(
                              'http://192.168.1.78:8000${todo.pathName}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.62,
                            padding: EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  todo.description ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${todo.createdBy} . ${Jiffy.parseFromDateTime(todo.createdAt).fromNow().replaceFirst(RegExp(r'(^an)|(^a)'), "1")}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.10,
                            alignment: Alignment.center,
                            child: PopupMenuButton<void Function()>(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      Future.delayed(
                                        Duration(milliseconds: 300),
                                        () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              child: UpdateScreen(todo: todo),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration: Duration(
                                                milliseconds: 700,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      titleTextStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                      leading: Icon(
                                        Icons.edit,
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                      title: Text('Update'),
                                    ),
                                  ),
                                  PopupMenuDivider(),
                                  PopupMenuItem(
                                    onTap: () {
                                      _onDelete(todo.id);
                                    },
                                    child: ListTile(
                                      titleTextStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                      ),
                                      leading: Icon(
                                        Icons.delete,
                                        size: 24,
                                        color: Colors.red,
                                      ),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future.delayed(Duration(milliseconds: 300), () {
            Navigator.push(
              context,
              PageTransition(
                child: CreateScreen(),
                type: PageTransitionType.bottomToTop,
                duration: Duration(milliseconds: 700),
              ),
            );
          });
        },
        tooltip: 'Increment',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.blue.shade500,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 24),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _onDelete(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(fontSize: 18, color: Colors.red),),
              onPressed: () {
                context.read<TodoProvider>().deleteTodoList(id).whenComplete((){
                Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

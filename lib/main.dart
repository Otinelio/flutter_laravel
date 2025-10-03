import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/todo.dart';
import 'package:flutter_laravel/providers/todo_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(
          create: (context) => TodoProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      body: Consumer<TodoProvider>(
        builder: (BuildContext context, TodoProvider todoProvider, Widget? widget) {
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
                        'http://10.0.2.2:8000${todo.pathName}',
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
                              onTap: () {},
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
                              onTap: () {},
                              child: ListTile(
                                titleTextStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                                leading: Icon(
                                  Icons.edit,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.blue.shade500,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 24),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

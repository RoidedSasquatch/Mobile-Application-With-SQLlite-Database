
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lab06/database.dart';
import 'package:lab06/list_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  static int ID = 1;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<ListItem> listItems = [];
  late TextEditingController input;
  late final db;
  late final listDAO;
  late final result;

  void addListItem() {
    setState(() {
      ListItem listItem = ListItem(MyHomePage.ID++, input.value.text);
      listDAO.insertList(listItem);
      listItems.add(listItem);
      input.text = "";
    });
  }

  void init() async {
    db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    listDAO = db.listDao;
    var result = await listDAO.findAllListItems();

    setState(() {
      listItems.addAll(result);
    });
  }

  @override
  void initState() {
    super.initState();
    input = TextEditingController();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: addListItem, child: const Icon(Icons.add)),
                Expanded(child: TextField(controller: input))
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (item, rowNum) {
                return GestureDetector(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 50, child: Text("${rowNum + 1}.")),
                        Text(listItems[rowNum].listItem),
                      ]),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete List Item?"),
                            content: const Text(
                                "Would you like to delete this list item?"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      listDAO.delete(listItems[rowNum].id);
                                      listItems.removeAt(rowNum);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text("Yes")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"))
                            ],
                          );
                        });
                  },
                );
              },
              itemCount: listItems.length,
            )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

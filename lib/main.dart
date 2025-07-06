import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To-Do List",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
      ),
      home: const MyHomePage(title: "To-Do List"),
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
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  List<String> tileTitles = [];
  List<bool> tileBools = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('titles', tileTitles);
    await prefs.setStringList(
      'bools',
      tileBools.map((e) => e.toString()).toList(),
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tileTitles = prefs.getStringList('titles') ?? [];
      tileBools =
          (prefs.getStringList('bools') ?? []).map((e) => e == 'true').toList();
    });
  }

  void _reorder() {
    List<bool> newBools = [];
    List<String> newStrings = [];

    for (int i = 0; i < tileBools.length; i++) {
      if (tileBools[i] == false) {
        newBools.add(tileBools[i]);
        newStrings.add(tileTitles[i]);
      }
    }

    for (int i = 0; i < tileTitles.length; i++) {
      if (tileBools[i]) {
        newBools.add(tileBools[i]);
        newStrings.add(tileTitles[i]);
      }
    }

    tileTitles = newStrings;
    tileBools = newBools;
  }

  void _addExpansionTile() {
    showDialog(
      context: context,
      builder: (context) {
        // ignore: unused_local_variable
        String newTitle = "";
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Enter the title", style: TextStyle(color: Colors.green)),
          content: TextField(
            onChanged: (value) {
              newTitle = value;
            },
            decoration: InputDecoration(hintText: "Enter the title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (newTitle != '') {
                  setState(() {
                    tileTitles.add(newTitle);
                    tileBools.add(false);
                    _reorder();
                    saveData();
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  //bool val = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      backgroundColor: Color.fromARGB(255, 238, 238, 191),
      body: ListView.builder(
        itemCount: tileTitles.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  value: tileBools[index],
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (false == tileBools[index]) {
                        tileBools[index] = true;
                      } else {
                        tileBools[index] = false;
                      }
                      _reorder();
                      saveData();
                    });
                  },
                  checkColor: Color.fromARGB(255, 241, 241, 241),
                  title: Text(
                    tileTitles[index],
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      decoration:
                          tileBools[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.green),
                onPressed: () {
                  setState(() {
                    tileTitles.removeAt(index);
                    tileBools.removeAt(index);
                  });
                  saveData();
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _addExpansionTile();
            // _reorder();
            // saveData();
          });
        },
        tooltip: 'Add Expansion List',
        child: const Icon(Icons.add),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

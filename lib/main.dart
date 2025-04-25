import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rishabh's App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
      ),
      home: const MyHomePage(title: "Rishbh's App"),
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
                if (newTitle != '') {
                  setState(() {
                    tileTitles.add(newTitle);
                    tileBools.add(false);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
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
      backgroundColor: Color.fromARGB(246, 255, 255, 255),
      body: ListView.builder(
        itemCount: tileTitles.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: tileBools[index],
            onChanged: (bool? newValue) {
              setState(() {
                if (false == tileBools[index]) {
                  tileBools[index] = true;
                } else {
                  tileBools[index] = false;
                }
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
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addExpansionTile,
        tooltip: 'Add Expansion List',
        child: const Icon(Icons.add),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

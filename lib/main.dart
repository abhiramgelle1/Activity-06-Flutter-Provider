import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  // Increment method
  void increment() {
    value += 1;
    notifyListeners();
  }

  // Decrement method
  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }

  // Get background color based on the counter value
  Color getBackgroundColor() {
    if (value <= 12) return Colors.lightBlueAccent;
    if (value <= 19) return Colors.lightGreenAccent;
    if (value <= 30) return Colors.yellowAccent;
    if (value <= 50) return Colors.orangeAccent;
    return Colors.grey;
  }

  // Get milestone message based on the counter value
  String getMilestoneMessage() {
    if (value <= 12) return "You're a child!";
    if (value <= 19) return "Teenager time!";
    if (value <= 30) return "You're a young adult!";
    if (value <= 50) return "You're an adult now!";
    return "Golden years!";
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) => Container(
          color: counter
              .getBackgroundColor(), // Set background color based on the counter value
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  counter
                      .getMilestoneMessage(), // Display milestone message based on the counter value
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              var counter = context.read<Counter>();
              counter.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              var counter = context.read<Counter>();
              counter.decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

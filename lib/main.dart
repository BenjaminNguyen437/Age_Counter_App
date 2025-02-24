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
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {  // Prevent negative values
      value -= 1;
      notifyListeners();
    }
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

  // Function to determine message and color based on age
  Map<String, dynamic> getAgeMilestone(int age) {
    if (age <= 12) {
      return {
        'message': "You're a child!",
        'color': Colors.lightBlue[100]!,
      };
    } else if (age <= 19) {
      return {
        'message': "Teenager time!",
        'color': Colors.lightGreen[100]!,
      };
    } else if (age <= 30) {
      return {
        'message': "You're a young adult!",
        'color': Colors.yellow[100]!,
      };
    } else if (age <= 50) {
      return {
        'message': "You're an adult now!",
        'color': Colors.orange[100]!,
      };
    } else {
      return {
        'message': "Golden years!",
        'color': Colors.grey[300]!,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        final milestone = getAgeMilestone(counter.value);
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Age Counter'),
          ),
          backgroundColor: milestone['color'],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Your age is:'),
                Text(
                  '${counter.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  milestone['message'],
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: counter.increment,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: counter.decrement,
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        );
      },
    );
  }
}
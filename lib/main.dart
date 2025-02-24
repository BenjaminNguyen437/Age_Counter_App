import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    if (value < 99) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }

  void setValue(double newValue) {
    value = newValue.round();
    notifyListeners();
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

  Map<String, dynamic> getAgeMilestone(int age) {
    if (age <= 12) {
      return {'message': "You're a child!", 'color': Colors.lightBlue[100]!};
    } else if (age <= 19) {
      return {'message': "Teenager time!", 'color': Colors.lightGreen[100]!};
    } else if (age <= 30) {
      return {'message': "You're a young adult!", 'color': Colors.yellow[100]!};
    } else if (age <= 50) {
      return {'message': "You're an adult now!", 'color': Colors.orange[100]!};
    } else {
      return {'message': "Golden years!", 'color': Colors.grey[300]!};
    }
  }

  Color getProgressColor(int age) {
    if (age <= 33) return Colors.green;
    if (age <= 67) return Colors.yellow;
    return Colors.red;
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
                const SizedBox(height: 20),
                Slider(
                  value: counter.value.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: counter.value.toString(),
                  onChanged: (double value) {
                    counter.setValue(value);
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: counter.value / 99,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getProgressColor(counter.value),
                    ),
                    minHeight: 10,
                  ),
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
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Flutter',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<String> _history = [];

  void _addToHistory(String entry) {
    setState(() {
      _history.insert(0, entry);
      if (_history.length > 20) {
        _history.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      CalculatorPage(onResult: _addToHistory),
      HistoryPage(history: _history),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final Function(String) onResult;
  const CalculatorPage({super.key, required this.onResult});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _input = "";
  List<double> _numbers = [];
  List<String> _operators = [];
  bool _shouldResetInput = false;

  void _calculate() {
    if (_numbers.isEmpty || _operators.isEmpty) return;

    // Make a copy of numbers and operators
    List<double> numbers = List.from(_numbers);
    List<String> operators = List.from(_operators);

    // First, process multiplication and division
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == "x" || operators[i] == "/") {
        double result = 0;
        if (operators[i] == "x") {
          result = numbers[i] * numbers[i + 1];
        } else if (operators[i] == "/") {
          if (numbers[i + 1] == 0) {
            _output = "Error";
            _input = "";
            _numbers.clear();
            _operators.clear();
            return;
          }
          result = numbers[i] / numbers[i + 1];
        }

        // Replace the two numbers with the result
        numbers[i] = result;
        numbers.removeAt(i + 1);
        operators.removeAt(i);
        i--; // Adjust index after removal
      }
    }

    // Then process addition and subtraction
    double finalResult = numbers[0];
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == "+") {
        finalResult += numbers[i + 1];
      } else if (operators[i] == "-") {
        finalResult -= numbers[i + 1];
      }
    }

    // Format the result to remove trailing .0 if it's an integer
    String resultStr =
        finalResult % 1 == 0
            ? finalResult.toInt().toString()
            : finalResult.toString();

    // Build the calculation string for history
    String calculation = "";
    for (int i = 0; i < _numbers.length; i++) {
      calculation += _numbers[i].toString();
      if (i < _operators.length) {
        calculation += " ${_operators[i]} ";
      }
    }
    calculation += "= $resultStr";

    widget.onResult(calculation);
    _output = resultStr;
    _input = "";
    _numbers = [finalResult];
    _operators.clear();
    _shouldResetInput = true;
  }

  buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _input = "";
      _output = "0";
      _numbers.clear();
      _operators.clear();
      _shouldResetInput = false;
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "x" ||
        buttonText == "/") {
      if (_input.isNotEmpty) {
        double num = double.tryParse(_input) ?? 0;
        _numbers.add(num);
      }

      if (_numbers.isNotEmpty || _operators.isNotEmpty) {
        _operators.add(buttonText);
        _input = "";
        _shouldResetInput = false;
      }
    } else if (buttonText == "=") {
      if (_input.isNotEmpty) {
        double num = double.tryParse(_input) ?? 0;
        _numbers.add(num);
      }

      if (_numbers.isNotEmpty && _operators.isNotEmpty) {
        _calculate();
      }
    } else {
      if (_shouldResetInput) {
        _input = "";
        _shouldResetInput = false;
      }
      _input += buttonText;
      _output = _input;
    }
    setState(() {});
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          child: Text(buttonText, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display the current calculation expression
    String displayExpression = "";
    for (int i = 0; i < _numbers.length; i++) {
      displayExpression += _numbers[i].toString();
      if (i < _operators.length) {
        displayExpression += " ${_operators[i]} ";
      }
    }
    displayExpression += _input;

    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator Flutter')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              displayExpression.isNotEmpty ? displayExpression : "0",
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              _output,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(child: Divider()),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/"),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("x"),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-"),
                ],
              ),
              Row(
                children: [
                  buildButton("C"),
                  buildButton("0"),
                  buildButton("="),
                  buildButton("+"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;
  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body:
          history.isEmpty
              ? const Center(child: Text('Belum ada riwayat perhitungan.'))
              : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(history[index]),
                  );
                },
              ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            SizedBox(height: 20),
            Text('Nama: yosafat muasyawa', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: yosa@email.com', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

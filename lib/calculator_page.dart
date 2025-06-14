import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  final Function(String)? onHistoryUpdated;

  CalculatorPage({this.onHistoryUpdated});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String currentDisplay = "0"; // Menampilkan angka yang sedang dimasukkan
  String historyDisplay = ""; // Menampilkan riwayat input (angka + operator)
  String expression = ""; // Menyimpan semua input pengguna

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      // Reset semua nilai
      currentDisplay = "0";
      historyDisplay = "";
      expression = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "x") {
      // Jika currentDisplay tidak kosong, tambahkan ke expression
      if (currentDisplay != "0") {
        expression += currentDisplay + " $buttonText ";
        historyDisplay = expression; // Update riwayat tampilan
        currentDisplay = "0"; // Reset tampilan angka yang sedang dimasukkan
      }
    } else if (buttonText == ".") {
      if (currentDisplay.contains(".")) {
        return; // Jangan tambahkan titik jika sudah ada
      } else {
        currentDisplay = currentDisplay + buttonText;
      }
    } else if (buttonText == "=") {
      // Tambahkan angka terakhir ke expression
      expression += currentDisplay;
      historyDisplay = expression; // Tampilkan seluruh expression
      // Lakukan perhitungan
      currentDisplay = calculate(expression);
      // Tambahkan ke riwayat
      if (widget.onHistoryUpdated != null) {
        widget.onHistoryUpdated!("$expression = $currentDisplay");
      }
      expression = ""; // Reset expression setelah perhitungan
    } else {
      currentDisplay = currentDisplay == "0" ? buttonText : currentDisplay + buttonText;
    }

    setState(() {});
  }

  String calculate(String expression) {
    // Pisahkan angka dan operator
    List<String> parts = expression.split(" ");
    double result = double.parse(parts[0]); // Ambil angka pertama

    // Loop melalui parts untuk melakukan perhitungan
    for (int i = 1; i < parts.length; i += 2) {
      String operator = parts[i];
      double nextNumber = double.parse(parts[i + 1]);

      if (operator == "+") {
        result += nextNumber;
      } else if (operator == "-") {
        result -= nextNumber;
      } else if (operator == "x") {
        result *= nextNumber;
      } else if (operator == "/") {
        result /= nextNumber;
      }
    }

    // Hilangkan .0 jika hasilnya bilangan bulat
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toString();
    }
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: 50,
          maxHeight: 80,
          maxWidth: 80,
        ),
        margin: EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red[900],
            padding: EdgeInsets.all(20),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Tampilkan riwayat input (angka + operator)
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Text(
                historyDisplay,
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ),
            // Tampilkan angka yang sedang dimasukkan atau hasil perhitungan
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                currentDisplay,
                style: TextStyle(fontSize: 48),
              ),
            ),
            Expanded(child: Divider()),
            Column(children: [
              Row(children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/"),
              ]),
              Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("x"),
              ]),
              Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-"),
              ]),
              Row(children: [
                buildButton("."),
                buildButton("0"),
                buildButton("C"),
                buildButton("+"),
              ]),
              Row(children: [
                buildButton("="),
              ]),
            ]),
          ],
        ),
      ),
    );
  }
}
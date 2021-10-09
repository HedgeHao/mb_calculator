import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Calculator()),
    );
  }
}

String left = '';
String right = '';
String operator = '';

class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String result = '0';

  double _calculate() {
    if (operator.isEmpty && right.isEmpty) {
      return 0;
    }

    double r = 0;
    double dLeft = double.tryParse(left) ?? 0;
    double dRight = double.tryParse(right) ?? 0;
    if (dLeft == 0 && dRight == 0) {
      _clear();
      return 0;
    }

    print('calculate: $dLeft $operator $dRight');

    if (operator == '+') {
      r = dLeft + dRight;
    } else if (operator == '-') {
      r = dLeft - dRight;
    } else if (operator == '*') {
      r = dLeft * dRight;
    } else if (operator == '/') {
      r = dLeft / dRight;
    }

    if (r - r.toInt() == 0) {
      left = r.toInt().toString();
    } else {
      left = r.toStringAsFixed(2);
    }

    setState(() {
      result = left;
    });

    right = '';

    return r;
  }

  _operator(String o) {
    if (left.isEmpty) left = '0';

    if (operator.isEmpty || (operator.isNotEmpty && right.isEmpty)) {
      operator = o;
    } else if (right.isNotEmpty) {
      _calculate();
      operator = o;
    }
  }

  _clear() {
    left = '';
    operator = '';
    right = '';
    setState(() {
      result = '0';
    });
  }

  _show() {
    String s = '';
    if (right.isNotEmpty) {
      s = '$left $operator $right';
    } else if (right.isEmpty && operator.isNotEmpty) {
      s = '$left $operator';
    } else if (left.isNotEmpty) {
      s = left;
    } else {
      s = '0';
    }

    setState(() {
      result = s;
    });
  }

  onclick(String key) {
    print('press $key');
    switch (key) {
      case '0':
        if (left.isEmpty) {
        } else if (left.isNotEmpty && operator.isEmpty) {
          left += '0';
        } else if (left.isNotEmpty && operator.isNotEmpty && right.isNotEmpty) {
          right += '0';
        }
        _show();
        break;
      case '00':
        if (left.isEmpty) {
        } else if (left.isNotEmpty && operator.isEmpty) {
          left += '00';
        } else if (left.isNotEmpty && operator.isNotEmpty && right.isNotEmpty) {
          right += '00';
        }
        _show();
        break;
      case '+':
      case '-':
      case '*':
      case '/':
        _operator(key);
        _show();
        break;
      case '完成':
        _calculate();
        operator = '';
        break;
      case 'C':
        _clear();
        break;
      case '=':
        _calculate();
        operator = '';
        break;
      default:
        if (left.isNotEmpty && operator.isEmpty) {
          left += key;
        } else if (right.isNotEmpty || (right.isEmpty && operator.isNotEmpty)) {
          right += key;
        } else if (left == '0') {
          left = key;
        } else {
          left += key;
        }
        _show();
    }

    print('Final: $left $operator $right');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(result, style: const TextStyle(fontSize: 28)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorButton('/', onclick),
            CalculatorButton('*', onclick),
            CalculatorButton('-', onclick),
            CalculatorButton('+', onclick),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorButton('7', onclick),
            CalculatorButton('8', onclick),
            CalculatorButton('9', onclick),
            CalculatorButton('C', onclick),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorButton('4', onclick),
            CalculatorButton('5', onclick),
            CalculatorButton('6', onclick),
            CalculatorButton('', onclick),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorButton('1', onclick),
            CalculatorButton('2', onclick),
            CalculatorButton('3', onclick),
            CalculatorButton('=', onclick),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalculatorButton('.', onclick),
            CalculatorButton('0', onclick),
            CalculatorButton('00', onclick),
            CalculatorButton('完成', onclick, color: Colors.orange),
          ],
        )
      ],
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final Function(String key) onclick;
  final String label;
  final Color? color;

  const CalculatorButton(this.label, this.onclick, {this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black)),
        onPressed: () {
          onclick(label);
        },
        child: Text(
          label,
          style: TextStyle(color: color ?? Colors.white),
        ));
  }
}

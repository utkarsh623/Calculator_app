import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade800,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CalculatorScreen()),
      );
    });
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate, size: 72, color: Colors.blueGrey.shade100),
            const SizedBox(height: 32),
            const Text(
              "Simple Calculator",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        try {
          result = _calculate(input);
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  String _calculate(String expression) {
    try {
      expression = expression.replaceAll('x', '*');
      expression = expression.replaceAll('÷', '/');

      if (expression.contains('%')) {
        return _evaluateModuloExpression(expression);
      } else {
        Parser p = Parser();
        Expression exp = p.parse(expression);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        return eval.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
      }
    } catch (e) {
      return 'Error';
    }
  }

  String _evaluateModuloExpression(String expr) {
    try {
      List<String> parts = [];
      List<String> operators = [];
      int start = 0;
      for (int i = 0; i < expr.length; i++) {
        if (expr[i] == '+' || expr[i] == '-') {
          parts.add(expr.substring(start, i));
          operators.add(expr[i]);
          start = i + 1;
        }
      }
      parts.add(expr.substring(start));

      int total = 0;
      bool first = true;
      for (int i = 0; i < parts.length; i++) {
        int val = _evaluateModuloSimple(parts[i]);
        if (first) {
          total = val;
          first = false;
        } else {
          if (operators[i - 1] == '+') total += val;
          else if (operators[i - 1] == '-') total -= val;
        }
      }
      return total.toString();
    } catch (e) {
      return 'Error';
    }
  }

  int _evaluateModuloSimple(String expr) {
    expr = expr.replaceAll('x', '*').replaceAll('÷', '/');
    if (!expr.contains('%')) {
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double val = exp.evaluate(EvaluationType.REAL, cm);
      return val.toInt();
    }
    List<String> modParts = expr.split('%');
    int left = _evaluateModuloSimple(modParts[0]);
    for (int i = 1; i < modParts.length; i++) {
      int right = _evaluateModuloSimple(modParts[i]);
      if (right == 0) throw Exception('Modulo by zero');
      left = left % right;
    }
    return left;
  }

  List<List<String>> get buttons => [
    ['C', '%', 'DEL', '÷'],
    ['7', '8', '9', 'x'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['00', '0', '.', '='],
  ];

  @override
  Widget build(BuildContext context) {
    final Color opButton = Colors.blueGrey.shade500;
    final Color numButton = Colors.blueGrey.shade800;
    final Color mainBg = Colors.blueGrey.shade900;
    final Color delButton = Colors.blueGrey.shade300;
    final Color actionButton = Colors.blueGrey.shade200;

    return Scaffold(
      backgroundColor: mainBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey.shade800,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        input,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey.shade200,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 46,
                    child: Text(
                      result,
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: buttons.map((row) {
                  return Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: row.map((txt) {
                        Color bg;
                        Color fg;
                        bool big = false;
                        if (txt == 'C') {
                          bg = actionButton;
                          fg = Colors.blueGrey.shade900;
                        } else if (txt == 'DEL') {
                          bg = delButton;
                          fg = Colors.blueGrey.shade900;
                        } else if ('÷x-+'.contains(txt)) {
                          bg = opButton;
                          fg = Colors.white;
                        } else if (txt == '=') {
                          bg = Colors.blueGrey.shade100;
                          fg = Colors.blueGrey.shade800;
                          big = true;
                        } else if (txt == '%') {
                          bg = actionButton;
                          fg = Colors.blueGrey.shade900;
                        } else {
                          bg = numButton;
                          fg = Colors.white;
                        }

                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            child: ElevatedButton(
                              onPressed: () => buttonPressed(txt),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bg,
                                foregroundColor: fg,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                textStyle: TextStyle(
                                  fontSize: big ? 24 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                padding: EdgeInsets.zero,
                                shadowColor: Colors.blueGrey.shade700,
                              ),
                              child: Text(txt),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

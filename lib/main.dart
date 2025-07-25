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
      expression = expression.replaceAll('%', '/100');
      expression = expression.replaceAll('x', '*');
      expression = expression.replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
    } catch (e) {
      return 'Error';
    }
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
            // Input/result area at top, fixed height
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
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;
                  final buttonRows = buttons.length;
                  final buttonCols = buttons[0].length;
                  final spacing = 4.0;
                  final totalSpacingY = spacing * (buttonRows + 1);
                  final totalSpacingX = spacing * (buttonCols + 1);

                  final buttonHeight = ((height - totalSpacingY) / buttonRows) * 0.85;
                  final buttonWidth = ((width - totalSpacingX) / buttonCols) * 0.92;

                  return Padding(
                    padding: EdgeInsets.all(spacing),
                    child: Column(
                      children: List.generate(buttonRows, (i) {
                        return Row(
                          children: List.generate(buttonCols, (j) {
                            final txt = buttons[i][j];
                            Color? fg, bg;
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
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing / 2,
                                horizontal: spacing / 2,
                              ),
                              child: SizedBox(
                                width: buttonWidth.clamp(38.0, 90.0),
                                height: buttonHeight.clamp(42.0, 64.0),
                                child: ElevatedButton(
                                  onPressed: () => buttonPressed(txt),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bg ?? numButton,
                                    foregroundColor: fg ?? Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: big ? 22 : 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(txt),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

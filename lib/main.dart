import 'package:flutter/material.dart';
import 'printers.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Empire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PrinterGame(),
    );
  }
}

class PrinterGame extends StatefulWidget {
  const PrinterGame({super.key});

  @override
  _PrinterGameState createState() => _PrinterGameState();
}

class _PrinterGameState extends State<PrinterGame> {
  final GameLogic _gameLogic = GameLogic();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _gameLogic.incrementCoins(_gameLogic.coinsPerSecond.round());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Empire'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Coins: ${_gameLogic.coins}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text('Coins per second: ${_gameLogic.coinsPerSecond.toStringAsFixed(1)}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _gameLogic.incrementCoins(1);
              });
            },
            child: const Text('Print Coin'),
          ),
          const SizedBox(height: 20),
          ...List.generate(_gameLogic.printers.length, (index) {
            Printer printer = _gameLogic.printers[index];
            return ListTile(
              title: Text(printer.name),
              subtitle: Text('Owned: ${printer.quantity}'),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _gameLogic.buyPrinter(index);
                  });
                },
                child: Text('Buy (${printer.cost})'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
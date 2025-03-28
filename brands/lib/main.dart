import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:second_flutter_app/brand.dart';
import 'package:second_flutter_app/constants/companies.dart';
import 'package:second_flutter_app/models/company.dart';

void main() {
  // using const allows the widgets by the app
  // to be cached, improving performance.
  runApp(MyApp());
}

final String title = 'stratpoint';
final String description = 'Fast forward to the future';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentCompany = 0;
  Company get currentCompanyVal => Companies().companies[currentCompany];

  void _next() {
    setState(() {
      if (currentCompany == Companies().companies.length - 1) {
        debugPrint("Can't go next anymore!.");
        return;
      }
      currentCompany++;
    });
    displayCurrentCompany();
  }

  void _prev() {
    setState(() {
      if (currentCompany == 0) {
        debugPrint("Can't go back anymore!.");
        return;
      }
      currentCompany--;
    });
    displayCurrentCompany();
  }

  void _random() {
    setState(() {
      int newComp = Random().nextInt(Companies().companies.length - 1);
      currentCompany = newComp;
    });
    displayCurrentCompany();
  }

  void displayCurrentCompany() {
    debugPrint('Current company: $currentCompany');
    // TODO: Display the current company details
    inspect(Companies().companies[currentCompany]);
    Fluttertoast.showToast(msg: currentCompany.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Brand(company: currentCompanyVal),
                // Control buttons
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      currentCompany != 0 ? ElevatedButton(onPressed: _prev, child: Text('Prev')) : SizedBox(width: 80),
                      ElevatedButton(onPressed: _random, child: Text('Random')),
                      currentCompany != Companies().companies.length - 1 ? ElevatedButton(onPressed: _next, child: Text('Next')) : SizedBox(width: 80)
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}

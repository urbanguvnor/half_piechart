import 'package:flutter/material.dart';
import 'package:half_piechart/half_piechart.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height * 0.40,
          width: size.height * 0.32,
          child: GaugeChartFlat(
            percent: 60,
            color: Color.fromRGBO(74, 222, 121, 1),
            backgroundColor: Color.fromRGBO(122, 22, 22, 1),
            strokeWidth: 20,
            strokeCap: StrokeCap.round,
          ),
        ),
      ),
    );
  }
}

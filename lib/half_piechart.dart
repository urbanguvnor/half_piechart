// Reference - https://stackoverflow.com/a/79015415; Posted by Jakob Prossinger; Retrieved 2026-06-10, License - CC BY-SA 4.0

import 'dart:math';

import 'package:flutter/material.dart';

class GaugeChartFlat extends StatefulWidget {
  const GaugeChartFlat({
    super.key,
    required this.percent,
    required this.color,
    required this.backgroundColor,
    this.strokeWidth = 20,
    this.strokeCap = StrokeCap.butt,
  });

  /// percent is between 0 and 100
  final double percent;

  /// percentile arc color
  final Color color;

  /// background arc color
  final Color backgroundColor;
  final StrokeCap strokeCap;

  /// arc stroke width
  final double strokeWidth;

  @override
  State<GaugeChartFlat> createState() => _GaugeChartFlatState();
}

class _GaugeChartFlatState extends State<GaugeChartFlat>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animationPercentage;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Durations.long4);
    animationPercentage = Tween<double>(
      begin: 0.00,
      end: widget.percent / 100,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    controller.forward();
  }

  @override
  void didUpdateWidget(covariant GaugeChartFlat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      animationPercentage = Tween(
        begin: oldWidget.percent / 100,
        end: widget.percent / 100,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
      controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationPercentage,
      builder: (context, value) {
        return CustomPaint(
          painter: GaugePainter(
            percent: animationPercentage.value * 100,
            color: widget.color,
            backgroundColor: widget.backgroundColor,
            strokeWidth: widget.strokeWidth,
            strokeCap: widget.strokeCap,
          ),
        );
      },
    );
  }
}

class GaugePainter extends CustomPainter {
  GaugePainter({
    required this.percent,
    required this.color,
    required this.backgroundColor,
    this.strokeWidth = 20.0,
    this.strokeCap = StrokeCap.butt,
  });

  /// percent is between 0 and 100
  final double percent;

  /// percentile arc color
  final Color color;

  /// background arc color
  final Color backgroundColor;
  final StrokeCap strokeCap;

  /// arc stroke width
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // calculate center and radius of circle
    // subtract half strokeWidth so the arc stays within widget bounds
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth / 2;

    const startAngle = pi;
    const sweepAngle = pi;

    final fullArcPainter = Paint();
    fullArcPainter.color = backgroundColor;
    fullArcPainter.strokeWidth = strokeWidth;
    fullArcPainter.style = PaintingStyle.stroke;
    fullArcPainter.strokeCap = strokeCap;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fullArcPainter,
    );

    final percentPainter = Paint();
    percentPainter.color = color;
    percentPainter.strokeWidth = strokeWidth;
    percentPainter.style = PaintingStyle.stroke;
    percentPainter.strokeCap = strokeCap;

    // Calculate how much of the 180° arc to fill
    final percentAngle = percent >= 100
        ? sweepAngle
        : percent * sweepAngle / 100;

    // Draw percent arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      percentAngle,
      false,
      percentPainter,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.percent != percent;
  }
}

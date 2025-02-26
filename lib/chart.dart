import 'dart:math';

import 'package:flutter/material.dart';

class chart extends StatefulWidget {
  final List<String>focusTime;
  const chart({super.key,required this.focusTime});

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> focusTimeValues;
  late List<double> percentages;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    focusTimeValues = widget.focusTime.map((e) => (double.tryParse(e) ?? 0.0)).toList();
    double total = focusTimeValues.fold(0, (sum,e) => sum + e);

    percentages = total > 0 ? focusTimeValues.map((e) => e / total).toList() : List.filled(focusTimeValues.length, 0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: Center(
          child: Column(
            children: [
              Text(
                "每天專注時間",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(height:34,),
              Padding(
                padding: const EdgeInsets.all(32),
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(300, 200),
                        painter: BoardChart(percentages, _controller.value),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BoardChart extends CustomPainter {
  final List<double> percentages;
  final double animationValue;
  final List<Color> colors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple
  ];

  BoardChart(this.percentages, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    double startAngle = -pi / 2;
    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = 2 * pi * percentages[i] * animationValue;
      paint.color = colors[i % colors.length];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // 繪製指針
    final pointerPaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final pointerAngle = -pi / 2 + 2 * pi * animationValue;
    final pointerEnd = Offset(
      center.dx + radius * cos(pointerAngle),
      center.dy + radius * sin(pointerAngle),
    );

    canvas.drawLine(center, pointerEnd, pointerPaint);
  }

  @override
  bool shouldRepaint(BoardChart oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.percentages != percentages;
  }
}

class chart extends CustomPainter{


  @override
  void paint(Canvas canvas ,Size size){
    final
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/Timer_service.dart';

class TimerScreen extends StatelessWidget {
  final int focusT;
  final int restT;
  const TimerScreen({super.key,required this.focusT,required this.restT});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Consumer<TimerService>(
          builder: (context, timer, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomPaint(
                    size: Size(200, 200),
                    painter: ClockPainter(timer.seconds),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${timer.minutes.toString().padLeft(2, '0')}:${timer.seconds.toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.black, fontSize: 48),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          timer.resetTimer(focusT);
                        },
                        child: Icon(Icons.refresh,color: Colors.black,size: 30,),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5)
                        ),),
                      ElevatedButton(
                          onPressed: () {
                            timer.isRunning
                                ? timer.stopTimer()
                                : timer.startTimer();
                          },
                          child: Icon(timer.isRunning? Icons.stop : Icons.play_arrow,color: Colors.black,size: 30,),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                      ),),
                      ElevatedButton(
                        onPressed: () {
                          timer.resetTimer(restT);
                        },
                        child: Icon(Icons.skip_next,color: Colors.black,size: 30,),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5)
                        ),),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),

    );
  }
}

class ClockPainter extends CustomPainter {
  final int seconds;

  ClockPainter( this.seconds);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final paintHand = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // 畫出時鐘圓盤
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    // 計算秒針 & 分針的角度
    final secondAngle = (pi / 30) * seconds - (pi / 2);

    // 繪製秒針
    final secondHandEnd = Offset(
      center.dx + radius * 0.9 * cos(secondAngle),
      center.dy + radius * 0.9 * sin(secondAngle),
    );
    canvas.drawLine(center, secondHandEnd, paintHand);

  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return oldDelegate.seconds != seconds;
  }
}

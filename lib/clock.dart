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
      body: Stack(
        children:[ Center(
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
          DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.1,
              maxChildSize: 1.0,
              builder: (BuildContext context,ScrollController scrollController){
                // var taskProvider = Provider.of<task>(context);
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                      // itemCount: taskProvider.tasks.length,
                      itemBuilder: (context,index){
                    return Card();
                  }),
                );
              } )
      ]),
    );
  }
}

class ClockPainter extends CustomPainter {
  final int seconds;

  ClockPainter( this.seconds);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);  //時鐘位置
    final radius = size.width / 2; // 半徑圓心位置

    final paintCircle = Paint()  // 背景顏色
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()  //時鐘外框
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final paintHand = Paint() // 秒針
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // 畫出時鐘圓盤
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    // 計算秒針的角度
    final secondAngle = (pi / 30) * seconds - (pi / 2);

    // 繪製秒針
    final secondHandEnd = Offset(
      center.dx + radius * 0.9 * cos(secondAngle),
      center.dy + radius * 0.9 * sin(secondAngle),
    );
    canvas.drawLine(center, secondHandEnd, paintHand);

  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) { //重新計時
    return oldDelegate.seconds != seconds;
  }
}

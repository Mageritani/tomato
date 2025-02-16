import 'dart:async';

import 'package:flutter/material.dart';


class TimerService extends ChangeNotifier {
  static int _minutes = 5;
  int _seconds =0;
  Timer? _timer;
  bool _isRunning = false;

  int get minutes => _minutes;
  int get seconds =>_seconds;
  bool  get isRunning => _isRunning;

  void setTime(int Ftime){
    _minutes = Ftime;
    _seconds = 0;
    notifyListeners();
  }

  void startTimer(){
    if(_isRunning)return;
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1),(timer) {
      if(_seconds >= 0){
        _seconds--;

        if (_seconds == 0 && _minutes == 0) {
          stopTimer();
          // Vibration.vibrate(duration: 500);
        } else if(_seconds == -1) {
          _seconds = 59;
          _minutes--;
        }
        notifyListeners();
      }
    });
    notifyListeners();

  }

  void stopTimer() {
    if(_timer != null){
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
    }

  }

  void resetTimer(int restT){
    _timer?.cancel();
    _seconds = 0;
    _minutes = restT;
    _isRunning = false;
    notifyListeners();
  }

  void pauseTimer(){
    _timer?.cancel();
    _isRunning= false;
    notifyListeners();
  }


}



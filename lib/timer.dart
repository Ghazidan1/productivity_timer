import 'dart:async';

import 'package:productivity_timer/timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  int longBreak = 20;
  int shortBreak = 5;
  double _radius = 1;
  bool _isActive = true;
  late Timer timer;
  late Duration _time;
  late Duration _fullTime;
  int work = 30;
  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = (prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime'))!;
    shortBreak =
        (prefs.getInt('shortBreak') == null ? 5 : prefs.getInt('shortBreak'))!;
    longBreak =
        (prefs.getInt('longBreak') == null ? 20 : prefs.getInt('longBreak'))!;
  }

  bool isActivated() {
    return _isActive;
  }

  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  void startBreak(bool isShort) async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: isShort ? shortBreak : longBreak, seconds: 0);
    _fullTime = _time;
  }

  void startTimer() async {
    await readSettings();
    if (_time.inSeconds > 0) {
      _isActive = true;
    }
  }

  void stopTimer() {
    _isActive = false;
  }

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  Stream<TimerModel> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (_isActive) {
        _time = _time - const Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.isNegative) {
          _isActive = false;
        }
      }
      time = returnTime(_time);
      return TimerModel(time: time, percent: _radius);
    });
  }
}

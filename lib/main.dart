import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:productivity_timer/setting.dart';
import 'package:productivity_timer/timer.dart';
import 'package:productivity_timer/timermodel.dart';
import 'package:productivity_timer/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Work Timer',
        // theme: ThemeData(
        //   primarySwatch: Colors.blueGrey,
        // ).,
        theme: ThemeData.dark(),
        home: TimerHomePage());
  }
}

class TimerHomePage extends StatelessWidget {
  final CountDownTimer timer = CountDownTimer();
  void goToSetting(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = <PopupMenuItem<String>>[];
    menuItems.add(const PopupMenuItem(
      child: Text('Setting'),
      value: 'Settings',
    ));
    timer.startWork();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Work Timer'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              if (s == 'Settings') {
                goToSetting(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff009688),
                        text: "Work",
                        onPressed: () => timer.startWork())),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff607D8B),
                        text: "Short Break",
                        onPressed: () => timer.startBreak(true))),
                Expanded(
                    child: ProductivityButton(
                        color: Color(0xff455A64),
                        text: "Long Break",
                        onPressed: () => timer.startBreak(false))),
              ],
            ),
            StreamBuilder(
                initialData: '00:00',
                stream: timer.stream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  TimerModel time = (snapshot.data == '00:00')
                      ? TimerModel(time: '00:00', percent: 1)
                      : snapshot.data;
                  return Expanded(
                      child: CircularPercentIndicator(
                    radius: MediaQuery.of(context).size.width / 2.1,
                    lineWidth: 15.0,
                    percent: time.percent,
                    center: Text(time.time,
                        style: Theme.of(context).textTheme.headline4),
                    progressColor: timer.isActivated()
                        ? Color(0xff009688)
                        : Color(0xffcd1379),
                  ));
                }),
            Row(
              children: [
                Expanded(
                    child: ProductivityButton(
                  color: Color(0xff212121),
                  text: 'Stop',
                  onPressed: () => timer.stopTimer(),
                )),
                Expanded(
                    child: ProductivityButton(
                  color: Color(0xff009688),
                  text: 'Restart',
                  onPressed: () => timer.startTimer(),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

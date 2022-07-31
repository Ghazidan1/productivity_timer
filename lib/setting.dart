import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting'),
        ),
        body: const Settings());
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  late int workTime;
  late int shortBreak;
  late int longBreak;
  late SharedPreferences prefs;

  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;

  @override
  void initState() {
    // TODO: implement initState
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(fontSize: 24);
    return Container(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          Text(
            "Work",
            style: textStyle,
          ),
          Text(''),
          Text(''),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            setting: WORKTIME,
            callback: updateSettings,
          ),
          TextField(
            controller: txtWork,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            setting: WORKTIME,
            callback: updateSettings,
          ),
          Text(
            "Short",
            style: textStyle,
          ),
          Text(''),
          Text(''),
          SettingButton(
            color: Color(0xff455A64),
            text: "-",
            value: -1,
            setting: SHORTBREAK,
            callback: updateSettings,
          ),
          TextField(
            controller: txtShort,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            setting: SHORTBREAK,
            callback: updateSettings,
          ),
          Text(
            "Long",
            style: textStyle,
          ),
          Text(''),
          Text(''),
          SettingButton(
              color: Color(0xff455A64),
              text: "-",
              value: -1,
              setting: LONGBREAK,
              callback: updateSettings),
          TextField(
            controller: txtLong,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingButton(
            color: Color(0xff009688),
            text: "+",
            value: 1,
            setting: LONGBREAK,
            callback: updateSettings,
          ),
        ],
        padding: const EdgeInsets.all(20.0),
      ),
    );
  }

  readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
      workTime = 30;
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
      shortBreak = 5;
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
      longBreak = 20;
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSettings(String key, int value) {
    switch (key) {
      case WORKTIME:
        {
          int workTime = prefs.getInt(WORKTIME)!;
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK)!;
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtShort.text = short.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK)!;
          long += value;
          if (long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtLong.text = long.toString();
            });
          }
        }
        break;
    }
  }
}

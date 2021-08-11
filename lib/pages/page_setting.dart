import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_restaurant_app/utils/background_service.dart';
import 'package:submission_restaurant_app/utils/date_time_helper.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _switchValue;

  _getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _switchValue = prefs.getBool('notif');
    });
    if (prefs.getBool('notif') == null) {
      setState(() {
        _switchValue = false;
      });
    }
  }

  @override
  void initState() {
    _getShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Setting",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurant Notification',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('Enable Notification',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                  Switch(
                    value: _switchValue,
                    onChanged: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        prefs.setBool('notif', value);
                        _switchValue = value;
                      });
                      if (_switchValue) {
                        await AndroidAlarmManager.periodic(
                          Duration(hours: 24),
                          1,
                          BackgroundService.callback,
                          startAt: DateTimeHelper.format(),
                          exact: true,
                          wakeup: true,
                        );
                      } else {
                        await AndroidAlarmManager.cancel(1);
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

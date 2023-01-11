import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:evidencni_karton_voznje/services/theme_services.dart';
import 'package:evidencni_karton_voznje/ui/add_task_bar.dart';
import 'package:evidencni_karton_voznje/ui/theme.dart';
import 'package:evidencni_karton_voznje/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(), //tu pokličemo taskbar (oz. funkcijo ki prikaže taskbar), to nardimo zarad organiziranosti in lažje beremo kodo
            _addDateBar(), //tu pokličemo datebar
          ],
        )
      );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker( //tu je datepicker, za izbiro datuma (dneva)
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row( //prvi row
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //vse da na levo in desno stran
        children: [
          Container(
            //margin: const EdgeInsets.symmetric(horizontal: 20), //ker Column ne more sprejet margin,padding... smo ga wrapali v container in dodali margin

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //text se bo poravnal levo
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ), //prikaže datum v lepem formatu
                Text(
                    "Danes",
                    style: headingStyle
                ),
              ],
            ),
          ),
          MyButton(label: "+ Dodaj Uro", onTap: ()=>Get.to(AddTaskPage())) //ko kliknemo na gumb z Get.to se odpre nova stran
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0, //to je neka senca na headerju
      backgroundColor: context.theme.backgroundColor, //theme.dart
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme changed",
              body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme"
          );
          notifyHelper.scheduledNotification();//pokličemo tole da se notifikacija sproži x sec kasneje
        },
        child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined:Icons.nightlight_round,
        size: 20,
        color:Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar( //profilna slikica
          backgroundImage: AssetImage(
            "images/profile5.jpg"
          ),
        ),
        SizedBox(width: 20,)
      ],
    );
  }
}

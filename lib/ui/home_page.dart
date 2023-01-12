import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:evidencni_karton_voznje/services/theme_services.dart';
import 'package:evidencni_karton_voznje/ui/add_task_bar.dart';
import 'package:evidencni_karton_voznje/ui/theme.dart';
import 'package:evidencni_karton_voznje/ui/widgets/button.dart';
import 'package:evidencni_karton_voznje/ui/widgets/task_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controlers/task_controller.dart';
import '../models/task.dart';
import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController()); //to je za da lahko uporabljamo taskController v tej datoteki
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
        backgroundColor: context.theme.backgroundColor,
        body: Column(
          children: [
            _addTaskBar(), //tu pokličemo taskbar (oz. funkcijo ki prikaže taskbar), to nardimo zarad organiziranosti in lažje beremo kodo
            _addDateBar(), //tu pokličemo datebar
            SizedBox(height: 10),
            _showTasks(),
          ],
        )
      );
  }

  _showTasks() {
    return Expanded(
      child:Obx(() { //obx uporabljamo ker v task_controller.dart imamo taskList kot observable (obs)
        return ListView.builder( //listview.builder je boljši kot listview ker se ne naložijo vse taske naenkrat ampak se naložijo le tiste ki so vidne na zaslonu
            itemCount: _taskController.taskList.length, //število dodanih ur uporabnika
            
            itemBuilder: (_, index){ //itemBuilder je funkcija ki nam vrne widget
              print("Dolžina seznama: ${_taskController.taskList.length}");
              Task task = _taskController.taskList[index]; //task je en vnos ure uporabnika
              print(task.toJson());

              //scheduled Notifications
              //DateTime date = DateFormat.jm().parse(task.startTime.toString()); //pretvorimo čas v DateTime
              //print(date);
              //var myTime = DateFormat("HH:mm").format(date); //pretvorimo DateTime v string, znebimo se AM oz. PM
              //print("myTime: $myTime");
              notifyHelper.scheduledNotification(
                int.parse(task.startTime.toString().split(":")[0]), //ura
                int.parse(task.startTime.toString().split(":")[1]), //minuta
                task, //objekt (task)
              );
              //------------------------

              if(task.repeat == "Dnevno") { //če je ponavljanje dnevno pokažemo vnos ure uporabnika za vsak dan v kolendarju

                return AnimationConfiguration.staggeredList(

                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    _showBottomSheet(context, task); //tu pokličemo funkcijo _showBottomSheet
                                  },
                                  child:TaskTile(task)
                              )
                            ],
                          )
                      ),
                    )
                );

              }
              if(task.date==DateFormat.yMd().format(_selectedDate)) { //če je datum vnosa uporabnika enak datumu izbranemu v kolendarju pokažemo vnos uporabnika
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    _showBottomSheet(context, task); //tu pokličemo funkcijo _showBottomSheet
                                  },
                                  child:TaskTile(task)
                              )
                            ],
                          )
                      ),
                    )
                );
              } else { //če datum vnosa uporabnika ni enak datumu izbranemu v kolendarju ne pokažemo vnosa uporabnika, vrnemo prazen Container
                return Container();
              }
          });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted==1?                //tu je problem ker če je task completed ali ne je višina drugačna
          MediaQuery.of(context).size.height*0.24:  //če je task completed je višina 24% višine zaslona
          MediaQuery.of(context).size.height*0.32,  //če ni task completed je višina 32% višine zaslona
        color: Get.isDarkMode?darkGreyClr2:Colors.white,
        child: Column(
          children:[
            Container( //tole je mala črta za lepši izgled
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted==1
            ?Container() //če je task completed ne prikažemo ničesar
              : _bottomSheetButton( //če ni task completed prikažemo gumbke za urejanje in brisanje
                label:"Ura končana",
                onTap:(){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back(); //da zapremo
                },
              clr: primaryClr,
              context:context,
            ),

            _bottomSheetButton( //delete gumb
              label:"Odstrani Uro",
              onTap:(){
                _taskController.delete(task); //pokličemo delete funkcijo iz controllerja //task je pa dejansko "vnos" ki ga želimo odstraniti
                Get.back(); //da zapremo
              },
              clr: Colors.red[300]!,
              context:context,
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton( //delete gumb
              label:"Zapri",
              onTap:(){
                Get.back(); //da zapremo
              },
              clr: Colors.red[300]!,
              isClose:true,
              context:context,
            ),
            SizedBox(
              height: 10,
            )
          ]
        ),
      )
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context,
  }){
    return GestureDetector(
      onTap: onTap,
      child:Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,
        ),

        child: Center(
          child: Text(
            label,
            style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white,), //če je gumb close vzamemo titleStyle temo pa če ni pa vse prekopiramo samo barvo spremenimo v belo
          ),
        ),
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
        dateTextStyle: GoogleFonts.rubik(
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
        monthTextStyle: GoogleFonts.rubik(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() { //ko izberemo datum ga shranimo v _selectedDate
            _selectedDate = date;
          });
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
          MyButton(label: "+ Dodaj Uro", onTap: () async{ //ko kliknemo na gumb z Get.to se odpre nova stran
            await Get.to(AddTaskPage());
            _taskController.getTasks(); //tu čakamo da se uporabnik vrne na home page in ponovno pokličemo getTasks da se nam osveži
          })
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
              title: "Tema spremenjena",
              body: Get.isDarkMode?"Aktiviran Light Theme":"Aktiviran Dark Theme"
          );
          //notifyHelper.scheduledNotification(); //pokličemo tole da se notifikacija sproži x sec kasneje
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

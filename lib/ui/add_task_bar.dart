import 'package:evidencni_karton_voznje/controlers/task_controller.dart';
import 'package:evidencni_karton_voznje/ui/theme.dart';
import 'package:evidencni_karton_voznje/ui/widgets/button.dart';
import 'package:evidencni_karton_voznje/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController()); //tu naredimo task controller, da lahko uporabljamo funkcije iz task controllerja
  final TextEditingController _titleController = TextEditingController(); //kontrolerja za shranjevanje podatkov
  final TextEditingController _noteController = TextEditingController(); //kontrolerja za shranjevanje podatkov
  DateTime _selectedDate = DateTime.now();
  String _endTime = "16:30";
  String _startTime = DateFormat("hh:mm").format(DateTime.now()).toString();
  int _selectedRemind = 30; // tole je za reminder
  List<int> remindList=[ //lista minut za reminder
    15,
    30,
    45,
    60,
    120
  ];

  String _selectedRepeat = "Nikoli"; // tole je za reminder
  List<String> repeatList=[ //lista minut za reminder
    "Nikoli",
    "Dnevno",
    "Tedensko",
    "Mesečno",
  ];

  int _selectedColor=0; //tole je za barve (da vemo kiro smo zbrali, smo tu definirali integer z vrednostjo 0)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView( //tu smo dodali SingleChildScrollView, da se nam taskbar ne prekriva z tipkovnico
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dodaj uro",
                style: headingStyle,
              ),
              //tu spodi so input polja
              MyInputField(title: "Številka ure", hint: "Vnesi številko ure", controller: _titleController,),
              MyInputField(title: "Opis", hint: "Vnesi lokacijo ali drugo...", controller: _noteController,),
              MyInputField(title: "Datum", hint: DateFormat.yMMMMEEEEd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print("Serbus");
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime:true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      )
                  ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                        title: "Konec",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime:false);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        )
                    ),
                  ),
                ],
              ), //tole je input za datum
              MyInputField(title: "Opomnik", hint: "$_selectedRemind minut prej",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    items: remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>( //returnamo DropdownMenuItem kot string
                        value: value.toString(),
                        child:Text(value.toString())
                      );
                    }).toList(), //remindList sprejma liste oz. arraye
                  ),
              ),
              MyInputField(title: "Ponovi", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: repeatList.map<DropdownMenuItem<String>>((String? value) { // repeatList je lista stringov, ki jo mamo zgori napisano
                    return DropdownMenuItem<String>( //returnamo DropdownMenuItem kot string
                        value: value,
                        child:Text(value!, style: TextStyle(color: Colors.grey),)
                    );
                  }).toList(), //remindList sprejma liste oz. arraye
                ),
              ),
              SizedBox(height: 18,), //tole je za razmik med zgornjim inputom in spodnjimi barvami
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Dodaj uro", onTap: ()=>_validateData())
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  _validateData() { //preden karkoli shranimo v bazo bomo preverili podatke
    if(_titleController.text.isNotEmpty&& _noteController.text.isNotEmpty) {
      //add to database
      _addTaskToDb();
      Get.back();//gremo nazaj na prejšnjo stran
    } else if(_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Obvezno", "Vsa polja so obvezna!",
        snackPosition: SnackPosition.BOTTOM,//prikaže se od spodaj
        backgroundColor: Get.isDarkMode?Colors.grey[200]:Colors.grey[900], //barva ozadja
        colorText: Colors.red,
        icon: const Icon(Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addTaskToDb() async {
    if(_titleController.text.isNumericOnly)  {  //če je vneseno samo število, pred število napišemo "Ura"
      _titleController.text = "Ura ${_titleController.text}";
    }
    int value = await _taskController.addTask( //v int value shranimo id vnosa
        task: Task( //pošljemo podatke v naš model
          note: " ${_noteController.text}",
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print("My id is "+"$value");
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Barva",
          style: titleStyle,
        ),
        SizedBox(height: 8.0,),
        Wrap( //ker hočemo barve prikazati horizontalno uporabimo Wrap widget
          children: List<Widget>.generate( //List<Widget>.generate je kot for loop, ki nam generira listo widgetov
            3,
                (int index) {
              return GestureDetector( //da lahka kliknemo na barvo smp padding wrappali v GestureDetector, ki ima onTap funkcijo
                onTap: () {
                  setState(() { //set state spremeni na klik
                    _selectedColor=index;
                  });
                },
                child: Padding( //tu smo dodali padding, da je bolj narazen
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr, //tu mam if statement, da se mi barva spremeni (če je index 0 je primaryClr, če je index 1 je pink če ne pa je yellow)
                    child: _selectedColor==index?Icon(Icons.done, //če se _selectedColor in index ujemata, se nam prikaže ikona, če ne pa spodaj vrnemo samo prazen Container()
                      color: Colors.white,
                      size: 18,
                    ):Container(),
                  ),
                ),
              );
            },
          ),
        )

      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0, //to je neka senca na headerju
      backgroundColor: context.theme.backgroundColor, //theme.dart
      leading: GestureDetector(
        onTap: (){
          Get.back(); //to je za nazaj na gumbu
        },
        child: Icon(Icons.arrow_back_ios,
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
  
  _getDateFromUser() async { //tole je funkcija za dobit datum od uporabnika od koder bo izbran datum
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(DateTime.now().year + 20),
    );

    if(_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("Datum ni bil izbran");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async { //tole je funkcija za dobit čas od uporabnika od koder bo izbran čas za začetek in konec
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null){
      print("Time canceled");
    } else if(isStartTime==true) {
      setState(() { //set state je da se vpisana ura shrani oziroma dejansko izpiše
        _startTime=_formatedTime;
      });
    } else if(isStartTime==false) {
      setState(() {
        _endTime=_formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        //_startTime --> 10:30
          hour: int.parse(_startTime.split(":")[0]), //tu splitamo uro
          minute: int.parse(_startTime.split(":")[1]),
      ),
    );
  }
}


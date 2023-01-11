import 'package:evidencni_karton_voznje/ui/theme.dart';
import 'package:evidencni_karton_voznje/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "6:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5; // tole je za reminder
  List<int> remindList=[ //lista minut za reminder
    15,
    30,
    45,
    60,
    120
  ];
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
              MyInputField(title: "Title", hint: "Enter your title",),
              MyInputField(title: "Note", hint: "Enter your note",),
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
            ],
          ),
        ),
      )
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
        //_startTime --> 10:30 AM
          hour: int.parse(_startTime.split(":")[0]), //tu splitamo uro
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}


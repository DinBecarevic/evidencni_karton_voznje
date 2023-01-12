import 'package:evidencni_karton_voznje/db/db_helper.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

import '../models/task.dart';

class TaskController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs; //to je list dodanih ur uporabnika, ki ga bomo prikazovali na domači strani

  Future<int> addTask({Task? task}) async { //int je zato ker v db_helperju v 38 vrstici funkcija insert vrača int
    return await DBHelper.insert(task); //pokličemo funkcijo iz db_helperja (await je zato ker lahko traja nekaj časa)
  }

  //get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query(); //pokličemo funkcijo iz db_helperja
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList()); //to je list dodanih ur uporabnika, ki ga bomo prikazovali na domači strani
    // assignAll -> Replaces all existing items of this list with items
  }

  void delete(Task task) { //funkcija za brisanje vnosov uporabnika
    DBHelper.delete(task); //dobimo za katero se gre in pošljemo v DBHelper
  }
}
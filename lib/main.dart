import 'package:evidencni_karton_voznje/db/db_helper.dart';
import 'package:evidencni_karton_voznje/services/theme_services.dart';
import 'package:evidencni_karton_voznje/ui/home_page.dart';
import 'package:evidencni_karton_voznje/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb(); //pokkličemo za ustvarit bazo (samo prvič ko inštaliramo aplikacijo)
  await GetStorage.init(); //zaradi GetStorage ki spreminja temo in shrani temo moramo tu dat await ter async cel main()
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,

      home: HomePage()
    );
  }
}


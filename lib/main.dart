
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:polaris_survey_app/core/connectivity_manager.dart';
import 'package:polaris_survey_app/core/database/database_manager.dart';
import 'package:polaris_survey_app/core/db_sync/survey_form_db_sync.dart';
import 'package:polaris_survey_app/core/di_entry.dart';


import 'features/survey_form/presentation/survey_page.dart';

void main() async{
  runZonedGuarded(() async{
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    await getIt<ConnectivityManager>().init();
    await getIt<IDatabaseManager<Store>>().init();
    getIt<SurveyFormDbSync>().init();
    runApp(const MyApp());
  }, (error, stack) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polaris Survey',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xff47C897),
          background: Colors.white,
          onError: Colors.white,
          error: Colors.red.shade400,
          errorContainer: Colors.red.shade400,
          onBackground: const Color(0xff474747),
          outline: const Color(0xffE0E0E0),
          onPrimary: Colors.white,
          secondary: const Color(0xffE0E0E0),
          onSecondary: const Color(0xffA9A9A9),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          clipBehavior: Clip.hardEdge
        ),
        useMaterial3: true,
      ),
      home: const SurveyPage(),
    );
  }
}

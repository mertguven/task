import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trellocards/service/database_service.dart';
import 'package:trellocards/start_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff3497b1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StartPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/style/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000), // transparent
      statusBarIconBrightness: Brightness.dark, // Android icons
      statusBarBrightness: Brightness.light, // iOS text
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lumi',
      theme: buildLumiTheme(),
      routes: appRoutes,
      initialRoute: Routes.entry,
      debugShowCheckedModeBanner: false,
    );
  }
}

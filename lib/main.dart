import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumi/routes/routes.dart';
import 'package:lumi/style/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0x00000000),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

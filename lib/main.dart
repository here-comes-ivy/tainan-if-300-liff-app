import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service_firebase/firebase_options.dart';
import 'splashScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (value) => print('Firebase initialized.'),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "「一府 x iF」遊城活動打卡",
        theme: ThemeData(
          fontFamily: 'NotoSansTC',
          primaryColor: const Color(0XFFdabb4c),

          //useMaterial3: true,
          scaffoldBackgroundColor: Colors.white, // 修正顏色值格式
          //scaffoldBackgroundColor: const Color.fromRGBO(242, 239, 233, 1),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFF507166), // 修正顏色值格式
                displayColor: const Color(0xFF507166), // 修正顏色值格式
              ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            elevation: 10,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: const Color(0xFF507166),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          splashColor: const Color(0xFF507166),
          // colorScheme: ColorScheme.fromSeed(
          //   seedColor: Colors.white,
          // ),
        ),
        home: SplashScreen());
  }
}

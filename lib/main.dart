import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_plan/screens/questionnaire_screen.dart';
import 'package:soul_plan/screens/splash_screen.dart';
import 'package:soul_plan/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:soul_plan/services/gemini_service.dart';
import 'package:soul_plan/services/foursquare_service.dart';
import 'package:soul_plan/screens/anniversary_date_screen.dart';
import 'package:soul_plan/screens/birthday_date_screen.dart';
import 'package:soul_plan/screens/christmas_dates_screen.dart';
import 'package:soul_plan/screens/new_year_date_screen.dart';
import 'package:soul_plan/screens/valentines_date_screen.dart';
import 'package:soul_plan/screens/favorite_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Initialize environment variables
  await dotenv.load(fileName: '.env');

  // Initialize services
  final geminiService = GeminiService();
  final foursquareService = FoursquareService();

  runApp(MyApp(
    initialRoute: '/splash',
    isFirstTime: true,
    geminiService: geminiService,
    foursquareService: foursquareService,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool isFirstTime;
  final GeminiService geminiService;
  final FoursquareService foursquareService;

  const MyApp({
    Key? key,
    required this.initialRoute,
    required this.isFirstTime,
    required this.geminiService,
    required this.foursquareService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GeminiService>.value(value: geminiService),
        Provider<FoursquareService>.value(value: foursquareService),
      ],
      child: MaterialApp(
        title: 'AI Date Planner',
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: initialRoute,
        routes: {
          '/splash': (context) => SplashScreen(),
          '/main': (context) => MainScreen(),
          '/questionnaire': (context) => QuestionnaireScreen(),
          '/anniversary': (context) => AnniversaryDateScreen(),
          '/birthday': (context) => BirthdayDateScreen(),
          '/christmas': (context) => ChristmasDateScreen(),
          '/new_year': (context) => NewYearDateScreen(),
          '/valentines': (context) => ValentinesDateScreen(),
          '/favorites': (context) => FavoriteScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

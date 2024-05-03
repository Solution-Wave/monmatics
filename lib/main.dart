import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'hiveadapters/callAdapter.dart';
import 'hiveadapters/conatctAdapter.dart';
import 'hiveadapters/customerAdapter.dart';
import 'hiveadapters/dropdownAdapter.dart';
import 'hiveadapters/leadAdapter.dart';
import 'hiveadapters/notesAdapter.dart';
import 'hiveadapters/oppAdapter.dart';
import 'hiveadapters/taskAdapter.dart';
import 'hiveadapters/userAdapter.dart';
import 'splashScreen.dart';
import 'utils/colors.dart';
import 'utils/themes.dart';
import 'utils/urlprovider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(LeadAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(CallsAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(OpportunityAdapter());
  Hive.registerAdapter(DropdownOptionsAdapter());
  runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) =>const MyApp()
  // ),
    ChangeNotifierProvider(
      create: (_) => UrlProvider(), // Provide the UrlProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context)=> context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  /// 1) our themeMode "state" field
  ThemeMode _themeMode = ThemeMode.light;
  Key appKey = UniqueKey();

  void restartApp() {
    setState(() {
      appKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: appKey,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: monmaticsAppBar,
        useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: primaryColor
          )
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          surface: bgColorForDarkThemeWidgets,

        ),

      ),
      themeMode: _themeMode, // 2) ← ← ← use "state" field here //////////////
      home: splashScreen(onRestart: restartApp),
    );
  }

  /// 3) Call this to change theme from any context using "of" accessor
  /// e.g.:
  // / MyApp.of(context).changeTheme(ThemeMode.dark);
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}



// Note Hive Id 0
// Customer Hive Id 1
// Task Hive Id 2
// Lead Hive Id 3
// Contact Hive Id 4
// Call Hive Id 5
// Users Hive Id 6
// Opportunity Hive Id 7
// Dropdown Hive Id 8

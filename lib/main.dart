import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/launcher_page.dart';
import 'pages/home_page.dart';
import 'pages/add_note_page.dart';
import 'pages/edit_note_page.dart';
import 'pages/calculator_page.dart';
import 'pages/stopwatch_page.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/note_provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/stopwatch_provider.dart';
import 'pages/admin_access.dart';
import 'providers/admin_provider.dart';
import 'pages/map_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => StopwatchProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes App',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/launcher': (context) => const LauncherPage(),
            '/home': (context) => const HomePage(),
            '/add_note': (context) => const AddNotePage(),
            '/calculator': (context) => const CalculatorPage(),
            '/stopwatch': (context) => const StopwatchPage(),
            '/admin_access': (context)=> const AdminUserListPage(),
            '/map':(context)=> const MapPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/edit_note') {
              final docId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => EditNotePage(docId: docId),
              );
            }
            return null;
          },
        );
      },
    );
  }
}

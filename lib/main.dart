import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/screens/main_screen.dart';
import 'src/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);
  
  runApp(MoodMateApp(storage: storage));
}

class MoodMateApp extends StatelessWidget {
  final StorageService storage;

  const MoodMateApp({
    super.key,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF6750A4); // Material 3 Default Purple

    return MaterialApp(
      title: 'MoodMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 3,
          backgroundColor: Colors.white,
          indicatorColor: seedColor.withOpacity(0.1),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              );
            }
            return const TextStyle(fontSize: 12);
          }),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: const CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 3,
          backgroundColor: Colors.black12,
          indicatorColor: seedColor.withOpacity(0.2),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              );
            }
            return const TextStyle(fontSize: 12);
          }),
        ),
      ),
      home: MainScreen(storage: storage),
    );
  }
}

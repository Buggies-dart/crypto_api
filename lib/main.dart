import 'package:crypto_app/Pages/bottomnavbar.dart';
import 'package:crypto_app/Theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child:  MyApp()));
}
final themeProvider =ChangeNotifierProvider<ThemeNotifier>((ref) {
  final themeNotifier = ThemeNotifier();
  themeNotifier.loadTheme(); 
  return themeNotifier;
});
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}
 ThemeMode themeMode = ThemeMode.light;
class _MyAppState extends ConsumerState<MyApp> {
  
  @override
  Widget build(BuildContext context) {

    final themeToggle = ref.watch(themeProvider);
    return  MaterialApp(
   debugShowCheckedModeBanner: false,
  title: 'Crypto App',
darkTheme: Palette.darkTheme,
theme: Palette.lighTheme,
themeMode: themeToggle.themeMode,
 home:  const CustomBottomNavBar(),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  // Toggle between light and dark themes
  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Toggle and save the theme mode
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      prefs.setBool('isDarkTheme', true);
    } else {
      themeMode = ThemeMode.light;
      prefs.setBool('isDarkTheme', false);
    }

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Load the saved theme mode
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;

    themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;

    notifyListeners(); // Notify listeners to apply the loaded theme
  }
}
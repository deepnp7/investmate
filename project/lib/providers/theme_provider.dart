import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  ThemeProvider() {
    _loadThemePreference();
  }
  
  // Load theme preference from shared preferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_mode');
    
    if (savedTheme != null) {
      _themeMode = _getThemeMode(savedTheme);
      notifyListeners();
    }
  }
  
  // Save theme preference to shared preferences
  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_mode', mode.toString());
  }
  
  // Convert string to ThemeMode
  ThemeMode _getThemeMode(String themeModeString) {
    switch (themeModeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
  
  // Toggle between light and dark mode
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    _saveThemePreference(_themeMode);
    notifyListeners();
  }
  
  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemePreference(mode);
    notifyListeners();
  }
  
  // Check if theme is dark
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String chatBoxName = 'chat_history';
  static const String settingsBoxName = 'settings';
  static const String onboardingKey = 'onboarding_seen';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(chatBoxName);
    await Hive.openBox(settingsBoxName);
  }

  // Onboarding
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
  }

  // Chat History
  List<dynamic> getChatHistory() {
    final box = Hive.box(chatBoxName);
    return box.values.toList();
  }

  Future<void> saveChatMessage(Map<String, dynamic> message) async {
    final box = Hive.box(chatBoxName);
    await box.add(message);
  }

  Future<void> clearChatHistory() async {
    final box = Hive.box(chatBoxName);
    await box.clear();
  }

  // Generic Settings (Dark mode, etc.)
  Future<void> setSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBoxName);
    await box.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    final box = Hive.box(settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }
}

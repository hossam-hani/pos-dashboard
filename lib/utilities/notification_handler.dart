import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class NotificationHandler extends ChangeNotifier {
  static NotificationHandler get(BuildContext context) => context.read<NotificationHandler>();

  int _currentNotificationCount;

  int get currentNotificationCount => _currentNotificationCount;

  void addNewNotificationMessage() async {
    final currentCount = await _addNewNotificationMessage();
    _currentNotificationCount = currentCount;
    notifyListeners();
  }

  void clearNotificationMessagesNumber() async {
    await _clearNotificationMessagesNumber();
    _currentNotificationCount = null;
    notifyListeners();
  }

  static const _NOTIFICATION_KEY = '__NOTIFICATION_KEY__';

  Future<int> _addNewNotificationMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final prevValue = prefs.getInt(_NOTIFICATION_KEY) ?? 0;
    var newValue = prevValue + 1;
    await prefs.setInt(_NOTIFICATION_KEY, newValue);
    return newValue;
  }

  Future<void> _clearNotificationMessagesNumber() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_NOTIFICATION_KEY);
    return Future<void>.value();
  }
}

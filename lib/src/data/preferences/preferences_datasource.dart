import 'package:shared_preferences/shared_preferences.dart';

final class PreferencesDatasource {
  static const _firstNameKey = 'firstName';
  static const _lastNameKey = 'lastName';
  static const _loggedKey = 'logged';

  Future<void> saveUser({
    required String firstName,
    required String lastName,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_firstNameKey, firstName);
    await preferences.setString(_lastNameKey, lastName);
    await preferences.setBool(_loggedKey, true);
  }

  Future<bool> isLogged() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_loggedKey) ?? false;
  }

  Future<String> getFullName() async {
    final preferences = await SharedPreferences.getInstance();

    final firstName = preferences.getString(_firstNameKey) ?? '';
    final lastName = preferences.getString(_lastNameKey) ?? '';

    return '$firstName $lastName'.trim();
  }

  Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_firstNameKey);
    await preferences.remove(_lastNameKey);
    await preferences.remove(_loggedKey);
  }
}

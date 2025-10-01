import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var appName = 'Clove'.obs;
  SharedPreferences? _prefs;
  static const String _appNameKey = 'app_name';

  @override
  void onInit() {
    super.onInit();
    loadSavedName();
  }

  Future<void> loadSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_appNameKey);
    if (savedName != null) {
      appName.value = savedName;
    }
  }
}

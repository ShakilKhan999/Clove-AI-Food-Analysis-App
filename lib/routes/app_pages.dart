import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/chatbot_view.dart';
import '../controllers/home_controller.dart';
import '../controllers/chatbot_controller.dart';

class AppPages {
  static const INITIAL = '/home';

  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: '/chatbot',
      page: () => ChatbotView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatbotController>(() => ChatbotController());
      }),
    ),
  ];
}
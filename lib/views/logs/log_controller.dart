import 'dart:developer';

import 'package:get/get.dart';

import '../../auth/controller/auth_serviece.dart';
import 'log_repo.dart';

class LogController extends GetxController{
  var allLogs=[].obs;
  var isLoading=false.obs;
  @override
  void onInit() {
    listenToLogs(AuthService().auth.currentUser!.uid);
    super.onInit();
  }

  void listenToLogs(String authUserId) async{
    isLoading.value=true;
      LogRepo().getRealtimeLogs(authUserId).listen((logs) {
        allLogs.value=logs;
      log('Received logs update: ${allLogs.length}');
      for (var logs in logs) {
        log('Log Time: ${logs.logTime}, Message: ${logs.foodData??"NUll"}');
      }
    });
      await Future.delayed(Duration(seconds: 2));
    isLoading.value=false;
  }

}
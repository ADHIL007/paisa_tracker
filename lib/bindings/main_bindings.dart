import 'package:get/get.dart';
import 'package:paisa_tracker/Screens/transactions/transaction-controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionController());
  }
}

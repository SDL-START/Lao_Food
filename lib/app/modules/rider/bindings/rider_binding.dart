import 'package:get/get.dart';
import '../controllers/rider_home_controller.dart';

class RiderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiderHomeController>(() => RiderHomeController());
  }
}

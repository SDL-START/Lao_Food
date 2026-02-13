import 'package:get/get.dart';
import '../controllers/customer_home_controller.dart';
import '../controllers/cart_controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerHomeController>(() => CustomerHomeController());
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
  }
}

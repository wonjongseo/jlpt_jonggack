import 'package:get/get.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => MyWordNewController(), fenix: true);
    Get.put(() {
      bool isManualSavedWordPage = Get.arguments as bool;
      NewMyWordController(isManualSavedWordPage);
    }, permanent: true);
  }
}

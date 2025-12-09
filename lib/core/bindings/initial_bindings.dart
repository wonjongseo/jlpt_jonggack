import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/controller/tts_controller.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/edit_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/setting/controller/font_size_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FSController(), permanent: true);
    Get.lazyPut(() => TtsController(), fenix: true);
    Get.lazyPut(() => MyBookController(), fenix: true);
    Get.lazyPut(() => EditWordController(), fenix: true);

    Get.lazyPut(() {
      return NewMyWordController(Get.find());
    }, fenix: true);
  }
}

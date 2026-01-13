import 'package:get/get.dart';
import 'package:jlpt_jonggack/config/enums.dart';
import 'package:jlpt_jonggack/core/analytics/analytics_service.dart';
import 'package:jlpt_jonggack/features/basic/hiragana/screens/hiragana_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/new_jlpt_screen/screens/new_jlpt_screen.dart';
import 'package:jlpt_jonggack/features/my_book/controller/my_book_controller.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';

class BookController extends GetxController {
  // final BookType bookType;
  BookController(BookType bookType) : _bookType = bookType.obs;

  final Rx<BookType> _bookType;

  set bookType(BookType bookType) {
    _bookType.value = bookType;
    _curIdx.value = LocalReposotiry.getProgress(_bookType.value.name);
  }

  BookType get bookType => _bookType.value;

  final _curIdx = 0.obs;
  int get curIdx => _curIdx.value;

  @override
  void onInit() {
    _curIdx.value = LocalReposotiry.getProgress(_bookType.value.name);
    super.onInit();
  }

  void onPageChanged(int index) {
    _curIdx.value = index;
    LocalReposotiry.setProgress(_bookType.value.name, index);
  }

  void goToBookScreen(int index) {
    AnalyticsService.I.logEvent(
      'wordbook_select',
      parameters: {
        'selected_book': _bookType.value.name,
        'selected_book_index': index,
      },
    );

    switch (_bookType.value) {
      case BookType.basic:
        final label = index == 0 ? 'hiragana' : 'katakana';
        Get.toNamed(BasicScreen.name, arguments: label);
        break;
      case BookType.jlpt:
        Get.toNamed(JlptScreen.name, arguments: index);
        // Get.toNamed(NewJlptScreen.name, arguments: index);
        break;
      case BookType.my:
        MyBookController.to.tapBook(index);
        break;
    }
  }
}

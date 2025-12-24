import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/screens/widgets/edit_book_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';

class MyBookController extends GetxController {
  static MyBookController get to => Get.find<MyBookController>();
  final books = <Book>[].obs;

  final bookRepo = Get.find<HiveRepository<Book>>();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<Book> _selectedBook = Rxn<Book>();
  Book? get selectedBook => _selectedBook.value;

  void tapBook(Book book) {
    _selectedBook.value = book;
    Get.toNamed(NewMyWordScreen.name);
  }

  void addMyWord(MyWord myWord) {
    if (selectedBook == null) return;

    selectedBook!.mywords.add(myWord);
    _updateBook(selectedBook!);
    loadBook(selectedBook!);
  }

  Future<int> bulkHandleMyWords(
    List<MyWord> myWords, {
    bool isAdd = true,
  }) async {
    int savedCount = 0;

    for (var word in myWords) {
      if (isAdd) {
        if (!selectedBook!.mywords.contains(word)) {
          selectedBook!.mywords.add(word);
          savedCount++;
        }
      } else {
        if (selectedBook!.mywords.contains(word)) {
          selectedBook!.mywords.remove(word);
          savedCount++;
        }
      }
    }

    if (savedCount != 0) {
      _updateBook(selectedBook!);
      loadBooks();
    }
    return savedCount;
  }

  void deleteMyWord(MyWord myWord) {
    if (selectedBook == null) return;
    selectedBook!.mywords.remove(myWord);

    _updateBook(selectedBook!);
    loadBook(selectedBook!);
  }

  void updateMyWord(MyWord myWord) {
    int index = selectedBook!.mywords.indexWhere((item) => item == myWord);
    if (index != -1) {
      selectedBook!.mywords[index] = myWord;
    }
    _updateBook(selectedBook!);
    loadBook(selectedBook!);
  }

  Future<void> _updateBook(Book book) async {
    await bookRepo.put(book.id, book);
  }

  void _deleteBook(Book book) async {
    await bookRepo.delete(book.id);
    Get.back();
    SnackBarHelper.showSuccessSnackBar(
      '${book.title}${AppString.doneDelete.tr}',
    );

    loadBooks();
  }

  void _editBook(Map<String, dynamic> result) {
    bool isEditMode = result['isEditMode'];
    Book newBook;

    String title = result['title'];
    String description = result['description'];

    if (isEditMode) {
      _selectedBook.value = _selectedBook.value!.copyWith(
        title: title,
        description: description,
      );
      newBook = _selectedBook.value!;
    } else {
      newBook = Book(
        title: title,
        description: description,
        bookNum: books.length + 1,
      );
    }

    _updateBook(newBook);
    loadBooks();
    SnackBarHelper.showSuccessSnackBar(
      isEditMode
          ? '${newBook.title}${AppString.doneUpdate.tr}'
          : '${newBook.title}${AppString.doneCreate.tr}',
    );
  }

  void goToEditBook({Book? book}) async {
    try {
      final result = await Get.toNamed(EditBookScreen.name, arguments: book);

      if (result == null) return;

      if (result['isDelete']) {
        _deleteBook(book!);
      } else {
        _editBook(result);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString(), isLog: true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBooks();
  }

  void loadBook(Book book) {
    //  final result = bookRepo.get(book.id)!;
    books[book.bookNum - 1] = book;
  }

  void loadBooks() {
    try {
      _isLoading.value = true;
      final result = bookRepo.getAll();
      books.assignAll(result);
      if (_selectedBook.value == null) {
        _selectedBook.value = books[0];
      }
      // NewMyWordController.to.loadMyWords();
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString(), isLog: true);
    } finally {
      _isLoading.value = false;
    }
  }

  bool isSavedInJgBook(MyWord myWord) {
    return books[0].mywords.contains(myWord);
  }
}

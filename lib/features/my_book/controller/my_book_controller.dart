import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/common/widget/dialog/delete_category_dialog.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/my_book/screens/widgets/edit_book_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/controllers/new_my_word_controller.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_screen.dart';
import 'package:jlpt_jonggack/model/book.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';
import 'package:jlpt_jonggack/model/my_word.dart';
import 'package:jlpt_jonggack/repository/hive_repository.dart';

class MyBookController extends GetxController {
  static MyBookController get to => Get.find<MyBookController>();
  final books = <Book>[].obs;

  final bookRepo = Get.find<HiveRepository<Book>>();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<Book> _selectedBook = Rxn<Book>();

  void setJgBook() {
    _selectedBook.value = books[0];
  }

  Rxn<Book> get selectedBookRx => _selectedBook;

  void addCategory(String name) {
    final book = _selectedBook.value!;

    final cats = book.categories ?? [];
    final isExist = cats.firstWhereOrNull((cat) => cat.name == name);
    if (isExist != null) {
      SnackBarHelper.showErrorSnackBar('$name${AppString.isAlreadyExists.tr}');
      return;
    }
    final newCats = List<BookCategory>.from(book.categories ?? []);
    final newCat = BookCategory(name);
    newCats.add(newCat);

    _selectedBook.value = book.copyWith(
      selectedCategory: newCat,
      categories: newCats,
    );

    bookRepo.put(_selectedBook.value!.id, _selectedBook.value!);

    SnackBarHelper.showSuccessSnackBar(
      '${AppString.category.tr}${AppString.doneCreate.tr}',
      duration: Duration(seconds: 2),
    );
    loadBooks();
  }

  void deleteCategory(String id) async {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
      return;
    }

    Get.back();

    if (_selectedBook.value == null) return;
    final category = (_selectedBook.value!.categories ?? []).firstWhere(
      (cat) => cat.id == id,
    );
    final targets = _selectedBook.value!.mywords
        .where((w) => w.category?.id == category.id)
        .toList(growable: false);

    var isDelete = true;
    if (targets.isNotEmpty) {
      isDelete = await Get.dialog(
        DeleteCategoryDialog(categoryName: category.name),
      );
    }

    if (isDelete) {
      for (var word in targets) {
        if (word.category?.id == category.id) {
          await NewMyWordController.to.deleteWord(word);
        }
      }
      final newCats = List<BookCategory>.from(
        _selectedBook.value!.categories ?? [],
      );

      int deleteCategoryIdx = -1;
      for (var i = 0; i < newCats.length; i++) {
        final newCat = newCats[i];
        if (newCat.id == category.id) {
          deleteCategoryIdx = i;
        }
      }
      if (deleteCategoryIdx < 0) {
        SnackBarHelper.showErrorSnackBar(AppString.errorOccurred.tr);
        return;
      }

      final beforeIdxCategory = newCats[deleteCategoryIdx - 1];
      newCats.removeAt(deleteCategoryIdx);

      _selectedBook.value = _selectedBook.value!.copyWith(
        categories: newCats,
        selectedCategory: beforeIdxCategory,
      );

      bookRepo.put(_selectedBook.value!.id, _selectedBook.value!);
      SnackBarHelper.showSuccessSnackBar(
        '${AppString.category.tr}${AppString.doneDelete.tr}',
        duration: Duration(seconds: 2),
      );
    }
  }

  void onChangeCategory(String? id, {bool isMyBookScreen = false}) async {
    final curBook = _selectedBook.value;
    if (curBook == null) return;

    final cat = (_selectedBook.value!.categories ?? []).firstWhereOrNull(
      (cat) => cat.id == id,
    );
    if (cat == null) return;

    final updatedBook = curBook.copyWith(selectedCategory: cat);
    _selectedBook.value = updatedBook;

    final idx = books.indexWhere((b) => b.id == updatedBook.id);
    if (idx != -1) books[idx] = updatedBook;

    await bookRepo.put(updatedBook.id, updatedBook);

    if (isMyBookScreen) {
      NewMyWordController.to.onBookCategoryChange();
    }
  }

  void tapBook(Book book) {
    _selectedBook.value = book;

    Get.toNamed(NewMyWordScreen.name);
  }

  void addMyWord(MyWord myWord) {
    if (_selectedBook.value == null) return;

    _selectedBook.value!.mywords.add(myWord);
    _updateBook(_selectedBook.value!);
    loadBook(_selectedBook.value!);
  }

  Future<int> bulkHandleMyWords(
    List<MyWord> myWords, {
    bool isAdd = true,
  }) async {
    int savedCount = 0;

    for (var word in myWords) {
      if (isAdd) {
        if (!_selectedBook.value!.mywords.contains(word)) {
          _selectedBook.value!.mywords.add(word);
          savedCount++;
        }
      } else {
        if (_selectedBook.value!.mywords.contains(word)) {
          _selectedBook.value!.mywords.remove(word);
          savedCount++;
        }
      }
    }

    if (savedCount != 0) {
      _updateBook(_selectedBook.value!);
      loadBooks();
    }
    return savedCount;
  }

  void deleteMyWord(MyWord myWord) {
    if (_selectedBook.value == null) return;
    _selectedBook.value!.mywords.remove(myWord);
    _updateBook(_selectedBook.value!);
    loadBook(_selectedBook.value!);
  }

  void updateMyWord(MyWord myWord) {
    int index = _selectedBook.value!.mywords.indexWhere(
      (item) => item == myWord,
    );
    if (index != -1) {
      _selectedBook.value!.mywords[index] = myWord;
    }
    _updateBook(_selectedBook.value!);
    loadBook(_selectedBook.value!);
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
      if (book == null) {
        _selectedBook.value = null;
      }

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

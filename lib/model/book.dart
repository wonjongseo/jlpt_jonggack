import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/book_catgory.dart';

import 'package:jlpt_jonggack/model/hive_type.dart';
import 'package:jlpt_jonggack/model/my_word.dart';

part 'book.g.dart';

@HiveType(typeId: bookTypeId)
class Book extends HiveObject {
  static String boxKey = 'book_key';
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int bookNum;

  @HiveField(4)
  final String createdAt;

  @HiveField(5)
  List<MyWord> mywords;

  @HiveField(6, defaultValue: null)
  List<BookCategory>? categories;

  @HiveField(7, defaultValue: null)
  BookCategory? selectedCategory;

  Book({
    String? id,
    String? createdAt,
    required this.title,
    required this.description,
    required this.bookNum,
    List<MyWord>? mywords,
    this.categories,
    this.selectedCategory,
  }) : id = id ?? '${DateTime.now().microsecondsSinceEpoch}',
       createdAt = createdAt ?? DateTime.now().toIso8601String(),
       mywords = mywords ?? [];

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'bookNum': bookNum});
    result.addAll({'createdAt': createdAt});
    result.addAll({'mywords': mywords});

    return result;
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      bookNum: map['bookNum']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
      mywords: List<MyWord>.from(map['mywords']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.bookNum == bookNum &&
        other.createdAt == createdAt &&
        other.selectedCategory == selectedCategory &&
        listEquals(other.categories, categories) &&
        listEquals(other.mywords, mywords);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        bookNum.hashCode ^
        createdAt.hashCode ^
        categories.hashCode ^
        selectedCategory.hashCode ^
        mywords.hashCode;
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, description: $description, bookNum: $bookNum, createdAt: $createdAt, mywords: $mywords)';
  }

  static List<Book> createDefaultBooks() {
    final myBook1Cat = BookCategory.unspecified;
    Book myWordBook1 = Book(
      title: isEn ? AppString.jgVocaEn : AppString.jgVocaKr,
      description: isEn ? AppString.jgVocaDescEn : AppString.jgVocaDescKr,
      bookNum: 1,
      categories: [myBook1Cat],
      selectedCategory: myBook1Cat,
    );
    final myBook2Cat = BookCategory.unspecified;
    Book myWordBook2 = Book(
      title: isEn ? AppString.myVocaEn : AppString.myVocaKr,
      description: isEn ? AppString.myVocaDescEn : AppString.myVocaDescKr,
      bookNum: 2,
      categories: [myBook2Cat],
      selectedCategory: myBook2Cat,
    );

    List<Book> books = [myWordBook1, myWordBook2];
    return books;
  }

  Book copyWith({
    String? id,
    String? title,
    String? description,
    int? bookNum,
    String? createdAt,
    List<MyWord>? mywords,
    List<BookCategory>? categories,
    BookCategory? selectedCategory,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      bookNum: bookNum ?? this.bookNum,
      createdAt: createdAt ?? this.createdAt,
      mywords: mywords ?? this.mywords,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

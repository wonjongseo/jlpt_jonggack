import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';
import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/core/app_string.dart';

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

  Book({
    String? id,
    String? createdAt,
    required this.title,
    required this.description,
    required this.bookNum,
    List<MyWord>? mywords,
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
        listEquals(other.mywords, mywords);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        bookNum.hashCode ^
        createdAt.hashCode ^
        mywords.hashCode;
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, description: $description, bookNum: $bookNum, createdAt: $createdAt, mywords: $mywords)';
  }

  static List<Book> createDefaultBooks() {
    bool isEn = PlatformDispatcher.instance.locale.languageCode == 'en';
    Book myWordBook1 = Book(
      title: isEn ? 'JG Book' : '종각 단어장',
      description:
          isEn
              ? 'This is a vocabulary book where words in the app are stored'
              : '종각 앱에서 저장한 단어들을\n학습하는 단어장',
      bookNum: 1,
    );
    Book myWordBook2 = Book(
      title: isEn ? 'My Book' : '나만의 단어장',
      description:
          isEn
              ? 'This is a vocabulary book where the user stores the words directly'
              : '종각 앱에서 저장한 단어들을\n학습하는 단어장',
      bookNum: 2,
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
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      bookNum: bookNum ?? this.bookNum,
      createdAt: createdAt ?? this.createdAt,
      mywords: mywords ?? this.mywords,
    );
  }
}

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

import 'package:jlpt_jonggack/model/hive_type.dart';

part 'book_catgory.g.dart';

@HiveType(typeId: bookCateogryId)
class BookCategory {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String id;

  const BookCategory._(this.name, this.id);

  factory BookCategory(String name, {String? id}) => BookCategory._(
    name,
    id ?? DateTime.now().microsecondsSinceEpoch.toString(),
  );

  //TODO CHECK
  static BookCategory unspecified = BookCategory._(
    isEn ? AppString.unspecifiedEn : AppString.unspecifiedKr,
    'unspecified',
  );

  @override
  String toString() => 'BookCategory(name: $name, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookCategory && other.name == name;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}

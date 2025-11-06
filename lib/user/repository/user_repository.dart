import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:jlpt_jonggack/model/user.dart';

class UserRepository {
  static Future<bool> isExistData() async {
    final box = Hive.box(User.boxKey);
    return box.isNotEmpty;
  }

  static Future<User> init(User user) async {
    final box = Hive.box(User.boxKey);
    await box.put('user', user);
    log('Created user');
    return user;
  }

  User? getUser() {
    final box = Hive.box(User.boxKey);
    User? user = box.get('user');
    return user;
  }

  static Future<void> deleteUser() async {
    final box = Hive.box(User.boxKey);
    await box.deleteAll(box.keys);
    // await box.deleteFromDisk();
  }

  static Future<bool> updateUser(User user) async {
    final box = Hive.box(User.boxKey);
    try {
      await box.put('user', user);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}

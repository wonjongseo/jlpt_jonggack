import 'package:get/get.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/model/user.dart';
import 'package:jlpt_jonggack/user/repository/user_repository.dart';
import 'package:jlpt_jonggack/user/screen/hiden_screen.dart';

// ignore: constant_identifier_names
enum TotalProgressType { JLPT, GRAMMAR, KANGI }

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();

  UserRepository userRepository = UserRepository();

  bool isPad = false;
  User? user;

  void changeuserTric(bool premieum) {
    user!.isTrik = premieum;
    UserRepository.updateUser(user!);
    update();
  }

  int clickUnKnownButtonCount = 0;

  UserController() {
    user = userRepository.getUser();
  }

  void updateCurrentProgress(
    TotalProgressType totalProgressType,
    int index,
    int addScore,
  ) {
    switch (totalProgressType) {
      case TotalProgressType.JLPT:
        if (user!.currentJlptWordScroes[index] + addScore >= 0) {
          if (user!.currentJlptWordScroes[index] + addScore >
              user!.jlptWordScroes[index]) {
            user!.currentJlptWordScroes[index] = user!.jlptWordScroes[index];
          } else {
            user!.currentJlptWordScroes[index] += addScore;
          }
        }

        break;
      case TotalProgressType.GRAMMAR:
        if (user!.currentGrammarScores[index] + addScore >= 0) {
          if (user!.currentGrammarScores[index] + addScore >
              user!.grammarScores[index]) {
            user!.currentGrammarScores[index] = user!.grammarScores[index];
          } else {
            user!.currentGrammarScores[index] += addScore;
          }
        }

        break;
      case TotalProgressType.KANGI:
        if (user!.currentKangiScores[index] + addScore >= 0) {
          if (user!.currentKangiScores[index] + addScore >
              user!.kangiScores[index]) {
            user!.currentKangiScores[index] = user!.kangiScores[index];
          } else {
            user!.currentKangiScores[index] += addScore;
          }
        }

        break;
    }
    UserRepository.updateUser(user!);
    update();
  }

  void changeUserAuth() {
    Get.to(() => const HidenScreen());
  }

  void updateMyWordSavedCount(
    bool isSaved, {
    bool isYokumatiageruWord = true,
    int count = 1,
  }) {
    print("updateMyWordSavedCount FIX!!!");
    // if (isYokumatiageruWord) {
    //   if (isSaved) {
    //     user.yokumatigaeruMyWords += count;
    //     showGoToTheMyScreen();
    //   } else {
    //     user.yokumatigaeruMyWords -= count;
    //   }
    // } else {
    //   if (isSaved) {
    //     user.manualSavedMyWords += count;
    //   } else {
    //     user.manualSavedMyWords -= count;
    //   }
    // }

    // if (user.yokumatigaeruMyWords < 0) {
    //   user.yokumatigaeruMyWords = 0;
    // }
    // if (user.yokumatigaeruMyWords < 0) {
    //   user.manualSavedMyWords = 0;
    // }
    UserRepository.updateUser(user!);

    update();
  }
}

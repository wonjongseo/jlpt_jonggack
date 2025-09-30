import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/data/grammar_datas.dart';
import 'package:jlpt_jonggack/data/kangi_datas.dart';
import 'package:jlpt_jonggack/data/word_datas.dart';
import 'package:jlpt_jonggack/repository/local_repository.dart';
import 'package:jlpt_jonggack/model/user.dart';
import 'package:jlpt_jonggack/user/repository/user_repository.dart';
import 'package:jlpt_jonggack/user/screen/hiden_screen.dart';

// ignore: constant_identifier_names

enum TotalProgressType { JLPT, GRAMMAR, KANGI }

enum SOUND_OPTIONS { VOLUMN, PITCH, RATE }

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();
  late TextEditingController teCnt;

  UserRepository userRepository = UserRepository();

  bool isPad = false;
  late User user;

  void changeuserTric(bool premieum) {
    user.isTrik = premieum;
    UserRepository.updateUser(user);
    update();
  }

  late double volumn;
  late double pitch;
  late double rate;

  int clickUnKnownButtonCount = 0;

  UserController() {
    user = userRepository.getUser();
    volumn = LocalReposotiry.getVolumn();
    pitch = LocalReposotiry.getPitch();
    rate = LocalReposotiry.getRate();
    teCnt = TextEditingController();
  }

  void updateSoundValues(SOUND_OPTIONS command, double newValue) {
    if (newValue >= 1 && newValue <= 0) return;

    switch (command) {
      case SOUND_OPTIONS.VOLUMN:
        LocalReposotiry.updateVolumn(newValue);
        volumn = newValue;
        break;
      case SOUND_OPTIONS.PITCH:
        LocalReposotiry.updatePitch(newValue);
        pitch = newValue;
        break;
      case SOUND_OPTIONS.RATE:
        LocalReposotiry.updateRate(newValue);
        rate = newValue;
        break;
    }
    update();
  }

  void onChangedSoundValues(SOUND_OPTIONS command, double newValue) {
    switch (command) {
      case SOUND_OPTIONS.VOLUMN:
        volumn = newValue;
        break;
      case SOUND_OPTIONS.PITCH:
        pitch = newValue;
        break;
      case SOUND_OPTIONS.RATE:
        rate = newValue;
        break;
    }
    update();
  }

  void initializeProgress(TotalProgressType totalProgressType) {
    switch (totalProgressType) {
      case TotalProgressType.JLPT:
        for (int i = 0; i < user.currentJlptWordScroes.length; i++) {
          switch (i) {
            case 0:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN1Words.length; ii++) {
                totalCount += (jsonN1Words[ii] as List).length;
              }
              user.jlptWordScroes[i] = totalCount;
              break;
            case 1:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN2Words.length; ii++) {
                totalCount += (jsonN2Words[ii] as List).length;
              }
              user.jlptWordScroes[i] = totalCount;
              break;
            case 2:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN3Words.length; ii++) {
                totalCount += (jsonN3Words[ii] as List).length;
              }
              user.jlptWordScroes[i] = totalCount;
              break;
            case 3:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN4Words.length; ii++) {
                totalCount += (jsonN4Words[ii] as List).length;
              }
              user.jlptWordScroes[i] = totalCount;
              break;
            case 4:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN5Words.length; ii++) {
                totalCount += (jsonN5Words[ii] as List).length;
              }
              user.jlptWordScroes[i] = totalCount;
              break;
          }
          user.currentJlptWordScroes[i] = 0;
        }
        break;
      case TotalProgressType.GRAMMAR:
        for (int i = 0; i < user.currentGrammarScores.length; i++) {
          switch (i) {
            case 0:
              user.grammarScores[i] = jsonN1Grammars.length;
              break;
            case 1:
              user.grammarScores[i] = jsonN2Grammars.length;
              break;
            case 2:
              user.grammarScores[i] = jsonN3Grammars.length;
              break;
            case 3:
              user.grammarScores[i] = jsonN4Grammars.length;
              break;
            case 4:
              user.grammarScores[i] = jsonN5Grammars.length;
              break;
          }

          user.currentGrammarScores[i] = 0;
        }
        break;
      case TotalProgressType.KANGI:
        for (int i = 0; i < user.currentKangiScores.length; i++) {
          switch (i) {
            case 0:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN1Kangis.length; ii++) {
                totalCount += (jsonN1Kangis[ii] as List).length;
              }
              user.kangiScores[i] = totalCount;
              break;
            case 1:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN2Kangis.length; ii++) {
                totalCount += (jsonN2Kangis[ii] as List).length;
              }
              user.kangiScores[i] = totalCount;
              break;
            case 2:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN3Kangis.length; ii++) {
                totalCount += (jsonN3Kangis[ii] as List).length;
              }
              user.kangiScores[i] = totalCount;
              break;
            case 3:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN4Kangis.length; ii++) {
                totalCount += (jsonN4Kangis[ii] as List).length;
              }
              user.kangiScores[i] = totalCount;
              break;
            case 4:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN5Kangis.length; ii++) {
                totalCount += (jsonN5Kangis[ii] as List).length;
              }
              user.kangiScores[i] = totalCount;
              break;
            case 5:
              int totalCount = 0;
              for (int ii = 0; ii < jsonN6Kangis.length; ii++) {
                totalCount += (jsonN6Kangis[ii] as List).length;
              }
              user.kangiScores[i] = totalCount;
              break;
          }
          user.currentKangiScores[i] = 0;
        }
        break;
    }
    UserRepository.updateUser(user);
  }

  void updateCurrentProgress(
    TotalProgressType totalProgressType,
    int index,
    int addScore,
  ) {
    switch (totalProgressType) {
      case TotalProgressType.JLPT:
        if (user.currentJlptWordScroes[index] + addScore >= 0) {
          if (user.currentJlptWordScroes[index] + addScore >
              user.jlptWordScroes[index]) {
            user.currentJlptWordScroes[index] = user.jlptWordScroes[index];
          } else {
            user.currentJlptWordScroes[index] += addScore;
          }
        }

        break;
      case TotalProgressType.GRAMMAR:
        if (user.currentGrammarScores[index] + addScore >= 0) {
          if (user.currentGrammarScores[index] + addScore >
              user.grammarScores[index]) {
            user.currentGrammarScores[index] = user.grammarScores[index];
          } else {
            user.currentGrammarScores[index] += addScore;
          }
        }

        break;
      case TotalProgressType.KANGI:
        if (user.currentKangiScores[index] + addScore >= 0) {
          if (user.currentKangiScores[index] + addScore >
              user.kangiScores[index]) {
            user.currentKangiScores[index] = user.kangiScores[index];
          } else {
            user.currentKangiScores[index] += addScore;
          }
        }

        break;
    }
    UserRepository.updateUser(user);
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
    UserRepository.updateUser(user);

    update();
  }

  void addN4N5GrammarScore() {
    log('V2.3.0 addN4N5GrammarScore');

    user.grammarScores.add(jsonN4Grammars.length);
    user.grammarScores.add(jsonN5Grammars.length);

    user.currentGrammarScores.addAll([0, 0]);

    UserRepository.updateUser(user);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/utils.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

enum TextInputEnum { japanese, yomikata, mean, exampleSentence, exampleMean }

extension TextInputEnumExtension on TextInputEnum {
  String get name {
    switch (this) {
      case TextInputEnum.japanese:
        return isKo ? '일본어' : 'Japanese';
      case TextInputEnum.yomikata:
        return isKo ? '읽는 법' : 'Proun';
      case TextInputEnum.mean:
        return isKo ? '한국어' : 'Mean';
      case TextInputEnum.exampleSentence:
        return isKo ? '예제 (예문)' : 'Example (sentence)';
      case TextInputEnum.exampleMean:
        return isKo ? '예제 (의미)' : 'Example (Mean)';
    }
  }
}

enum ExternalDictType {
  naver(Colors.green),
  papago(Colors.blueAccent);

  final Color color;
  const ExternalDictType(this.color);
}

extension ExternalDictTypeExtension on ExternalDictType {
  String get label {
    switch (this) {
      case ExternalDictType.naver:
        return isKo ? '네이버 사전' : 'Naver';
      case ExternalDictType.papago:
        return isKo ? '파파고' : 'Papago';
    }
  }
}

enum MyVocaPageFilter1 { ALL_VOCA, KNOWN_VOCA, UNKNOWN_VOCA }

enum MyVocaPageFilter2 { JAPANESE, MEAN }

extension Filter1Extension on MyVocaPageFilter1 {
  String get id {
    switch (this) {
      case MyVocaPageFilter1.ALL_VOCA:
        return '모든 단어';
      case MyVocaPageFilter1.KNOWN_VOCA:
        return '암기 단어';
      case MyVocaPageFilter1.UNKNOWN_VOCA:
        return '미암기 단어';
    }
  }
}

extension Filter2Extension on MyVocaPageFilter2 {
  String get id {
    switch (this) {
      case MyVocaPageFilter2.JAPANESE:
        return '일본어';
      case MyVocaPageFilter2.MEAN:
        return '의미';
    }
  }
}

enum KindOfStudy { basic, jlpt, my }

extension KindOfStudyExtension on KindOfStudy {
  String get value {
    switch (this) {
      case KindOfStudy.basic:
        return isKo ? '왕초보' : 'Basic';
      case KindOfStudy.jlpt:
        return 'JLPT';
      case KindOfStudy.my:
        return isKo ? '나만의' : "My";
    }
  }
}

// ignore: constant_identifier_names
enum CategoryEnum { japaneses, kangis, grammars }

extension CategoryEnumExtension on CategoryEnum {
  String get id {
    switch (this) {
      case CategoryEnum.japaneses:
        return isKo ? '일본어' : 'Japanese';
      case CategoryEnum.kangis:
        return isKo ? '한자' : "Kangi";
      case CategoryEnum.grammars:
        return isKo ? '문법' : "Grammar";
    }
  }
}

enum MyWordType { all, known, unKnown }

extension MyWordTypeExtension on MyWordType {
  String get label {
    switch (this) {
      case MyWordType.all:
        return isKo ? "모두 보기" : 'See All';
      case MyWordType.known:
        return isKo ? "암기 단어" : 'Known Word';
      case MyWordType.unKnown:
        return isKo ? "미암기 단어" : 'Unknown Word';
    }
  }
}

enum SoundOptions {
  speedRate(Colors.redAccent),
  volumn(Colors.blueAccent),
  pitch(Colors.deepPurpleAccent);

  final Color color;
  const SoundOptions(this.color);
}

extension ESoundOptions on SoundOptions {
  String get label {
    switch (this) {
      case SoundOptions.speedRate:
        return AppString.speedRate.tr;
      case SoundOptions.volumn:
        return AppString.volumn.tr;
      case SoundOptions.pitch:
        return AppString.pitch.tr;
    }
  }
}

enum QuizDuration { incorrect, correct }

extension EQuizDuration on QuizDuration {
  String get label {
    switch (this) {
      case QuizDuration.incorrect:
        return AppString.whenIncorrect.tr;
      case QuizDuration.correct:
        return AppString.whenCorrect.tr;
    }
  }
}

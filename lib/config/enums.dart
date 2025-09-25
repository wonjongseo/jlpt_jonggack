import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum TextInputEnum {
  JAPANESE('일본어'),
  YOMIKATA('읽는 법'),
  MEAN('한국어'),
  EXAMPLE_JAPANESE('예제 (예문)'),
  EXAMPLE_MEAN('예제 (의미)');

  final String name;
  const TextInputEnum(this.name);
}

enum ExternalDictType {
  naver("네이버 사전", Colors.green),
  papago("파파고", Colors.blueAccent);

  final String label;
  final Color color;
  const ExternalDictType(this.label, this.color);
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

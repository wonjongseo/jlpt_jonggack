import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';
import 'package:jlpt_jonggack/model/example.dart';

class Hiragana {
  final String hiragana;

  final List<SubHiragana> subHiragana;
  Hiragana({required this.hiragana, required this.subHiragana});
}

class SubHiragana {
  final String hiragana;
  final String kSound;
  final String eSound;
  final List<Example>? examples;
  SubHiragana({
    required this.hiragana,
    required this.kSound,
    this.examples,
    required this.eSound,
  });
}

// ==================== Katakana ====================
List<Hiragana> katakana = [
  Hiragana(
    hiragana: 'ア',
    subHiragana: [
      SubHiragana(
        hiragana: 'ア',
        kSound: isKo ? '아' : 'A',
        eSound: 'a',
        examples: [
          Example(
            yomikata: '-',
            word: 'アイスクリーム',
            mean: isKo ? '아이스크림' : 'Ice cream',
          ),
          Example(
            yomikata: '-',
            word: 'アルバイト',
            mean: isKo ? '아르바이트(알바)' : 'Part-time job',
          ),
          Example(yomikata: '-', word: 'アイロン', mean: isKo ? '다리미' : 'Iron'),
          Example(yomikata: '-', word: 'アジア', mean: isKo ? '아시아' : 'Asia'),
        ],
      ),
      SubHiragana(
        hiragana: 'イ',
        kSound: isKo ? '이' : 'I',
        eSound: 'i',
        examples: [
          Example(yomikata: '-', word: 'イタリア', mean: isKo ? '이탈리아' : 'Italy'),
          Example(yomikata: '-', word: 'インク', mean: isKo ? '잉크' : 'Ink'),
          Example(
            yomikata: '-',
            word: 'イアホン',
            mean: isKo ? '이어폰' : 'Earphones',
          ),
          Example(
            yomikata: '-',
            word: 'インターネット',
            mean: isKo ? '인터넷' : 'Internet',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ウ',
        kSound: isKo ? '우' : 'U',
        eSound: 'u',
        examples: [
          Example(yomikata: '-', word: 'ウクレレ', mean: isKo ? '우쿠렐레' : 'Ukulele'),
          Example(yomikata: '-', word: 'ウイルス', mean: isKo ? '바이러스' : 'Virus'),
          Example(yomikata: '-', word: 'ウェブ', mean: isKo ? '웹' : 'Web'),
          Example(yomikata: '-', word: 'ウィスキー', mean: isKo ? '위스키' : 'Whisky'),
        ],
      ),
      SubHiragana(
        hiragana: 'エ',
        kSound: isKo ? '에' : 'E',
        eSound: 'e',
        examples: [
          Example(yomikata: '-', word: 'エンジン', mean: isKo ? '엔진' : 'Engine'),
          Example(
            yomikata: '-',
            word: 'エアコン',
            mean: isKo ? '에어컨' : 'Air conditioner',
          ),
          Example(yomikata: '-', word: 'エプロン', mean: isKo ? '앞치마' : 'Apron'),
          Example(yomikata: '-', word: 'エラー', mean: isKo ? '에러' : 'Error'),
        ],
      ),
      SubHiragana(
        hiragana: 'オ',
        kSound: isKo ? '오' : 'O',
        eSound: 'o',
        examples: [
          Example(
            yomikata: '-',
            word: 'オーストラリア',
            mean: isKo ? '호주' : 'Australia',
          ),
          Example(yomikata: '-', word: 'オイル', mean: isKo ? '오일' : 'Oil'),
          Example(yomikata: '-', word: 'オレンジ', mean: isKo ? '오렌지' : 'Orange'),
          Example(yomikata: '-', word: 'オーブン', mean: isKo ? '오븐' : 'Oven'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'カ',
    subHiragana: [
      SubHiragana(
        hiragana: 'カ',
        kSound: isKo ? '카' : 'Ka',
        eSound: 'ka',
        examples: [
          Example(
            yomikata: '-',
            word: 'カーディガン',
            mean: isKo ? '가디건' : 'Cardigan',
          ),
          Example(yomikata: '-', word: 'カラオケ', mean: isKo ? '노래방' : 'Karaoke'),
          Example(
            yomikata: '-',
            word: 'カカオ',
            mean: isKo ? '카카오' : 'Cacao/Cocoa',
          ),
          Example(yomikata: '-', word: 'カメラ', mean: isKo ? '카메라' : 'Camera'),
        ],
      ),
      SubHiragana(
        hiragana: 'キ',
        kSound: isKo ? '키' : 'Ki',
        eSound: 'ki',
        examples: [
          Example(yomikata: '-', word: 'キウイ', mean: isKo ? '키위' : 'Kiwi'),
          Example(
            yomikata: '-',
            word: 'キツツキ',
            mean: isKo ? '딱따구리' : 'Woodpecker',
          ),
          Example(
            yomikata: '-',
            word: 'キーホルダー',
            mean: isKo ? '열쇠고리' : 'Keychain',
          ),
          Example(yomikata: '-', word: 'キッチン', mean: isKo ? '주방' : 'Kitchen'),
        ],
      ),
      SubHiragana(
        hiragana: 'ク',
        kSound: isKo ? '쿠' : 'Ku',
        eSound: 'ku',
        examples: [
          Example(yomikata: '-', word: 'クッション', mean: isKo ? '쿠션' : 'Cushion'),
          Example(yomikata: '-', word: 'クッキー', mean: isKo ? '쿠키' : 'Cookie'),
          Example(yomikata: '-', word: 'クーポン', mean: isKo ? '쿠폰' : 'Coupon'),
          Example(yomikata: '-', word: 'クレヨン', mean: isKo ? '크레용' : 'Crayon'),
        ],
      ),
      SubHiragana(
        hiragana: 'ケ',
        kSound: isKo ? '케' : 'Ke',
        eSound: 'ke',
        examples: [
          Example(yomikata: '-', word: 'ケース', mean: isKo ? '케이스' : 'Case'),
          Example(yomikata: '-', word: 'ケーキ', mean: isKo ? '케이크' : 'Cake'),
        ],
      ),
      SubHiragana(
        hiragana: 'コ',
        kSound: isKo ? '코' : 'Ko',
        eSound: 'ko',
        examples: [
          Example(yomikata: '-', word: 'ココア', mean: isKo ? '코코아' : 'Cocoa'),
          Example(yomikata: '-', word: 'コーラ', mean: isKo ? '콜라' : 'Cola'),
          Example(yomikata: '-', word: 'コンテンツ', mean: isKo ? '콘텐츠' : 'Content'),
          Example(yomikata: '-', word: 'コーヒー', mean: isKo ? '커피' : 'Coffee'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'サ',
    subHiragana: [
      SubHiragana(
        hiragana: 'サ',
        kSound: isKo ? '사' : 'Sa',
        eSound: 'sa',
        examples: [
          Example(yomikata: '-', word: 'サービス', mean: isKo ? '서비스' : 'Service'),
          Example(yomikata: '-', word: 'サッカー', mean: isKo ? '축구' : 'Soccer'),
          Example(yomikata: '-', word: 'サウナ', mean: isKo ? '사우나' : 'Sauna'),
        ],
      ),
      SubHiragana(
        hiragana: 'シ',
        kSound: isKo ? '시' : 'Shi',
        eSound: 'shi',
        examples: [
          Example(yomikata: '-', word: 'シーツ', mean: isKo ? '시트' : 'Sheet'),
          Example(yomikata: '-', word: 'シングル', mean: isKo ? '싱글' : 'Single'),
          Example(
            yomikata: '-',
            word: 'シナリオ',
            mean: isKo ? '시나리오' : 'Scenario',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ス',
        kSound: isKo ? '스' : 'Su',
        eSound: 'su',
        examples: [
          Example(yomikata: '-', word: 'スキー', mean: isKo ? '스키' : 'Ski'),
          Example(
            yomikata: '-',
            word: 'スノーボード',
            mean: isKo ? '스노우보드' : 'Snowboard',
          ),
          Example(yomikata: '-', word: 'スイカ', mean: isKo ? '수박' : 'Watermelon'),
          Example(yomikata: '-', word: 'スパイ', mean: isKo ? '스파이' : 'Spy'),
        ],
      ),
      SubHiragana(
        hiragana: 'セ',
        kSound: isKo ? '세' : 'Se',
        eSound: 'se',
        examples: [
          Example(yomikata: '-', word: 'セール', mean: isKo ? '세일' : 'Sale'),
          Example(
            yomikata: '-',
            word: 'セキュリティ',
            mean: isKo ? '보안' : 'Security',
          ),
          Example(yomikata: '-', word: 'セーター', mean: isKo ? '스웨터' : 'Sweater'),
        ],
      ),
      SubHiragana(
        hiragana: 'ソ',
        kSound: isKo ? '소' : 'So',
        eSound: 'so',
        examples: [
          Example(yomikata: '-', word: 'ソース', mean: isKo ? '소스' : 'Sauce'),
          Example(yomikata: '-', word: 'ソファー', mean: isKo ? '소파' : 'Sofa'),
          Example(yomikata: '-', word: 'ソーセージ', mean: isKo ? '소시지' : 'Sausage'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'タ',
    subHiragana: [
      SubHiragana(
        hiragana: 'タ',
        kSound: isKo ? '타' : 'Ta',
        eSound: 'ta',
        examples: [
          Example(yomikata: '-', word: 'タクシー', mean: isKo ? '택시' : 'Taxi'),
          Example(yomikata: '-', word: 'タイヤ', mean: isKo ? '타이어' : 'Tire'),
          Example(
            yomikata: '-',
            word: 'タヌキ',
            mean: isKo ? '너구리' : 'Raccoon dog (Tanuki)',
          ),
          Example(yomikata: '-', word: 'タワー', mean: isKo ? '타워' : 'Tower'),
        ],
      ),
      SubHiragana(
        hiragana: 'チ',
        kSound: isKo ? '치' : 'Chi',
        eSound: 'chi',
        examples: [
          Example(yomikata: '-', word: 'チーター', mean: isKo ? '치타' : 'Cheetah'),
          Example(yomikata: '-', word: 'チーズ', mean: isKo ? '치즈' : 'Cheese'),
          Example(yomikata: '-', word: 'チキン', mean: isKo ? '치킨' : 'Chicken'),
          Example(yomikata: '-', word: 'チケット', mean: isKo ? '티켓' : 'Ticket'),
        ],
      ),
      SubHiragana(
        hiragana: 'ツ',
        kSound: isKo ? '츠' : 'Tsu',
        eSound: 'tsu',
        examples: [
          Example(yomikata: '-', word: 'ツアー', mean: isKo ? '투어' : 'Tour'),
          Example(yomikata: '-', word: 'ツリー', mean: isKo ? '트리' : 'Tree'),
          Example(yomikata: '-', word: 'ツンデレ', mean: isKo ? '츤데레' : 'Tsundere'),
        ],
      ),
      SubHiragana(
        hiragana: 'テ',
        kSound: isKo ? '테' : 'Te',
        eSound: 'te',
        examples: [
          Example(yomikata: '-', word: 'テニス', mean: isKo ? '테니스' : 'Tennis'),
          Example(yomikata: '-', word: 'テスト', mean: isKo ? '테스트' : 'Test'),
          Example(yomikata: '-', word: 'テキスト', mean: isKo ? '텍스트' : 'Text'),
          Example(
            yomikata: '-',
            word: 'ティーシャツ',
            mean: isKo ? '티셔츠' : 'T-shirt',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ト',
        kSound: isKo ? '토' : 'To',
        eSound: 'to',
        examples: [
          Example(yomikata: '-', word: 'トースト', mean: isKo ? '토스트' : 'Toast'),
          Example(yomikata: '-', word: 'トマト', mean: isKo ? '토마토' : 'Tomato'),
          Example(yomikata: '-', word: 'トイレ', mean: isKo ? '화장실' : 'Toilet'),
          Example(yomikata: '-', word: 'トンネル', mean: isKo ? '터널' : 'Tunnel'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ナ',
    subHiragana: [
      SubHiragana(
        hiragana: 'ナ',
        kSound: isKo ? '나' : 'Na',
        eSound: 'na',
        examples: [
          Example(yomikata: '-', word: 'ナイフ', mean: isKo ? '나이프' : 'Knife'),
          Example(yomikata: '-', word: 'ナプキン', mean: isKo ? '냅킨' : 'Napkin'),
          Example(yomikata: '-', word: 'ナチュラル', mean: isKo ? '내추럴' : 'Natural'),
        ],
      ),
      SubHiragana(
        hiragana: 'ニ',
        kSound: isKo ? '니' : 'Ni',
        eSound: 'ni',
        examples: [
          Example(
            yomikata: '-',
            word: 'ニート',
            mean: isKo ? '니트' : 'NEET (not in education/employment/training)',
          ),
          Example(
            yomikata: '-',
            word: 'ニキビ',
            mean: isKo ? '여드름' : 'Pimple/Acne',
          ),
          Example(
            yomikata: '-',
            word: 'ニラ',
            mean: isKo ? '부추' : 'Garlic chives',
          ),
          Example(yomikata: '-', word: 'ニュース', mean: isKo ? '뉴스' : 'News'),
        ],
      ),
      SubHiragana(
        hiragana: 'ヌ',
        kSound: isKo ? '누' : 'Nu',
        eSound: 'nu',
        examples: [
          Example(yomikata: '-', word: 'ヌテラ', mean: isKo ? '누텔라' : 'Nutella'),
        ],
      ),
      SubHiragana(
        hiragana: 'ネ',
        kSound: isKo ? '네' : 'Ne',
        eSound: 'ne',
        examples: [
          Example(yomikata: '-', word: 'ネクタイ', mean: isKo ? '넥타이' : 'Necktie'),
          Example(yomikata: '-', word: 'ネパール', mean: isKo ? '네팔' : 'Nepal'),
          Example(
            yomikata: '-',
            word: 'ネックレス',
            mean: isKo ? '목걸이' : 'Necklace',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ノ',
        kSound: isKo ? '노' : 'No',
        eSound: 'no',
        examples: [
          Example(yomikata: '-', word: 'ノート', mean: isKo ? '노트' : 'Notebook'),
          Example(yomikata: '-', word: 'ノイズ', mean: isKo ? '소음' : 'Noise'),
          Example(yomikata: '-', word: 'ノック', mean: isKo ? '노크' : 'Knock'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ハ',
    subHiragana: [
      SubHiragana(
        hiragana: 'ハ',
        kSound: isKo ? '하' : 'Ha',
        eSound: 'ha',
        examples: [
          Example(yomikata: '-', word: 'ハウス', mean: isKo ? '하우스' : 'House'),
          Example(yomikata: '-', word: 'ハサミ', mean: isKo ? '가위' : 'Scissors'),
          Example(
            yomikata: '-',
            word: 'ハンバーグ',
            mean: isKo ? '햄버그' : 'Hamburg steak',
          ),
          Example(yomikata: '-', word: 'ハイキング', mean: isKo ? '하이킹' : 'Hiking'),
        ],
      ),
      SubHiragana(
        hiragana: 'ヒ',
        kSound: isKo ? '히' : 'Hi',
        eSound: 'hi',
        examples: [
          Example(yomikata: '-', word: 'ヒーター', mean: isKo ? '히터' : 'Heater'),
          Example(yomikata: '-', word: 'ヒント', mean: isKo ? '힌트' : 'Hint'),
          Example(yomikata: '-', word: 'ヒーロー', mean: isKo ? '히어로' : 'Hero'),
        ],
      ),
      SubHiragana(
        hiragana: 'フ',
        kSound: isKo ? '후' : 'Fu',
        eSound: 'fu',
        examples: [
          Example(yomikata: '-', word: 'フード', mean: isKo ? '후드(티)' : 'Hoodie'),
          Example(
            yomikata: '-',
            word: 'フットボール',
            mean: isKo ? '풋볼' : 'Football',
          ),
          Example(yomikata: '-', word: 'フォーク', mean: isKo ? '포크' : 'Fork'),
          Example(yomikata: '-', word: 'ファイル', mean: isKo ? '파일' : 'File'),
        ],
      ),
      SubHiragana(
        hiragana: 'ヘ',
        kSound: isKo ? '헤' : 'He',
        eSound: 'he',
        examples: [
          Example(
            yomikata: '-',
            word: 'ヘリコプター',
            mean: isKo ? '헬리콥터' : 'Helicopter',
          ),
          Example(
            yomikata: '-',
            word: 'ヘラクレス',
            mean: isKo ? '헤라클레스' : 'Heracles/Hercules',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ホ',
        kSound: isKo ? '호' : 'Ho',
        eSound: 'ho',
        examples: [
          Example(yomikata: '-', word: 'ホテル', mean: isKo ? '호텔' : 'Hotel'),
          Example(yomikata: '-', word: 'ホラー', mean: isKo ? '호러' : 'Horror'),
          Example(yomikata: '-', word: 'ホーム', mean: isKo ? '홈' : 'Home'),
          Example(
            yomikata: '-',
            word: 'ホットドック',
            mean: isKo ? '핫도그' : 'Hot dog',
          ),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'マ',
    subHiragana: [
      SubHiragana(
        hiragana: 'マ',
        kSound: isKo ? '마' : 'Ma',
        eSound: 'ma',
        examples: [
          Example(yomikata: '-', word: 'マスク', mean: isKo ? '마스크' : 'Mask'),
          Example(yomikata: '-', word: 'マーケット', mean: isKo ? '마켓' : 'Market'),
          Example(yomikata: '-', word: 'マニュアル', mean: isKo ? '매뉴얼' : 'Manual'),
        ],
      ),
      SubHiragana(
        hiragana: 'ミ',
        kSound: isKo ? '미' : 'Mi',
        eSound: 'mi',
        examples: [
          Example(yomikata: '-', word: 'ミルク', mean: isKo ? '우유' : 'Milk'),
          Example(yomikata: '-', word: 'ミント', mean: isKo ? '민트' : 'Mint'),
          Example(yomikata: '-', word: 'ミラー', mean: isKo ? '거울' : 'Mirror'),
        ],
      ),
      SubHiragana(
        hiragana: 'ム',
        kSound: isKo ? '무' : 'Mu',
        eSound: 'mu',
        examples: [
          Example(yomikata: '-', word: 'ムース', mean: isKo ? '무스' : 'Mousse'),
          Example(yomikata: '-', word: 'ムービー', mean: isKo ? '영화' : 'Movie'),
          Example(yomikata: '-', word: 'ムード', mean: isKo ? '무드(분위기)' : 'Mood'),
        ],
      ),
      SubHiragana(
        hiragana: 'メ',
        kSound: isKo ? '메' : 'Me',
        eSound: 'me',
        examples: [
          Example(yomikata: '-', word: 'メール', mean: isKo ? '메일' : 'Mail/Email'),
          Example(yomikata: '-', word: 'メモ', mean: isKo ? '메모' : 'Memo/Note'),
          Example(yomikata: '-', word: 'メニュー', mean: isKo ? '메뉴' : 'Menu'),
        ],
      ),
      SubHiragana(
        hiragana: 'モ',
        kSound: isKo ? '모' : 'Mo',
        eSound: 'mo',
        examples: [
          Example(yomikata: '-', word: 'モデル', mean: isKo ? '모델' : 'Model'),
          Example(yomikata: '-', word: 'モバイル', mean: isKo ? '모바일' : 'Mobile'),
          Example(yomikata: '-', word: 'モニター', mean: isKo ? '모니터' : 'Monitor'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ヤ',
    subHiragana: [
      SubHiragana(
        hiragana: 'ヤ',
        kSound: isKo ? '야' : 'Ya',
        eSound: 'ya',
        examples: [
          Example(yomikata: '-', word: 'ヤカン', mean: isKo ? '주전자' : 'Kettle'),
          Example(yomikata: '-', word: 'ヤクルト', mean: isKo ? '야쿠르트' : 'Yakult'),
        ],
      ),
      SubHiragana(
        hiragana: 'ユ',
        kSound: isKo ? '유' : 'Yu',
        eSound: 'yu',
        examples: [
          Example(yomikata: '-', word: 'ユーザー', mean: isKo ? '유저' : 'User'),
          Example(yomikata: '-', word: 'ユニコーン', mean: isKo ? '유니콘' : 'Unicorn'),
          Example(
            yomikata: '-',
            word: 'ユーチューブ',
            mean: isKo ? '유튜브' : 'YouTube',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ヨ',
        kSound: isKo ? '요' : 'Yo',
        eSound: 'yo',
        examples: [
          Example(yomikata: '-', word: 'ヨーヨー', mean: isKo ? '요요' : 'Yo-yo'),
          Example(yomikata: '-', word: 'ヨット', mean: isKo ? '요트' : 'Yacht'),
          Example(yomikata: '-', word: 'ヨーグルト', mean: isKo ? '요구르트' : 'Yogurt'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ラ',
    subHiragana: [
      SubHiragana(
        hiragana: 'ラ',
        kSound: isKo ? '라' : 'Ra',
        eSound: 'ra',
        examples: [
          Example(yomikata: '-', word: 'ラジオ', mean: isKo ? '라디오' : 'Radio'),
          Example(yomikata: '-', word: 'ライオン', mean: isKo ? '라이온' : 'Lion'),
          Example(yomikata: '-', word: 'ラーメン', mean: isKo ? '라멘' : 'Ramen'),
          Example(yomikata: '-', word: 'ランニング', mean: isKo ? '런닝' : 'Running'),
        ],
      ),
      SubHiragana(
        hiragana: 'リ',
        kSound: isKo ? '리' : 'Ri',
        eSound: 'ri',
        examples: [
          Example(yomikata: '-', word: 'リボン', mean: isKo ? '리본' : 'Ribbon'),
          Example(
            yomikata: '-',
            word: 'リハーサル',
            mean: isKo ? '리허설' : 'Rehearsal',
          ),
          Example(
            yomikata: '-',
            word: 'リアクション',
            mean: isKo ? '리액션' : 'Reaction',
          ),
          Example(yomikata: '-', word: 'リーダー', mean: isKo ? '리더' : 'Leader'),
        ],
      ),
      SubHiragana(
        hiragana: 'ル',
        kSound: isKo ? '루' : 'Ru',
        eSound: 'ru',
        examples: [
          Example(yomikata: '-', word: 'ルート', mean: isKo ? '루트' : 'Route'),
          Example(yomikata: '-', word: 'ルール', mean: isKo ? '규칙' : 'Rule'),
          Example(yomikata: '-', word: 'ルーレット', mean: isKo ? '룰렛' : 'Roulette'),
        ],
      ),
      SubHiragana(
        hiragana: 'レ',
        kSound: isKo ? '레' : 'Re',
        eSound: 're',
        examples: [
          Example(yomikata: '-', word: 'レモン', mean: isKo ? '레몬' : 'Lemon'),
          Example(
            yomikata: '-',
            word: 'レース',
            mean: isKo ? '레이스' : 'Lace/Race (context)',
          ),
          Example(yomikata: '-', word: 'レンズ', mean: isKo ? '렌즈' : 'Lens'),
          Example(
            yomikata: '-',
            word: 'レストラン',
            mean: isKo ? '레스토랑' : 'Restaurant',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ロ',
        kSound: isKo ? '로' : 'Ro',
        eSound: 'ro',
        examples: [
          Example(yomikata: '-', word: 'ロボット', mean: isKo ? '로봇' : 'Robot'),
          Example(yomikata: '-', word: 'ロバ', mean: isKo ? '당나귀' : 'Donkey'),
          Example(yomikata: '-', word: 'ロケット', mean: isKo ? '로켓' : 'Rocket'),
          Example(
            yomikata: '-',
            word: 'ロッカー',
            mean: isKo ? '(코인)로커' : 'Locker (coin locker)',
          ),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ワ',
    subHiragana: [
      SubHiragana(
        hiragana: 'ワ',
        kSound: isKo ? '와' : 'Wa',
        eSound: 'wa',
        examples: [
          Example(yomikata: '-', word: 'ワッフル', mean: isKo ? '와플' : 'Waffle'),
          Example(yomikata: '-', word: 'ワイン', mean: isKo ? '와인' : 'Wine'),
          Example(
            yomikata: '-',
            word: 'ワンピース',
            mean: isKo ? '원피스' : 'One-piece dress',
          ),
          Example(yomikata: '-', word: 'ワクチン', mean: isKo ? '백신' : 'Vaccine'),
        ],
      ),
      SubHiragana(
        hiragana: 'ヲ',
        kSound: isKo ? '오' : 'Wo',
        eSound: 'wo',
        examples: [
          Example(yomikata: '-', word: 'ヲタク', mean: isKo ? '오타쿠' : 'Otaku'),
        ],
      ),
      SubHiragana(
        hiragana: 'ン',
        kSound: isKo ? '응' : 'N',
        eSound: 'n',
        examples: [
          Example(
            yomikata: '-',
            word: 'コンピュータ',
            mean: isKo ? '컴퓨터' : 'Computer',
          ),
          Example(yomikata: '-', word: 'パン', mean: isKo ? '빵' : 'Bread'),
        ],
      ),
    ],
  ),
];

// ==================== Hiragana ====================
List<Hiragana> hiraganas = [
  Hiragana(
    hiragana: 'あ',
    subHiragana: [
      SubHiragana(
        hiragana: 'あ',
        kSound: isKo ? '아' : 'a',
        eSound: 'a',
        examples: [
          Example(yomikata: 'あい', word: '愛', mean: isKo ? '사랑' : 'Love'),
          Example(yomikata: 'あおい', word: '青い', mean: isKo ? '파랗다' : 'Blue'),
          Example(yomikata: 'あう', word: '会う', mean: isKo ? '만나다' : 'Meet'),
          Example(yomikata: 'あし', word: '足', mean: isKo ? '발' : 'Foot/Leg'),
        ],
      ),
      SubHiragana(
        hiragana: 'い',
        kSound: isKo ? '이' : 'i',
        eSound: 'i',
        examples: [
          Example(yomikata: 'いえ', word: '家', mean: isKo ? '집' : 'House/Home'),
          Example(yomikata: 'いす', word: 'いす', mean: isKo ? '의자' : 'Chair'),
          Example(yomikata: 'いく', word: '行く', mean: isKo ? '가다' : 'Go'),
          Example(yomikata: 'いま', word: '今', mean: isKo ? '지금' : 'Now'),
        ],
      ),
      SubHiragana(
        hiragana: 'う',
        kSound: isKo ? '우' : 'u',
        eSound: 'u',
        examples: [
          Example(yomikata: 'うた', word: '歌', mean: isKo ? '노래' : 'Song'),
          Example(
            yomikata: 'うまれる',
            word: '生まれる',
            mean: isKo ? '태어나다' : 'Be born',
          ),
          Example(yomikata: 'うみ', word: '海', mean: isKo ? '바다' : 'Sea'),
          Example(yomikata: 'うんこ', word: 'うんこ', mean: isKo ? '똥' : 'Poop'),
        ],
      ),
      SubHiragana(
        hiragana: 'え',
        kSound: isKo ? '에' : 'e',
        eSound: 'e',
        examples: [
          Example(yomikata: 'えいが', word: '映画', mean: isKo ? '영화' : 'Movie'),
          Example(yomikata: 'えいご', word: '英語', mean: isKo ? '영어' : 'English'),
          Example(yomikata: 'えき', word: '駅', mean: isKo ? '역' : 'Station'),
        ],
      ),
      SubHiragana(
        hiragana: 'お',
        kSound: isKo ? '오' : 'o',
        eSound: 'o',
        examples: [
          Example(
            yomikata: 'おいしい',
            word: '美味しい',
            mean: isKo ? '맛있다' : 'Delicious',
          ),
          Example(yomikata: 'おんがく', word: '音楽', mean: isKo ? '음악' : 'Music'),
          Example(
            yomikata: 'おんせん',
            word: '温泉',
            mean: isKo ? '온천' : 'Hot spring',
          ),
          Example(
            yomikata: 'おりる',
            word: '降りる',
            mean: isKo ? '내리다' : 'Get off/Descend',
          ),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'か',
    subHiragana: [
      SubHiragana(
        hiragana: 'か',
        kSound: isKo ? '카' : 'ka',
        eSound: 'ka',
        examples: [
          Example(yomikata: 'かう', word: '買う', mean: isKo ? '사다' : 'Buy'),
          Example(
            yomikata: 'かしこい',
            word: '賢い',
            mean: isKo ? '현명하다, 영리하다' : 'Wise/Clever',
          ),
          Example(yomikata: 'きのう', word: '昨日', mean: isKo ? '어제' : 'Yesterday'),
          Example(yomikata: 'かがく', word: '科学', mean: isKo ? '과학' : 'Science'),
        ],
      ),
      SubHiragana(
        hiragana: 'き',
        kSound: isKo ? '키' : 'ki',
        eSound: 'ki',
        examples: [
          Example(yomikata: 'き', word: '木', mean: isKo ? '나무' : 'Tree'),
          Example(yomikata: 'きょう', word: '今日', mean: isKo ? '오늘' : 'Today'),
          Example(yomikata: 'きる', word: '切る', mean: isKo ? '자르다' : 'Cut'),
          Example(yomikata: 'きらい', word: '嫌い', mean: isKo ? '싫어하다' : 'Dislike'),
        ],
      ),
      SubHiragana(
        hiragana: 'く',
        kSound: isKo ? '쿠' : 'ku',
        eSound: 'ku',
        examples: [
          Example(yomikata: 'くに', word: '国', mean: isKo ? '나라' : 'Country'),
          Example(yomikata: 'くる', word: '来る', mean: isKo ? '오다' : 'Come'),
          Example(yomikata: 'くち', word: '口', mean: isKo ? '입' : 'Mouth'),
        ],
      ),
      SubHiragana(
        hiragana: 'け',
        kSound: isKo ? '케' : 'ke',
        eSound: 'ke',
        examples: [
          Example(
            yomikata: 'けす',
            word: '消す',
            mean: isKo ? '지우다' : 'Erase/Turn off',
          ),
          Example(yomikata: 'けっこん', word: '結婚', mean: isKo ? '결혼' : 'Marriage'),
        ],
      ),
      SubHiragana(
        hiragana: 'こ',
        kSound: isKo ? '코' : 'ko',
        eSound: 'ko',
        examples: [
          Example(
            yomikata: 'こえ',
            word: '声',
            mean: isKo ? '목소리,소리' : 'Voice/Sound',
          ),
          Example(
            yomikata: 'こまる',
            word: '困る',
            mean: isKo ? '곤란하다' : 'Be in trouble',
          ),
          Example(
            yomikata: 'こたえる',
            word: '答える',
            mean: isKo ? '대답하다' : 'Answer',
          ),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'さ',
    subHiragana: [
      SubHiragana(
        hiragana: 'さ',
        kSound: isKo ? '사' : 'sa',
        eSound: 'sa',
        examples: [
          Example(
            yomikata: 'さき',
            word: '先',
            mean: isKo ? '선두,먼저' : 'Ahead/First',
          ),
          Example(
            yomikata: 'さんぽ',
            word: '散歩',
            mean: isKo ? '산책' : 'Walk/Stroll',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'し',
        kSound: isKo ? '시' : 'shi',
        eSound: 'shi',
        examples: [
          Example(yomikata: 'しごと', word: '仕事', mean: isKo ? '일' : 'Work/Job'),
          Example(yomikata: 'しお', word: '塩', mean: isKo ? '소금' : 'Salt'),
          Example(yomikata: 'しぬ', word: '死ぬ', mean: isKo ? '죽다' : 'Die'),
        ],
      ),
      SubHiragana(
        hiragana: 'す',
        kSound: isKo ? '스' : 'su',
        eSound: 'su',
        examples: [
          Example(yomikata: 'すこし', word: '少し', mean: isKo ? '조금' : 'A little'),
          Example(yomikata: 'すきだ', word: '好きだ', mean: isKo ? '좋아하다' : 'Like'),
          Example(yomikata: 'すわる', word: '座る', mean: isKo ? '앉다' : 'Sit'),
        ],
      ),
      SubHiragana(
        hiragana: 'せ',
        kSound: isKo ? '세' : 'se',
        eSound: 'se',
        examples: [
          Example(
            yomikata: 'せん',
            word: '千',
            mean: isKo ? '1000' : 'One thousand',
          ),
          Example(yomikata: 'せんせい', word: '先生', mean: isKo ? '선생님' : 'Teacher'),
          Example(yomikata: 'せんたく', word: '洗濯', mean: isKo ? '세탁' : 'Laundry'),
        ],
      ),
      SubHiragana(
        hiragana: 'そ',
        kSound: isKo ? '소' : 'so',
        eSound: 'so',
        examples: [
          Example(yomikata: 'そうじ', word: '掃除', mean: isKo ? '청소' : 'Cleaning'),
          Example(yomikata: 'そら', word: '空', mean: isKo ? '하늘' : 'Sky'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'た',
    subHiragana: [
      SubHiragana(
        hiragana: 'た',
        kSound: isKo ? '타' : 'ta',
        eSound: 'ta',
        examples: [
          Example(yomikata: 'たつ', word: '立つ', mean: isKo ? '서다' : 'Stand'),
          Example(yomikata: 'たまご', word: '卵', mean: isKo ? '계란' : 'Egg'),
          Example(
            yomikata: 'たいせつ',
            word: '大切',
            mean: isKo ? '중요함' : 'Important',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ち',
        kSound: isKo ? '치' : 'chi',
        eSound: 'chi',
        examples: [
          Example(
            yomikata: 'ちゅう',
            word: '中',
            mean: isKo ? '중' : 'Middle/Inside',
          ),
          Example(
            yomikata: 'ちかい',
            word: '近い',
            mean: isKo ? '가깝다' : 'Near/Close',
          ),
          Example(yomikata: 'ちいさい', word: '小さい', mean: isKo ? '작다' : 'Small'),
        ],
      ),
      SubHiragana(
        hiragana: 'つ',
        kSound: isKo ? '츠' : 'tsu',
        eSound: 'tsu',
        examples: [
          Example(yomikata: 'つくる', word: '作る', mean: isKo ? '만들다' : 'Make'),
          Example(yomikata: 'つぎ', word: '次', mean: isKo ? '다음' : 'Next'),
          Example(yomikata: 'つき', word: '月', mean: isKo ? '달' : 'Moon/Month'),
          Example(
            yomikata: 'つかれる',
            word: '疲れる',
            mean: isKo ? '피곤하다' : 'Get tired',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'て',
        kSound: isKo ? '테' : 'te',
        eSound: 'te',
        examples: [
          Example(yomikata: 'て', word: '手', mean: isKo ? '손' : 'Hand'),
          Example(
            yomikata: 'てつだう',
            word: '手伝う',
            mean: isKo ? '돕다' : 'Help/Assist',
          ),
          Example(yomikata: 'てつ', word: '鉄', mean: isKo ? '철' : 'Iron'),
        ],
      ),
      SubHiragana(
        hiragana: 'と',
        kSound: isKo ? '토' : 'to',
        eSound: 'to',
        examples: [
          Example(yomikata: 'とり', word: '鳥', mean: isKo ? '새' : 'Bird'),
          Example(
            yomikata: 'とき',
            word: '時',
            mean: isKo ? '시간, 시각' : 'Time/Hour',
          ),
          Example(yomikata: 'とおい', word: '遠い', mean: isKo ? '멀다' : 'Far'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'な',
    subHiragana: [
      SubHiragana(
        hiragana: 'な',
        kSound: isKo ? '나' : 'na',
        eSound: 'na',
        examples: [
          Example(yomikata: 'なつ', word: '夏', mean: isKo ? '여름' : 'Summer'),
          Example(yomikata: 'なまえ', word: '名前', mean: isKo ? '이름' : 'Name'),
          Example(yomikata: 'ならう', word: '習う', mean: isKo ? '배우다' : 'Learn'),
        ],
      ),
      SubHiragana(
        hiragana: 'に',
        kSound: isKo ? '니' : 'ni',
        eSound: 'ni',
        examples: [
          Example(yomikata: 'にく', word: '肉', mean: isKo ? '고기' : 'Meat'),
          Example(yomikata: 'にわ', word: '庭', mean: isKo ? '정원' : 'Garden'),
          Example(
            yomikata: 'にちようび',
            word: '日曜日',
            mean: isKo ? '일요일' : 'Sunday',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ぬ',
        kSound: isKo ? '누' : 'nu',
        eSound: 'nu',
        examples: [
          Example(
            yomikata: 'ぬぐ',
            word: '脱ぐ',
            mean: isKo ? '벗다' : 'Take off (clothes)',
          ),
          Example(yomikata: 'ぬし', word: '主', mean: isKo ? '주인' : 'Owner'),
          Example(yomikata: 'ぬま', word: '沼', mean: isKo ? '늪' : 'Swamp'),
        ],
      ),
      SubHiragana(
        hiragana: 'ね',
        kSound: isKo ? '네' : 'ne',
        eSound: 'ne',
        examples: [
          Example(yomikata: 'ねる', word: '寝る', mean: isKo ? '자다' : 'Sleep'),
          Example(yomikata: 'ねむい', word: '眠い', mean: isKo ? '졸립다' : 'Sleepy'),
          Example(yomikata: 'ねこ', word: '猫', mean: isKo ? '고양이' : 'Cat'),
          Example(yomikata: 'ねつ', word: '熱', mean: isKo ? '열' : 'Fever/Heat'),
        ],
      ),
      SubHiragana(
        hiragana: 'の',
        kSound: isKo ? '노' : 'no',
        eSound: 'no',
        examples: [
          Example(
            yomikata: '~の',
            word: '~の',
            mean: isKo ? '~의' : 'of (possessive)',
          ),
          Example(
            yomikata: 'のんびり',
            word: 'のんびり',
            mean: isKo ? '한가로이' : 'Leisurely',
          ),
          Example(yomikata: 'のぼる', word: '登る', mean: isKo ? '오르다' : 'Climb'),
          Example(yomikata: 'のむ', word: '飲む', mean: isKo ? '마시다' : 'Drink'),
          Example(yomikata: 'のる', word: '乗る', mean: isKo ? '타다' : 'Ride'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'は',
    subHiragana: [
      SubHiragana(
        hiragana: 'は',
        kSound: isKo ? '하' : 'ha',
        eSound: 'ha',
        examples: [
          Example(yomikata: 'はいゆう', word: '俳優', mean: isKo ? '배우' : 'Actor'),
          Example(yomikata: 'はしる', word: '走る', mean: isKo ? '달리다' : 'Run'),
          Example(
            yomikata: 'はじめる',
            word: '始める',
            mean: isKo ? '시작하다' : 'Start/Begin',
          ),
          Example(yomikata: 'はたらく', word: '働く', mean: isKo ? '일하다' : 'Work'),
        ],
      ),
      SubHiragana(
        hiragana: 'ひ',
        kSound: isKo ? '히' : 'hi',
        eSound: 'hi',
        examples: [
          Example(
            yomikata: 'ひまだ',
            word: '暇だ',
            mean: isKo ? '한가하다' : 'Be free/Leisure time',
          ),
          Example(
            yomikata: 'ひろい',
            word: '広い',
            mean: isKo ? '넓다' : 'Wide/Spacious',
          ),
          Example(yomikata: 'ひ', word: '火', mean: isKo ? '불' : 'Fire'),
        ],
      ),
      SubHiragana(
        hiragana: 'ふ',
        kSound: isKo ? '후' : 'fu',
        eSound: 'fu',
        examples: [
          Example(yomikata: 'ふく', word: '服', mean: isKo ? '옷' : 'Clothes'),
          Example(
            yomikata: 'ふね',
            word: '船',
            mean: isKo ? '배 (탈 것)' : 'Boat/Ship',
          ),
          Example(yomikata: 'ふとい', word: '太い', mean: isKo ? '두껍다' : 'Thick'),
        ],
      ),
      SubHiragana(
        hiragana: 'へ',
        kSound: isKo ? '헤' : 'he',
        eSound: 'he',
        examples: [
          Example(yomikata: 'へそ', word: '臍', mean: isKo ? '배꼽' : 'Navel'),
          Example(yomikata: 'へる', word: '減る', mean: isKo ? '줄다' : 'Decrease'),
          Example(yomikata: 'へいわ', word: '平和', mean: isKo ? '평화' : 'Peace'),
        ],
      ),
      SubHiragana(
        hiragana: 'ほ',
        kSound: isKo ? '호' : 'ho',
        eSound: 'ho',
        examples: [
          Example(yomikata: 'ほし', word: '星', mean: isKo ? '별' : 'Star'),
          Example(yomikata: 'ほん', word: '本', mean: isKo ? '책' : 'Book'),
          Example(yomikata: 'ほしい', word: '欲しい', mean: isKo ? '하고싶다' : 'Want'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ま',
    subHiragana: [
      SubHiragana(
        hiragana: 'ま',
        kSound: isKo ? '마' : 'ma',
        eSound: 'ma',
        examples: [
          Example(yomikata: 'まど', word: '窓', mean: isKo ? '창문' : 'Window'),
          Example(yomikata: 'まるい', word: '丸い', mean: isKo ? '둥글다' : 'Round'),
          Example(yomikata: 'まつ', word: '待つ', mean: isKo ? '기다리다' : 'Wait'),
        ],
      ),
      SubHiragana(
        hiragana: 'み',
        kSound: isKo ? '미' : 'mi',
        eSound: 'mi',
        examples: [
          Example(yomikata: 'みみ', word: '耳', mean: isKo ? '귀' : 'Ear'),
          Example(yomikata: 'みず', word: '水', mean: isKo ? '물' : 'Water'),
          Example(yomikata: 'みせ', word: '店', mean: isKo ? '가게' : 'Shop'),
          Example(yomikata: 'みる', word: '見る', mean: isKo ? '보다' : 'See/Look'),
        ],
      ),
      SubHiragana(
        hiragana: 'む',
        kSound: isKo ? '무' : 'mu',
        eSound: 'mu',
        examples: [
          Example(yomikata: 'むし', word: '虫', mean: isKo ? '벌레' : 'Insect'),
          Example(yomikata: 'むら', word: '村', mean: isKo ? '마을' : 'Village'),
          Example(yomikata: 'むね', word: '胸', mean: isKo ? '가슴' : 'Chest'),
        ],
      ),
      SubHiragana(
        hiragana: 'め',
        kSound: isKo ? '메' : 'me',
        eSound: 'me',
        examples: [
          Example(yomikata: 'め', word: '目', mean: isKo ? '눈' : 'Eye'),
          Example(yomikata: 'めし', word: '飯', mean: isKo ? '밥' : 'Meal/Rice'),
          Example(yomikata: 'めがね', word: '眼鏡', mean: isKo ? '안경' : 'Glasses'),
        ],
      ),
      SubHiragana(
        hiragana: 'も',
        kSound: isKo ? '모' : 'mo',
        eSound: 'mo',
        examples: [
          Example(yomikata: 'もり', word: '森', mean: isKo ? '숲' : 'Forest'),
          Example(yomikata: 'もん', word: '門', mean: isKo ? '문' : 'Gate'),
          Example(
            yomikata: 'もの',
            word: '物',
            mean: isKo ? '물건' : 'Thing/Object',
          ),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'や',
    subHiragana: [
      SubHiragana(
        hiragana: 'や',
        kSound: isKo ? '야' : 'ya',
        eSound: 'ya',
        examples: [
          Example(yomikata: 'やくそく', word: '約束', mean: isKo ? '약속' : 'Promise'),
          Example(
            yomikata: 'やど',
            word: '宿',
            mean: isKo ? '묵을 곳, 숙박' : 'Lodging/Inn',
          ),
          Example(
            yomikata: 'やこう',
            word: '夜行',
            mean: isKo ? '야행' : 'Night travel',
          ),
          Example(
            yomikata: 'やきにく',
            word: '焼き肉',
            mean: isKo ? '야키니쿠' : 'Yakiniku (grilled meat)',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ゆ',
        kSound: isKo ? '유' : 'yu',
        eSound: 'yu',
        examples: [
          Example(yomikata: 'ゆうしょく', word: '夕食', mean: isKo ? '저녁밥' : 'Dinner'),
          Example(yomikata: 'ゆ', word: '湯', mean: isKo ? '뜨거운 물' : 'Hot water'),
          Example(yomikata: 'ゆき', word: '雪', mean: isKo ? '눈' : 'Snow'),
          Example(
            yomikata: 'ゆっくり',
            word: 'ゆっくり',
            mean: isKo ? '천천히' : 'Slowly',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'よ',
        kSound: isKo ? '요' : 'yo',
        eSound: 'yo',
        examples: [
          Example(yomikata: 'よ', word: '世', mean: isKo ? '세상' : 'World'),
          Example(yomikata: 'よる', word: '夜', mean: isKo ? '밤' : 'Night'),
          Example(
            yomikata: 'よる',
            word: '寄る',
            mean: isKo ? '접근하다, 다가가다' : 'Approach/Drop by',
          ),
          Example(
            yomikata: 'よっぱらう',
            word: '酔っ払う',
            mean: isKo ? '(술에) 취하다' : 'Get drunk',
          ),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'ら',
    subHiragana: [
      SubHiragana(
        hiragana: 'ら',
        kSound: isKo ? '라' : 'ra',
        eSound: 'ra',
        examples: [
          Example(
            yomikata: 'らいねん',
            word: '来年',
            mean: isKo ? '내년' : 'Next year',
          ),
          Example(
            yomikata: 'らいしゅう',
            word: '来週',
            mean: isKo ? '다음 주' : 'Next week',
          ),
          Example(
            yomikata: 'らいげつ',
            word: '来月',
            mean: isKo ? '다음 달' : 'Next month',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'り',
        kSound: isKo ? '리' : 'ri',
        eSound: 'ri',
        examples: [
          Example(
            yomikata: 'りれきしょ',
            word: '履歴書',
            mean: isKo ? '이력서' : 'Resume/CV',
          ),
          Example(
            yomikata: 'りっぱだ',
            word: '立派だ',
            mean: isKo ? '훌륭하다' : 'Excellent/Magnificent',
          ),
          Example(
            yomikata: 'りかい',
            word: '理解',
            mean: isKo ? '이해' : 'Understanding',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'る',
        kSound: isKo ? '루' : 'ru',
        eSound: 'ru',
        examples: [
          Example(
            yomikata: 'るす',
            word: '留守',
            mean: isKo ? '부재중' : 'Not at home/Absence',
          ),
          Example(
            yomikata: 'るいじ',
            word: '類似',
            mean: isKo ? '유사' : 'Similarity',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'れ',
        kSound: isKo ? '레' : 're',
        eSound: 're',
        examples: [
          Example(
            yomikata: 'れいがい',
            word: '例外',
            mean: isKo ? '예외' : 'Exception',
          ),
          Example(yomikata: 'れっしゃ', word: '列車', mean: isKo ? '열차' : 'Train'),
          Example(yomikata: 'れいとう', word: '冷凍', mean: isKo ? '냉동' : 'Freezing'),
        ],
      ),
      SubHiragana(
        hiragana: 'ろ',
        kSound: isKo ? '로' : 'ro',
        eSound: 'ro',
        examples: [
          Example(
            yomikata: 'ろうじん',
            word: '老人',
            mean: isKo ? '노인' : 'Old person',
          ),
          Example(
            yomikata: 'ろくおん',
            word: '録音',
            mean: isKo ? '녹음' : 'Recording',
          ),
          Example(yomikata: 'ろうどう', word: '労働', mean: isKo ? '노동' : 'Labor'),
        ],
      ),
    ],
  ),
  Hiragana(
    hiragana: 'わ',
    subHiragana: [
      SubHiragana(
        hiragana: 'わ',
        kSound: isKo ? '와' : 'wa',
        eSound: 'wa',
        examples: [
          Example(
            yomikata: 'わかわかしい',
            word: '若々しい',
            mean: isKo ? '젊어 보인다' : 'Youthful',
          ),
          Example(yomikata: 'わかれ', word: '別れ', mean: isKo ? '헤어짐' : 'Parting'),
          Example(
            yomikata: 'わかる',
            word: '分かる',
            mean: isKo ? '알다' : 'Understand',
          ),
          Example(yomikata: 'わらう', word: '笑う', mean: isKo ? '웃다' : 'Laugh'),
          Example(yomikata: 'わるい', word: '悪い', mean: isKo ? '나쁘다' : 'Bad'),
        ],
      ),
      SubHiragana(
        hiragana: 'を',
        kSound: isKo ? '오' : 'wo',
        eSound: 'wo',
        examples: [
          Example(
            word: '~を',
            yomikata: '~を',
            mean: isKo ? '~를' : 'object marker ~o',
          ),
        ],
      ),
      SubHiragana(
        hiragana: 'ん',
        kSound: isKo ? '응' : 'n',
        eSound: 'n',
        examples: [],
      ),
    ],
  ),
];

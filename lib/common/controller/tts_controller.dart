import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/logger/logger_service.dart';
import 'package:jlpt_jonggack/common/utils/snackbar_helper.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

/// 앱 전역에서 하나만 생성되어 사용하는 TTS 컨트롤러.
/// - _isPlaying: TTS가 현재 재생 중인지 여부
/// - currentWord: 현재 재생 중인 단어
class TtsController extends GetxController {
  static TtsController get to => Get.find<TtsController>();

  late final FlutterTts _tts;

  final RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;

  /// 현재 재생 중인 단어 (''이면 재생 중 아님)
  final RxString currentWord = ''.obs;

  // ✅ 선택된 보이스 캐시 (로그/디버그용)
  Map<String, dynamic>? _selectedVoice;

  @override
  void onInit() async {
    super.onInit();
    _tts = FlutterTts();

    // flutter_tts 4.2.3에서는 awaitSpeakCompletion 옵션을 설정해야
    // speak() 호출 후 onComplete 콜백이 정상 동작합니다.
    _tts.awaitSpeakCompletion(true);

    if (GetPlatform.isIOS) {
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }

    if (GetPlatform.isAndroid) {
      await getDefaultEngine();
      await getDefaultVoice();
    }

    // ✅ 초기 설정: 일본어 + 네이티브 보이스 선택
    await _initJapaneseVoice();

    // 재생 완료 시 호출되는 콜백
    _tts.setCompletionHandler(() {
      _isPlaying.value = false;
      currentWord.value = '';
    });

    // 에러 발생 시 호출되는 콜백
    _tts.setErrorHandler((msg) {
      _isPlaying.value = false;
      currentWord.value = '';
      LogManager.error('TTS error: $msg');
    });
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }

  Future getDefaultEngine() async {
    try {
      final engine = await _tts.getDefaultEngine;
      if (engine != null) {
        LogManager.info('Default TTS Engine: $engine');
      }
    } catch (e) {
      LogManager.error('getDefaultEngine error: $e');
    }
  }

  Future getDefaultVoice() async {
    try {
      final voice = await _tts.getDefaultVoice;
      if (voice != null) {
        LogManager.info('Default Voice: $voice');
      }
    } catch (e) {
      LogManager.error('getDefaultVoice error: $e');
    }
  }

  /// ✅ 일본어(ja-JP) 설정 + 가능한 한 네이티브(고품질) 보이스 선택
  Future<void> _initJapaneseVoice() async {
    try {
      await _tts.setLanguage('ja-JP');

      // 보이스 목록 가져오기
      final voices = await _tts.getVoices;
      if (voices is! List) {
        LogManager.info('getVoices returned non-list: $voices');
        return;
      }

      // ja-JP만 필터
      final jaVoices =
          voices
              .whereType<Map>()
              .where(
                (v) => (v['locale']?.toString().toLowerCase() ?? '') == 'ja-jp',
              )
              .toList();

      if (jaVoices.isEmpty) {
        LogManager.info('No ja-JP voices found on this device.');
        return;
      }

      // 디버그: 어떤 보이스가 있는지 보고 싶으면 주석 해제
      // for (final v in jaVoices) {
      //   LogManager.info('ja voice: $v');
      // }

      final best = _pickBestJapaneseVoice(jaVoices);
      if (best == null) return;

      // setVoice는 플랫폼별로 허용 필드가 다를 수 있어 최소 필드부터
      final voicePayload = <String, String>{
        'name': best['name']?.toString() ?? '',
        'locale': best['locale']?.toString() ?? 'ja-JP',
      };

      // iOS에서 identifier가 제공되는 경우가 있어서 있으면 같이 전달
      final identifier = best['identifier']?.toString();
      if (identifier != null && identifier.isNotEmpty) {
        // flutter_tts가 identifier를 받아들이는 기기/버전이 있음
        voicePayload['identifier'] = identifier;
      }

      await _tts.setVoice(voicePayload);

      _selectedVoice = {
        'name': voicePayload['name'],
        'locale': voicePayload['locale'],
        if (voicePayload['identifier'] != null)
          'identifier': voicePayload['identifier'],
      };

      LogManager.info('Selected ja-JP voice: $_selectedVoice');
    } catch (e) {
      LogManager.error('_initJapaneseVoice error: $e');
    }
  }

  /// ✅ “네이티브하게 들릴 확률이 높은” 보이스 선택 규칙
  /// 우선순위:
  /// 1) quality에 enhanced 같은 키워드가 있으면 최우선 (주로 iOS)
  /// 2) name에 일본어 보이스로 흔한 키워드(kyoko/otoya 등)가 있으면 우선 (있을 때만)
  /// 3) 아니면 첫 번째
  Map<String, dynamic>? _pickBestJapaneseVoice(List<Map> jaVoices) {
    // helper: Map<dynamic,dynamic> -> Map<String,dynamic> 안전 변환
    Map<String, dynamic> normalize(Map v) {
      return v.map((key, value) => MapEntry(key.toString(), value));
    }

    // 1) Enhanced/High quality 우선
    for (final v in jaVoices) {
      final m = normalize(v);
      final q = (m['quality']?.toString().toLowerCase() ?? '');
      if (q.contains('enhanced') || q.contains('high')) {
        return m;
      }
    }

    // 2) 이름 기반 (있으면 우선)
    for (final v in jaVoices) {
      final m = normalize(v);
      final name = (m['name']?.toString().toLowerCase() ?? '');
      if (name.contains('kyoko') || name.contains('otoya')) {
        return m;
      }
    }

    // 3) fallback
    return normalize(jaVoices.first);
  }

  /// [word]를 TTS로 재생함.
  /// 이미 재생 중이면 먼저 중단 후 새로 재생.
  Future<void> speak(String word) async {
    try {
      // 언어, 속도, 볼륨, 음조 등 기본 설정
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(SettingController.to.speechRate.value);
      await _tts.setVolume(SettingController.to.volumn.value);
      await _tts.setPitch(SettingController.to.pitch.value);

      // ✅ 일본어 억양 개선용: 일본어 문장 부호가 없으면 살짝 붙여주는 옵션
      // (단어 단위라면 굳이 안 붙여도 됨. 문장일 때만 추천)
      final speakText = _normalizeJapaneseForTts(word);

      // 동일한 단어가 이미 재생 중이면 아무 동작 안 함
      if (_isPlaying.value && currentWord.value == speakText) return;

      // 다른 단어가 재생 중이라면 먼저 중단
      if (_isPlaying.value) {
        await _tts.stop();
      }

      currentWord.value = speakText;
      _isPlaying.value = true;

      await _tts.speak(speakText);
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(e.toString(), isLog: true);
    }
  }

  /// 재생 중인 TTS 멈춤
  Future<void> stop() async {
    if (_isPlaying.value) {
      await _tts.stop();
      _isPlaying.value = false;
      currentWord.value = '';
    }
  }

  /// ✅ 일본어 TTS 자연스럽게 들리게 하는 간단한 전처리
  /// - 문장인데 끝에 마침표/물음표/느낌표가 없으면 "。" 추가
  /// - (원하면 여기서 숫자/로마자 읽기 변환도 확장 가능)
  String _normalizeJapaneseForTts(String text) {
    final t = text.trim();
    if (t.isEmpty) return t;

    // “단어 하나”면 굳이 붙이지 않도록 아주 간단히: 공백이 없고 길이가 짧으면 그대로
    final looksLikeSingleWord = !t.contains(' ') && t.length <= 12;
    if (looksLikeSingleWord) return t;

    final endsWithPunc = RegExp(r'[。．\.\?\!？！…]$').hasMatch(t);
    if (endsWithPunc) return t;

    return '$t。';
  }
}

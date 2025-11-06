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

  @override
  void onInit() async {
    super.onInit();
    _tts = FlutterTts();

    // flutter_tts 4.2.3에서는 awaitSpeakCompletion 옵션을 설정해야
    // speak() 호출 후 onComplete 콜백이 정상 동작합니다.
    _tts.awaitSpeakCompletion(true);

    // 언어, 속도, 볼륨, 음조 등 기본 설정
    // _tts.setSpeechRate(0.5);
    // _tts.setVolume(1.0);
    // _tts.setPitch(1.0);

    if (GetPlatform.isIOS) {
      await _tts.setIosAudioCategory(
        // IosTextToSpeechAudioCategory.playback,
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
      getDefaultEngine();
      getDefaultVoice();
    }

    // 재생 완료 시 호출되는 콜백
    _tts.setCompletionHandler(() {
      _isPlaying.value = false;
      currentWord.value = '';
    });

    // 에러 발생 시 호출되는 콜백
    _tts.setErrorHandler((msg) {
      _isPlaying.value = false;
      currentWord.value = '';
    });
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }

  Future getDefaultEngine() async {
    var engine = await _tts.getDefaultEngine;
    if (engine != null) {
      LogManager.info(engine);
    }
  }

  Future getDefaultVoice() async {
    var voice = await _tts.getDefaultVoice;
    if (voice != null) {
      LogManager.info(voice);
    }
  }

  /// [word]를 TTS로 재생함.
  /// 이미 재생 중이면 먼저 중단 후 새로 재생.
  Future<void> speak(String word) async {
    try {
      _tts.setLanguage('ja-JP');
      _tts.setSpeechRate(SettingController.to.speechRate.value);
      _tts.setVolume(SettingController.to.volumn.value);
      _tts.setPitch(SettingController.to.pitch.value);
      // 동일한 단어가 이미 재생 중이면 아무 동작 안 함
      if (_isPlaying.value && currentWord.value == word) return;
      // 다른 단어가 재생 중이라면 먼저 중단
      if (_isPlaying.value) {
        await _tts.stop();
        // onComplete 콜백에서 _isPlaying, currentWord가 자동으로 false/''로 변함
      }

      currentWord.value = word;
      _isPlaying.value = true;
      await _tts.speak(word);
      // flutter_tts 설정상 awaitSpeakCompletion(true)를 설정했기 때문에,
      // speak()가 끝나면 setCompletionHandler가 반드시 호출됩니다.
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
}

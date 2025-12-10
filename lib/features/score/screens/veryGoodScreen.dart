import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:jlpt_jonggack/common/admob/banner_ad/global_banner_admob.dart';
import 'package:jlpt_jonggack/common/commonDialog.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/features/setting/controller/setting_controller.dart';

class VeryGoodScreen extends StatelessWidget {
  const VeryGoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: Center(child: CelebrationScreen())),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const GlobalBannerAdmob()],
        ),
      ),
    );
  }
}

class CelebrationScreen extends StatefulWidget {
  const CelebrationScreen({super.key});

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
              ],
            ),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: isEn ? 'Congratulations!\n' : '축하합니다!\n',
                children: [
                  TextSpan(
                    text: isEn ? 'Perfect Score: 100\n' : '100점',
                    style: TextStyle(fontSize: 40, color: Colors.redAccent),
                  ),
                  TextSpan(text: isEn ? '\n\n' : '입니다!!\n\n'),
                  TextSpan(
                    text:
                        isEn
                            ? 'You’re one step closer to passing the JLPT!\nKeep it up and stay motivated!'
                            : 'JLPT합격까지 한 발자국 나아가셨습니다.\n조금만 더 화이팅합시다~',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.japaneseFont,
                  color: SettingController.to.realBlackOrWhite,
                ),
              ),
            ),
            SizedBox(height: 30),
            const JonggackAvator(),
          ],
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
        ),
      ],
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlpt_jonggack/common/common.dart';
import 'package:jlpt_jonggack/common/utils/show_bottom_sheet.dart';
import 'package:jlpt_jonggack/config/colors.dart';
import 'package:jlpt_jonggack/config/theme.dart';
import 'package:jlpt_jonggack/core/app_string.dart';
import 'package:kanji_drawing_animation/kanji_drawing_animation.dart';

TextButton howToRightBtn(BuildContext context, String word) {
  return TextButton(
    onPressed: () {
      showCustomBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: KanjiStrokeViewer(japanese: word),
      );
    },
    child: Text(
      AppString.strokeOrder.tr,
      style: TextStyle(color: AppColors.mainBordColor),
    ),
  );
}

class KanjiStrokeViewer extends StatefulWidget {
  const KanjiStrokeViewer({super.key, required this.japanese});
  final String japanese;

  @override
  State<KanjiStrokeViewer> createState() => _KanjiStrokeViewerState();
}

class _KanjiStrokeViewerState extends State<KanjiStrokeViewer> {
  late final List<String> _chars; // 전체 문자
  late final List<String> _kanji; // 한자만
  late final List<int> _kanjiPos; // 한자가 원문에서 차지하는 인덱스(상단 강조용)

  int _current = 0; // 현재 '한자 리스트' 인덱스

  @override
  void initState() {
    super.initState();
    _chars = widget.japanese.characters.toList();

    _kanji = <String>[];
    _kanjiPos = <int>[];
    for (var i = 0; i < _chars.length; i++) {
      if (isKangi(_chars[i])) {
        _kanji.add(_chars[i]);
        _kanjiPos.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 상단 한 줄: 현재 보고있는 한자의 원문 위치만 강조
    final highlightedIndex = _kanjiPos.isEmpty ? -1 : _kanjiPos[_current];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: double.infinity),

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(_chars.length, (i) {
            final isHL = i == highlightedIndex;
            return Text(
              _chars[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.japaneseFont,
                fontSize: isHL ? 40 : 30,
                fontWeight: isHL ? FontWeight.bold : FontWeight.normal,
                color: isHL ? AppColors.mainColor : null,
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // ✨ 여기 핵심: 현재 페이지에만 KanjiDrawingAnimation을 빌드
        CarouselSlider(
          items: List.generate(_kanji.length, (idx) {
            final isCurrent = idx == _current;

            if (isCurrent) {
              // 현재 항목만 애니메이션 시작 (다른 항목은 아예 미빌드 → 선재생 방지)
              return SizedBox(
                width: 140,
                height: 140,
                child: KanjiDrawingAnimation(
                  _kanji[idx],
                  speed: 50, // 필요시 조절
                  key: ValueKey('kanji-${_kanji[idx]}-$idx'),
                ),
              );
            } else {
              // 비활성 페이지: 정적인 프리뷰(텍스트)만 표시
              return SizedBox(
                width: 140,
                height: 140,
                child: Center(
                  child: Text(
                    _kanji[idx],
                    style: const TextStyle(
                      fontFamily: AppFonts.japaneseFont,
                      fontSize: 72,
                      color: Colors.black38,
                    ),
                  ),
                ),
              );
            }
          }),
          options: CarouselOptions(
            disableCenter: true,
            viewportFraction: 0.75,
            enableInfiniteScroll: false,
            initialPage: _current,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
        ),

        const SizedBox(height: 24),

        if (_kanji.length > 1)
          Wrap(
            children: List.generate(_kanji.length, (i) {
              final active = i == _current;
              return Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? AppColors.mainBordColor : Colors.grey,
                ),
              );
            }),
          )
        else
          Container(height: 18),

        const SizedBox(height: 32),
        const SizedBox(height: 16),
      ],
    );
  }
}

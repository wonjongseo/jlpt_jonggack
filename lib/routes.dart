import 'package:get/get.dart';

import 'package:jlpt_jonggack/features/grammar_test/grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/calendar_step/grammar_calendar_step_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/features/my_book/screens/widgets/edit_book_screen.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_step_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/controllers/new_grammar_test_controller.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_step_screen.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/new_grammar_test_screen.dart';
import 'package:jlpt_jonggack/features/new_grmmar/screen/widgets/new_grammar_card_detail.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_add_my_word_screen.dart';
import 'package:jlpt_jonggack/features/new_my_word/screen/new_my_word_screen.dart';
import 'package:jlpt_jonggack/features/setting/screen/setting_screen.dart';

import 'package:jlpt_jonggack/features/score/screens/kangi_score_screen.dart';
import 'package:jlpt_jonggack/features/score/screens/score_screen.dart';
import 'package:jlpt_jonggack/model/grammar.dart';
import 'package:jlpt_jonggack/model/grammar_step.dart';

import 'features/home/screens/home_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> getPages = [
    // GetPage(name: GrammarTestScreen.name, page: () => GrammarTestScreen()),
    GetPage(
      name: HomeScreen.name,
      page: () => const HomeScreen(),
      // page: () => NewHomeScreen(),
    ),
    GetPage(name: KANGI_SCORE_PATH, page: () => const KangiScoreScreen()),

    GetPage(name: EditBookScreen.name, page: () => EditBookScreen()),
    GetPage(name: NewMyWordScreen.name, page: () => NewMyWordScreen()),
    GetPage(name: NewAddMyWordScreen.name, page: () => NewAddMyWordScreen()),
    // GetPage(
    //   name: GrammarCalendarStepScreen.name,
    //   page: () => GrammarCalendarStepScreen(),
    // ),
    GetPage(
      name: NewGrammarStepScreen.name,
      page: () => NewGrammarStepScreen(),
      binding: BindingsBuilder.put(() {
        final grammars = Get.arguments['grammars'] as GrammarStep;
        final chapter = Get.arguments['chapter'] as String;

        return NewGrammarStepController(grammars, chapter);
      }),
    ),
    GetPage(
      name: NewGrammarCardDetail.name,
      page: () {
        final index = Get.arguments as int;
        return NewGrammarCardDetail(index: index);
      },
    ),
    GetPage(
      name: NewGrammarTestScreen.name,
      page: () => NewGrammarTestScreen(),
      binding: BindingsBuilder.put(() {
        final grammars = Get.arguments['grammarStep'] as GrammarStep;
        final isRandom = Get.arguments['isRandom'] as bool?;
        final isTextAgain = Get.arguments['isTextAgain'] as bool?;
        final isRecord = Get.arguments['isRecord'] as bool?;
        final isMyWord = Get.arguments['isMyWord'] as bool?;
        return NewGrammarTestController(
          grammars,
          isRandom ?? false,
          isTextAgain ?? false,
          isRecord ?? true,
          isMyWord ?? false,
        );
      }),
    ),
    GetPage(name: JlptTestScreen.name, page: () => const JlptTestScreen()),
    GetPage(name: KangiTestScreen.name, page: () => const KangiTestScreen()),
    GetPage(name: SettingScreen.name, page: () => const SettingScreen()),
    GetPage(name: ScoreScreen.name, page: () => const ScoreScreen()),
  ];
}

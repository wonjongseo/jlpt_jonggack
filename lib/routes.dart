import 'package:get/get.dart';
import 'package:jlpt_jonggack/features/basic/hiragana/screens/hiragana_screen.dart';
import 'package:jlpt_jonggack/features/jlpt_home/screens/jlpt_home_screen.dart';

import 'package:jlpt_jonggack/features/jlpt_test/screens/jlpt_test_screen.dart';
import 'package:jlpt_jonggack/features/kangi_test/kangi_test_screen.dart';
import 'package:jlpt_jonggack/features/my_book/screens/widgets/edit_book_screen.dart';
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
import 'package:jlpt_jonggack/model/grammar_step.dart';

import 'features/home/screens/home_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> getPages = [
    GetPage(name: HomeScreen.name, page: () => const HomeScreen()),
    GetPage(
      name: JlptHomeScreen.name,
      page: () {
        final levelIndex = Get.arguments;
        return JlptHomeScreen(levelIndex: levelIndex);
      },
    ),
    GetPage(
      name: BasicScreen.name,
      page: () {
        final category = Get.arguments;
        return BasicScreen(category: category);
      },
    ),
    GetPage(
      name: KANGI_SCORE_PATH,
      page: () => const KangiScoreScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),

    GetPage(
      name: EditBookScreen.name,
      page: () => EditBookScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: NewMyWordScreen.name,
      page: () => NewMyWordScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: NewAddMyWordScreen.name,
      page: () => NewAddMyWordScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),

    GetPage(
      name: NewGrammarStepScreen.name,
      page: () => NewGrammarStepScreen(),
      binding: BindingsBuilder.put(() {
        final grammars = Get.arguments['grammars'] as GrammarStep;
        final chapter = Get.arguments['chapter'] as String;

        return NewGrammarStepController(grammars, chapter);
      }),
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: NewGrammarCardDetail.name,
      page: () {
        final index = Get.arguments as int;
        return NewGrammarCardDetail(index: index);
      },
      // middlewares: [AnalyticsMiddleware()],
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
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: JlptTestScreen.name,
      page: () => const JlptTestScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: KangiTestScreen.name,
      page: () => const KangiTestScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: SettingScreen.name,
      page: () => const SettingScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),
    GetPage(
      name: ScoreScreen.name,
      page: () => const ScoreScreen(),
      // middlewares: [AnalyticsMiddleware()],
    ),
  ];
}

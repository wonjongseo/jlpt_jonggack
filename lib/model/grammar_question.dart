import 'package:jlpt_jonggack/model/grammar.dart';

class GrammarQuestion {
  final int answerIdx;
  final Grammar question;
  final List<Grammar> options;

  GrammarQuestion({
    required this.answerIdx,
    required this.question,
    required this.options,
  });
}

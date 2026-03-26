import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/models/question_model.dart';
import '../../../shared/widgets/ekys_button.dart';
import '../../../shared/widgets/progress_bar.dart';
import 'quiz_provider.dart';

class QuizScreen extends ConsumerWidget {
  final String subtopicId;
  final String title;

  const QuizScreen({
    super.key,
    required this.subtopicId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizProvider(subtopicId));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (state.questions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSizes.md),
              child: Center(
                child: Text(
                  '${state.currentIndex + 1}/${state.questions.length}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(context, state, ref),
      bottomNavigationBar: _buildBottomBar(context, state, ref),
    );
  }

  Widget _buildBody(BuildContext context, QuizState state, WidgetRef ref) {
    if (state.isLoading && state.questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            ElevatedButton(
              onPressed: () => ref.read(quizProvider(subtopicId).notifier).loadQuestions(),
              child: const Text('Tekrar Dene'),
            )
          ],
        ),
      );
    }

    if (state.questions.isEmpty) {
      return const Center(child: Text('Bu konuya ait soru bulunamadı.'));
    }

    if (state.isFinished) {
      return _buildResultSummary(context, state, ref);
    }

    final question = state.questions[state.currentIndex];
    final selectedOption = state.selectedAnswers[state.currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Soru Metni
          Container(
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: context.theme.dividerColor.withOpacity(0.5)),
            ),
            child: Text(
              question.questionText,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),

          // Şıklar
          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            final isSelected = selectedOption == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: InkWell(
                onTap: () => ref.read(quizProvider(subtopicId).notifier).selectAnswer(index),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: isSelected ? context.colorScheme.primaryContainer : context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: isSelected ? context.colorScheme.primary : context.theme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? context.colorScheme.primary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? context.colorScheme.primary : context.theme.dividerColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              color: isSelected ? context.colorScheme.onPrimary : context.textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Text(
                          option.text,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: isSelected ? context.colorScheme.onPrimaryContainer : null,
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, QuizState state, WidgetRef ref) {
    if (state.questions.isEmpty || state.isFinished) return const SizedBox.shrink();

    final isLastQuestion = state.currentIndex == state.questions.length - 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            if (state.currentIndex > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => ref.read(quizProvider(subtopicId).notifier).previousQuestion(),
                  child: const Text('Önceki'),
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: AppSizes.md),
            Expanded(
              flex: 2,
              child: EkysButton(
                text: isLastQuestion ? 'Sınavı Bitir' : 'Sonraki',
                onPressed: () {
                  if (isLastQuestion) {
                    _showFinishDialog(context, ref);
                  } else {
                    ref.read(quizProvider(subtopicId).notifier).nextQuestion();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFinishDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sınavı Bitir'),
        content: const Text('Sınavı bitirmek istediğinize emin misiniz? İşaretlemediğiniz sorular yanlış sayılacaktır.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(quizProvider(subtopicId).notifier).finishQuiz();
            },
            child: const Text('Bitir'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary(BuildContext context, QuizState state, WidgetRef ref) {
    int correctCount = 0;
    for (int i = 0; i < state.questions.length; i++) {
        if (state.selectedAnswers[i] == state.questions[i].correctIndex) {
          correctCount++;
        }
    }
    final score = (correctCount / state.questions.length) * 100;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              score >= 70 ? Icons.emoji_events : Icons.sentiment_neutral,
              size: 100,
              color: score >= 70 ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(height: AppSizes.xl),
            Text(
              'Test Tamamlandı!',
              style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Puanınız',
              style: context.textTheme.titleMedium,
            ),
            Text(
              '${score.toInt()}',
              style: context.textTheme.displayLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              '$correctCount Doğru / ${state.questions.length} Soru',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.xxl),
            EkysButton(
              text: 'Sonuçları İncele',
              isOutlined: true,
              onPressed: () {
                // TODO: Sonuç detay ekranına git
                context.showSnackBar('Sonuç detayı geliştiriliyor.');
              },
            ),
            const SizedBox(height: AppSizes.md),
            EkysButton(
              text: 'Konulara Dön',
              onPressed: () {
                context.go('/topics');
              },
            ),
          ],
        ),
      ),
    );
  }
}

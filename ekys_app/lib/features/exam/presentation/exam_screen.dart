import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/helpers.dart';
import '../../../shared/widgets/ekys_button.dart';
import 'exam_provider.dart';

class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examProvider);
    final notifier = ref.read(examProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (state.isFinished) return true;
        
        final result = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Uyarı'),
            content: const Text('Sınavdan çıkmak istiyor musunuz? İlerlemeniz kaybedilecek.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Çık', style: TextStyle(color: Colors.red))),
            ],
          ),
        );
        return result ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deneme Sınavı'),
          actions: [
            if (!state.isFinished && state.questions.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSizes.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: state.remainingSeconds < 300 ? Colors.red.withOpacity(0.1) : context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: state.remainingSeconds < 300 ? Colors.red : context.colorScheme.primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: state.remainingSeconds < 300 ? Colors.red : context.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDuration(state.remainingSeconds),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state.remainingSeconds < 300 ? Colors.red : context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: _buildBody(context, state, notifier),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ExamState state, ExamNotifier notifier) {
    if (state.isLoading && state.questions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSizes.md),
            Text('Sınav hazırlanıyor... Lütfen bekleyin.'),
          ],
        ),
      );
    }

    if (state.error != null && state.questions.isEmpty) {
      return Center(child: Text(state.error!));
    }

    if (state.questions.isEmpty) {
      return const Center(child: Text('Sınav soruları yüklenemedi.'));
    }

    if (state.isFinished) {
      return _buildResultSummary(context, state);
    }

    final question = state.questions[state.currentIndex];
    final selectedOption = state.selectedAnswers[state.currentIndex];

    return Column(
      children: [
        // Soru Navigasyon Çubuğu (Optik Form benzeri)
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
            itemCount: state.questions.length,
            itemBuilder: (context, index) {
              final isCurrent = index == state.currentIndex;
              final isAnswered = state.selectedAnswers.containsKey(index) && state.selectedAnswers[index] != null;
              
              Color bgColor = context.colorScheme.surface;
              Color textColor = context.textTheme.bodyMedium?.color ?? Colors.black;
              
              if (isCurrent) {
                bgColor = context.colorScheme.primary;
                textColor = context.colorScheme.onPrimary;
              } else if (isAnswered) {
                bgColor = context.colorScheme.primaryContainer;
                textColor = context.colorScheme.onPrimaryContainer;
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => notifier.changeQuestion(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent ? context.colorScheme.primary : context.theme.dividerColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),

        // Soru İçeriği
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soru ${state.currentIndex + 1} / ${state.questions.length}',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => notifier.clearAnswer(),
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Boş Bırak'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  question.questionText,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
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
                      onTap: () => notifier.selectAnswer(index),
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
          ),
        ),

        // Alt Bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: state.currentIndex > 0 
                      ? () => notifier.changeQuestion(state.currentIndex - 1) 
                      : null,
                  child: const Text('Önceki'),
                ),
                
                if (state.currentIndex == state.questions.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                    onPressed: () => _showFinishDialog(context, notifier),
                    child: const Text('Sınavı Bitir'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => notifier.changeQuestion(state.currentIndex + 1),
                    child: const Text('Sonraki'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFinishDialog(BuildContext context, ExamNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sınavı Bitir'),
        content: const Text('Sınavı bitirmek istediğinize emin misiniz? İşaretlemediğiniz sorular boş bırakılmış sayılacaktır.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              notifier.finishExam();
            },
            child: const Text('Bitir'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary(BuildContext context, ExamState state) {
    int correctCt = 0;
    int wrongCt = 0;
    int emptyCt = 0;
    
    for (int i = 0; i < state.questions.length; i++) {
        final selected = state.selectedAnswers[i];
        if (selected == null) {
          emptyCt++;
        } else if (selected == state.questions[i].correctIndex) {
          correctCt++;
        } else {
          wrongCt++;
        }
    }
    
    final score = correctCt * 1.25;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              score >= 60 ? Icons.workspace_premium : Icons.sentiment_dissatisfied,
              size: 100,
              color: score >= 60 ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              score >= 60 ? 'Tebrikler! Sınavı Geçtiniz' : 'Maalesef Sınavı Geçemediniz',
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.xl),
            
            Container(
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: context.theme.dividerColor),
              ),
              child: Column(
                children: [
                  Text('EKYS Puanınız', style: context.textTheme.titleMedium),
                  Text(
                    score.toStringAsFixed(2),
                    style: context.textTheme.displayLarge?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCol(title: 'Doğru', val: '$correctCt', color: AppColors.success),
                      _StatCol(title: 'Yanlış', val: '$wrongCt', color: AppColors.error),
                      _StatCol(title: 'Boş', val: '$emptyCt', color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.xxl),
            EkysButton(
              text: 'Ayrıntılı Çözümler',
              isOutlined: true,
              onPressed: () {
                context.showSnackBar('Çözümler sayfası yapım aşamasında');
              },
            ),
            const SizedBox(height: AppSizes.md),
            EkysButton(
              text: 'Ana Sayfaya Dön',
              onPressed: () => context.go('/dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String title;
  final String val;
  final Color color;

  const _StatCol({required this.title, required this.val, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../services/supabase_service.dart';
import '../../../shared/models/question_model.dart';
import '../../../shared/widgets/ekys_button.dart';
import '../../../shared/widgets/ekys_card.dart';
import '../../../shared/widgets/loading_skeleton.dart';

// Çıkmış soru yıllarını çeken provider
final pastExamYearsProvider = FutureProvider<List<String>>((ref) async {
  return SupabaseService().getPastExamYears();
});

// Seçilen yılın sorularını çeken provider
final pastExamQuestionsProvider =
    FutureProvider.family<List<QuestionModel>, String>((ref, source) async {
  final data = await SupabaseService().getPastExamQuestions(source);
  return data.map((q) => QuestionModel.fromJson(q)).toList();
});

class PastExamsScreen extends ConsumerStatefulWidget {
  const PastExamsScreen({super.key});

  @override
  ConsumerState<PastExamsScreen> createState() => _PastExamsScreenState();
}

class _PastExamsScreenState extends ConsumerState<PastExamsScreen> {
  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final yearsAsync = ref.watch(pastExamYearsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Çıkmış Sorular'),
      ),
      body: yearsAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (years) {
          if (years.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Text(
                  'Henüz çıkmış soru eklenmemiş.\n\nSorulara "source" alanı olarak yıl bilgisi eklendiğinde burada listelenecektir.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (_selectedYear == null) {
            // Yıl Seçim Ekranı
            return _buildYearSelection(context, years);
          } else {
            // Seçilen yılın soruları
            return _buildQuestionsList(context);
          }
        },
      ),
    );
  }

  Widget _buildYearSelection(BuildContext context, List<String> years) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: years.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (context, index) {
        final year = years[index];
        return EkysCard(
          onTap: () => setState(() => _selectedYear = year),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colorScheme.primary,
                      context.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.history_edu, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      year,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Çıkmış soruları çöz',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.theme.dividerColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionsList(BuildContext context) {
    final questionsAsync = ref.watch(pastExamQuestionsProvider(_selectedYear!));

    return questionsAsync.when(
      loading: () => const ListSkeleton(),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (questions) {
        if (questions.isEmpty) {
          return const Center(child: Text('Bu yıla ait soru bulunamadı.'));
        }

        return Column(
          children: [
            // Üst Bilgi Barı
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedYear = null),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Yıllar'),
                  ),
                  Text(
                    '$_selectedYear • ${questions.length} Soru',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  EkysButton(
                    text: 'Testi Başlat',
                    onPressed: () {
                      // Quiz ekranına yönlendir
                      context.push(
                        '/tests/quiz/${questions.first.subtopicId}',
                        extra: '$_selectedYear Çıkmış Sorular',
                      );
                    },
                  ),
                ],
              ),
            ),

            // Soru Listesi (önizleme)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return EkysCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: context.colorScheme.primary,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: Text(
                                q.questionText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

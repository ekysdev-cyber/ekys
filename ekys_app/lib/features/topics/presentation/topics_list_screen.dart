import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/ekys_card.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/progress_bar.dart';
import 'topics_provider.dart';

class TopicsListScreen extends ConsumerWidget {
  const TopicsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.topics),
      ),
      body: _buildBody(context, state, ref),
    );
  }

  Widget _buildBody(BuildContext context, TopicsState state, WidgetRef ref) {
    if (state.isLoading && state.topics.isEmpty) {
      return const ListSkeleton();
    }

    if (state.error != null && state.topics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.md),
            ElevatedButton(
              onPressed: () => ref.read(topicsProvider.notifier).loadTopics(),
              child: const Text(AppStrings.tryAgain),
            ),
          ],
        ),
      );
    }

    if (state.topics.isEmpty) {
      return const Center(child: Text(AppStrings.noData));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(topicsProvider.notifier).loadTopics(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: state.topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          final topic = state.topics[index];
          
          return EkysCard(
            onTap: () {
              // Alt konular ekranına git
              context.push('/topics/${topic.id}/subtopics', extra: topic);
            },
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Center(
                    child: Text(
                      topic.icon ?? '📚',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${topic.subtopics.length} Alt Konu',
                        style: context.textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      ProgressBar(
                        percent: 0.0, // TODO: Gerçek ilerleme bağlanacak
                        lineHeight: 6,
                        progressColor: context.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Icon(
                  Icons.chevron_right,
                  color: context.theme.dividerColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

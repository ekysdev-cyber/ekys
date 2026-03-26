import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/models/topic_model.dart';
import '../../../shared/widgets/ekys_card.dart';
import '../../../shared/widgets/progress_bar.dart';

class SubtopicsScreen extends ConsumerWidget {
  final TopicModel topic;

  const SubtopicsScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (topic.subtopics.isEmpty) {
      return const Center(child: Text(AppStrings.noData));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: topic.subtopics.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (context, index) {
        final subtopic = topic.subtopics[index];

        return EkysCard(
          onTap: () {
            // Study listesine (içerik listesine) gitmek için
            context.push('/topics/${topic.id}/subtopics/${subtopic.id}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtopic.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, 
                                size: 16, 
                                color: context.textTheme.bodySmall?.color),
                            const SizedBox(width: 4),
                            Text('0/3 İçerik Tamamlandı', 
                                style: context.textTheme.bodySmall),
                          ],
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
              const SizedBox(height: AppSizes.md),
              const ProgressBar(percent: 0.0), // TODO: Gerçek ilerleme
            ],
          ),
        );
      },
    );
  }
}

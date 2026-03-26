import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/models/content_item_model.dart';
import '../../../shared/widgets/ekys_button.dart';
import 'study_provider.dart';

class SummaryScreen extends ConsumerWidget {
  final ContentItemModel content;

  const SummaryScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.summary),
      ),
      body: Column(
        children: [
          Expanded(
            child: Markdown(
              data: content.bodyMd ?? '*İçerik bulunamadı*',
              padding: const EdgeInsets.all(AppSizes.md),
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.headlineMedium,
                h2: Theme.of(context).textTheme.titleLarge,
                p: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                listBullet: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: EkysButton(
                text: AppStrings.completed,
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () {
                  ref.read(studyProvider(content.subtopicId).notifier).markAsCompleted(content.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

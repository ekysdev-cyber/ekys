import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/models/content_item_model.dart';
import '../../../../shared/widgets/ekys_card.dart';
import '../../../../shared/widgets/loading_skeleton.dart';
import 'study_provider.dart';

class StudyListScreen extends ConsumerWidget {
  final String subtopicId;
  final String subtopicTitle;

  const StudyListScreen({
    super.key,
    required this.subtopicId,
    required this.subtopicTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyProvider(subtopicId));

    return Scaffold(
      appBar: AppBar(
        title: Text(subtopicTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(context, state, ref),
    );
  }

  Widget _buildBody(BuildContext context, StudyState state, WidgetRef ref) {
    if (state.isLoading && state.contents.isEmpty) {
      return const ListSkeleton();
    }

    if (state.error != null && state.contents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            ElevatedButton(
              onPressed: () => ref.read(studyProvider(subtopicId).notifier).loadContents(subtopicId),
              child: const Text('Tekrar Dene'),
            )
          ],
        ),
      );
    }

    if (state.contents.isEmpty) {
      return const Center(child: Text('İçerik bulunamadı.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.md),
      itemCount: state.contents.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (context, index) {
        final item = state.contents[index];

        IconData icon;
        Color color;
        String title = item.title;

        switch (item.type) {
          case 'summary':
            icon = Icons.article;
            color = Colors.blue;
            break;
          case 'flashcard':
            icon = Icons.style;
            color = Colors.orange;
            break;
          case 'audio_note':
            icon = Icons.headphones;
            color = Colors.green;
            break;
          default:
            icon = Icons.error;
            color = Colors.grey;
        }

        return EkysCard(
          onTap: () => _navigateToContent(context, item, state.contents),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppSizes.fontLg),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  void _navigateToContent(BuildContext context, ContentItemModel item, List<ContentItemModel> allItems) {
    if (item.type == 'summary') {
      context.push('/topics/$subtopicId/subtopics/${item.id}/summary', extra: item);
    } else if (item.type == 'flashcard') {
      // Sadece flashcard olanları filtrele ve hepsini yolla
      final flashcards = allItems.where((i) => i.type == 'flashcard').toList();
      context.push('/topics/$subtopicId/subtopics/${item.id}/flashcard', extra: {'cards': flashcards, 'subtopicId': subtopicId});
    } else if (item.type == 'audio_note') {
      context.push('/topics/$subtopicId/subtopics/${item.id}/audio', extra: item);
    }
  }
}

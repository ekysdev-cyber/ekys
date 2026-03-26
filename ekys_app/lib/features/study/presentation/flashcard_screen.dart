import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/models/content_item_model.dart';
import 'study_provider.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final List<ContentItemModel> cards;
  final String subtopicId;

  const FlashcardScreen({
    super.key,
    required this.cards,
    required this.subtopicId,
  });

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _markCompleted() {
    // Tüm kartlar bittiyse (veya sonuncu görüldüyse) tamamlandı işaretle
    final notifier = ref.read(studyProvider(widget.subtopicId).notifier);
    for (var card in widget.cards) {
      notifier.markAsCompleted(card.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bilgi Kartları')),
        body: const Center(child: Text('Kart bulunamadı')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${widget.cards.length}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.xl),
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  if (index == widget.cards.length - 1) {
                    _markCompleted();
                  }
                },
                itemCount: widget.cards.length,
                itemBuilder: (context, index) {
                  final card = widget.cards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.md,
                    ),
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildCardFace(
                        context,
                        card.frontText ?? 'Soru yok',
                        isFront: true,
                      ),
                      back: _buildCardFace(
                        context,
                        card.bodyMd ?? 'Cevap yok',
                        isFront: false,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            Padding(
              padding: const EdgeInsets.all(AppSizes.xl),
              child: Text(
                'Çevirmek için karta dokunun\nGeçmek için kaydırın',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.disabledColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFace(BuildContext context, String text, {required bool isFront}) {
    return Container(
      decoration: BoxDecoration(
        color: isFront ? context.colorScheme.primaryContainer : context.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              color: isFront ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSecondaryContainer,
              fontWeight: isFront ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

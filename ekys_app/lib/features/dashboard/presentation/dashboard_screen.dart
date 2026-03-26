import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/extensions.dart';
import '../../../services/stats_service.dart';
import '../../../shared/widgets/ekys_card.dart';
import '../../../shared/widgets/loading_skeleton.dart';

// Stats verisini çeken basit bir FutureProvider
final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final svc = ref.read(statsServiceProvider);
  return svc.getUserDashboardStats();
});

final recentStudiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final svc = ref.read(statsServiceProvider);
  return svc.getRecentStudies();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final recentAsync = ref.watch(recentStudiesProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardStatsProvider);
            ref.invalidate(recentStudiesProvider);
          },
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStreakCard(context, statsAsync),
                    const SizedBox(height: AppSizes.lg),
                    _buildQuickActions(context),
                    const SizedBox(height: AppSizes.lg),
                    _buildStatsGrid(context, statsAsync),
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      'Son Çalışmalarınız',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSizes.md),
                    _buildRecentStudies(context, recentAsync),
                    const SizedBox(height: 80), // Bottom nav için boşluk
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merhaba, Hoş Geldiniz! 👋',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'EKYS 2026 hedefimize doğru ilerliyoruz.',
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            context.showSnackBar('Bildirimler yapım aşamasında');
          },
        ),
      ],
    );
  }

  Widget _buildStreakCard(BuildContext context, AsyncValue<Map<String, dynamic>> statsAsync) {
    return statsAsync.when(
      loading: () => const LoadingSkeleton(height: 100),
      error: (e, st) => EkysCard(
        color: AppColors.error.withOpacity(0.1),
        child: Text('Seri bilgisi yüklenemedi: $e'),
      ),
      data: (stats) {
        final currentStreak = stats['current_streak'] as int? ?? 0;
        
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 40),
              ),
              const SizedBox(width: AppSizes.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Çalışma Serisi',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      '$currentStreak Gün',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.menu_book,
            title: 'Konu Çalış',
            color: Colors.blue,
            onTap: () => context.go('/topics'),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.quiz,
            title: 'Soru Çöz',
            color: Colors.orange,
            onTap: () => context.go('/tests'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, AsyncValue<Map<String, dynamic>> statsAsync) {
    return statsAsync.when(
      loading: () => const LoadingSkeleton(height: 160),
      error: (_, __) => const SizedBox(),
      data: (stats) {
        final progress = stats['progress_percent'] as double? ?? 0.0;
        final examAvg = stats['exam_avg_score'] as double? ?? 0.0;
        
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSizes.md,
          mainAxisSpacing: AppSizes.md,
          childAspectRatio: 1.5,
          children: [
            _StatCard(
              title: 'Genel İlerleme',
              value: '%${progress.toInt()}',
              icon: Icons.pie_chart,
              color: Colors.green,
            ),
            _StatCard(
              title: 'Deneme Ortalaması',
              value: examAvg.toStringAsFixed(1),
              icon: Icons.analytics,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentStudies(BuildContext context, AsyncValue<List<Map<String, dynamic>>> recentAsync) {
    return recentAsync.when(
      loading: () => const ListSkeleton(itemCount: 2),
      error: (e, _) => Text('Hata: $e'),
      data: (recent) {
        if (recent.isEmpty) {
          return const EkysCard(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.xl),
              child: Center(
                child: Text('Henüz çalışılan bir konu yok. Hedeflerine ilk adımı at!'),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recent.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (context, index) {
            final item = recent[index];
            return EkysCard(
              onTap: () {
                // Kalınan yerden devam et
                // TODO: study_list_screen'e yönelt
                context.showSnackBar('Kalınan yerden devam eklenecek');
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(item['icon'] ?? '📚', style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['subtopic_title'] ?? 'Bilinmeyen Konu',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item['topic_title'] ?? '',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_circle_fill, color: AppColors.primary),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return EkysCard(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: AppSizes.sm),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return EkysCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

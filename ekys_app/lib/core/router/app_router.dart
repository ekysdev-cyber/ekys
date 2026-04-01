import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth Ekranları
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';

// Topics (Konular) Ekranları
import '../../features/topics/presentation/topics_list_screen.dart';
import '../../features/topics/presentation/subtopics_screen.dart';
import '../../shared/models/topic_model.dart';

// Dashboard (Ana Sayfa)
import '../../features/dashboard/presentation/dashboard_screen.dart';

// Study (Çalışma) Ekranları
import '../../features/study/presentation/study_list_screen.dart';
import '../../features/study/presentation/summary_screen.dart';
import '../../features/study/presentation/flashcard_screen.dart';
import '../../features/study/presentation/audio_screen.dart';
import '../../shared/models/content_item_model.dart';

// Quiz & Exam (Sınav) Ekranları
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/quiz/presentation/past_exams_screen.dart';
import '../../features/exam/presentation/exam_screen.dart';

// İleride oluşturacağımız ekranlar için placeholder
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

// Tests Liste Ekranı (Geçici)
class TestsMenuScreen extends StatelessWidget {
  const TestsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test ve Denemeler')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('80 Soruluk Türkiye Geneli Deneme Sınavı'),
              subtitle: const Text('Süre: 150 Dakika'),
              trailing: const Icon(Icons.play_arrow),
              onTap: () => context.push('/tests/exam'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history_edu),
              title: const Text('Çıkmış Sorular'),
              subtitle: const Text('Geçmiş yıllara ait EKYS soruları'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/tests/past-exams'),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Konu Testleri için "Çalış" menüsünden ilgili konuyu seçebilirsiniz.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(state.uri.toString()),
            onTap: (int idx) => _onItemTapped(idx, context),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Ana Sayfa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Çalış',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Test'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/topics',
            name: 'topics',
            builder: (context, state) => const TopicsListScreen(),
            routes: [
              GoRoute(
                path: ':topicId/subtopics',
                name: 'subtopics',
                builder: (context, state) {
                  final topic = state.extra as TopicModel;
                  return SubtopicsScreen(topic: topic);
                },
              ),
              GoRoute(
                path: ':topicId/subtopics/:subtopicId',
                name: 'study_list',
                builder: (context, state) {
                  final subId = state.pathParameters['subtopicId']!;
                  return StudyListScreen(
                    subtopicId: subId,
                    subtopicTitle: 'Çalışma İçerikleri',
                  );
                },
                routes: [
                  GoRoute(
                    path: ':contentId/summary',
                    name: 'summary',
                    builder: (context, state) {
                      final content = state.extra as ContentItemModel;
                      return SummaryScreen(content: content);
                    },
                  ),
                  GoRoute(
                    path: ':contentId/flashcard',
                    name: 'flashcard',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return FlashcardScreen(
                        cards: extra['cards'] as List<ContentItemModel>,
                        subtopicId: extra['subtopicId'] as String,
                      );
                    },
                  ),
                  GoRoute(
                    path: ':contentId/audio',
                    name: 'audio',
                    builder: (context, state) {
                      final content = state.extra as ContentItemModel;
                      return AudioScreen(content: content);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/tests',
            name: 'tests',
            builder: (context, state) => const TestsMenuScreen(),
            routes: [
              GoRoute(
                path: 'exam',
                name: 'exam',
                builder: (context, state) => const ExamScreen(),
              ),
              GoRoute(
                path: 'past-exams',
                name: 'past_exams',
                builder: (context, state) => const PastExamsScreen(),
              ),
              GoRoute(
                path: 'quiz/:subtopicId',
                name: 'quiz',
                builder: (context, state) {
                  final subId = state.pathParameters['subtopicId']!;
                  final title = state.extra as String? ?? 'Konu Testi';
                  return QuizScreen(subtopicId: subId, title: title);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Profile Info'),
          ),
        ],
      ),
    ],
  );
});

int _calculateSelectedIndex(String location) {
  if (location.startsWith('/dashboard')) return 0;
  if (location.startsWith('/topics')) return 1;
  if (location.startsWith('/tests')) return 2;
  if (location.startsWith('/profile')) return 3;
  return 0;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go('/dashboard');
      break;
    case 1:
      context.go('/topics');
      break;
    case 2:
      context.go('/tests');
      break;
    case 3:
      context.go('/profile');
      break;
  }
}

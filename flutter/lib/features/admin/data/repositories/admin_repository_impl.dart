import 'dart:async';
import '../../domain/models/admin_stats.dart';
import '../../domain/models/cms_content.dart';
import '../../domain/models/ai_config.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminStats? _stats;
  final List<FeaturedApp> _featuredApps = [];
  final List<HelpArticle> _helpArticles = [];
  AIConfig? _aiConfig;
  final List<Map<String, dynamic>> _auditLogs = [];

  AdminRepositoryImpl() {
    _seedMockAdminData();
  }

  void _seedMockAdminData() {
    _stats = AdminStats(
      totalUsers: 2540,
      activeUsers: 1890,
      premiumUsers: 540,
      trialUsers: 1200,
      revenue: RevenueStats(
        totalRevenue: 107460.00,
        adRevenue: 28400.00,
        premiumSubscriptionRevenue: 79060.00,
        trialConversionRate: 0.45,
      ),
      searchTrends: {
        'Photoshop': 1240,
        'MS Office': 980,
        'Figma Pro': 850,
        'Visual Studio': 640,
        'Sublime Text': 420,
      },
      errorLogs: [
        '[ERROR] [2026-06-25 14:15] Gemini API connection timed out. Retrying automatically...',
        '[WARNING] [2026-06-25 18:02] Razorpay webhook signature verification failed for test transaction.',
        '[ERROR] [2026-06-26 04:30] Device indexing cache out of memory on low-end Android emulator.',
      ],
    );

    _featuredApps.addAll([
      FeaturedApp(
        appName: 'GIMP',
        originalApp: 'Photoshop',
        description: 'Advanced alternative to Adobe Photoshop. Highly customizable GNU Image Manipulation Program.',
        category: 'Graphics & Vector Design',
        downloadUrl: 'https://www.gimp.org',
      ),
      FeaturedApp(
        appName: 'OnlyOffice',
        originalApp: 'Microsoft Office 365',
        description: 'A clean, high-compatibility modern alternative to MS Office Suite featuring docs, spreadsheet, and slides.',
        category: 'Office & Productivity',
        downloadUrl: 'https://www.onlyoffice.com',
      ),
    ]);

    _helpArticles.addAll([
      HelpArticle(
        id: 'faq_01',
        title: 'How do I transfer my saved favorites list to a new phone?',
        content: 'Simply enable Cloud Sync in your profile preferences page. It will safely sync your accounts.',
        category: 'Account Help',
      ),
      HelpArticle(
        id: 'faq_02',
        title: 'What should I do if my Razorpay subscription fails to upgrade?',
        content: 'Go to your billing history and click "Restore Purchase" to force verification.',
        category: 'Billing',
      ),
    ]);

    _aiConfig = AIConfig(
      promptTemplate: 'You are Sanvi, a warm expert companion designed to suggest great open source and local software alternatives.',
      dailyFreeUsageLimit: 3,
      safetyFiltersEnabled: true,
      currentPersonality: 'conversational',
      supportedLanguages: ['en'],
    );
  }

  @override
  Future<AdminStats> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _stats!;
  }

  @override
  Future<List<FeaturedApp>> getFeaturedApps() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_featuredApps);
  }

  @override
  Future<void> saveFeaturedApp(FeaturedApp app) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _featuredApps.removeWhere((x) => x.appName.toLowerCase() == app.appName.toLowerCase());
    _featuredApps.add(app);
  }

  @override
  Future<List<HelpArticle>> getHelpArticles() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_helpArticles);
  }

  @override
  Future<AIConfig> getAIConfig() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _aiConfig!;
  }

  @override
  Future<void> updateAIConfig(AIConfig config) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _aiConfig = config;
  }

  @override
  Future<void> logAdminAction(String actor, String action, String description) async {
    _auditLogs.insert(0, {
      'actor': actor,
      'action': action,
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print('AUDIT LOG: $actor performed $action - $description');
  }
}

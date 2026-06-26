import '../models/admin_stats.dart';
import '../models/cms_content.dart';
import '../models/ai_config.dart';

abstract class AdminRepository {
  /// Fetch complete dashboard analytics & metrics
  Future<AdminStats> getDashboardStats();

  /// Fetch list of managed featured applications
  Future<List<FeaturedApp>> getFeaturedApps();

  /// Save or update featured alternative applications metadata
  Future<void> saveFeaturedApp(FeaturedApp app);

  /// Fetch in-app help/editorial articles
  Future<List<HelpArticle>> getHelpArticles();

  /// Fetch active AI config states and limits
  Future<AIConfig> getAIConfig();

  /// Save changes made to System Prompt & personality parameters
  Future<void> updateAIConfig(AIConfig config);

  /// Trigger audit logging trace to persist administrative operations
  Future<void> logAdminAction(String actor, String action, String description);
}

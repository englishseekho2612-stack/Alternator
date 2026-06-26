import 'package:flutter/foundation.dart';
import '../../domain/models/admin_stats.dart';
import '../../domain/models/cms_content.dart';
import '../../domain/models/ai_config.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminController extends ChangeNotifier {
  final AdminRepository _repository;

  AdminStats? _stats;
  List<FeaturedApp> _featuredApps = [];
  List<HelpArticle> _helpArticles = [];
  AIConfig? _aiConfig;

  bool _isLoading = false;
  String? _errorMessage;

  AdminStats? get stats => _stats;
  List<FeaturedApp> get featuredApps => _featuredApps;
  List<HelpArticle> get helpArticles => _helpArticles;
  AIConfig? get aiConfig => _aiConfig;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AdminController(this._repository);

  /// Load complete administration stats and content trees
  Future<void> loadAdminDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await _repository.getDashboardStats();
      _featuredApps = await _repository.getFeaturedApps();
      _helpArticles = await _repository.getHelpArticles();
      _aiConfig = await _repository.getAIConfig();
    } catch (e) {
      _errorMessage = 'Failed to load Admin Management system: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create or edit a featured alternative product
  Future<bool> editFeaturedApp(FeaturedApp app, String adminName) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveFeaturedApp(app);
      _featuredApps = await _repository.getFeaturedApps();
      await _repository.logAdminAction(adminName, 'EDIT_CMS_APP', 'Modified featured app ${app.appName}');
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update featured application: $e';
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Update AI Assistant personality and prompt configurations
  Future<bool> updateAIConfiguration(AIConfig config, String adminName) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateAIConfig(config);
      _aiConfig = config;
      await _repository.logAdminAction(adminName, 'UPDATE_AI_CONFIG', 'Altered system prompt configurations and filters');
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update AI Settings: $e';
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Clear any active runtime errors
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

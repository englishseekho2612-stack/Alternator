import 'package:get_it/get_it.dart';
import 'logger_service.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/presentation/controllers/admin_controller.dart';

final GetIt sl = GetIt.instance; // sl: Service Locator

/// Dependency Injection Coordinator
/// Decouples implementations of APIs, local DBs, and core utilities.
class DIService {
  DIService._();

  static Future<void> initialize() async {
    // 1. Singletons for Core Services
    sl.registerLazySingleton<LoggerService>(() => LoggerService());

    // 2. Prepare Feature Registrations for Phase 4:
    sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl());

    // 3. Admin / Phase 5 registrations:
    sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl());
    sl.registerFactory<AdminController>(() => AdminController(sl<AdminRepository>()));

    LoggerService().info('GetIt service locator setup complete.');
  }
}


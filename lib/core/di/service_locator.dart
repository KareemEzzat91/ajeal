import 'package:get_it/get_it.dart';

import '../../features/admin/children/data/child_repository.dart';
import '../../features/admin/children/data/doctor_repository.dart';
import '../../features/parent/data/parent_repository.dart';

/// Global GetIt service locator instance.
final GetIt getIt = GetIt.instance;

/// Registers all dependencies. Call this once in [main] before [runApp].
void setupServiceLocator() {
  // Repositories – registered as lazy singletons so they are created
  // on first use and reused afterwards.
  getIt.registerLazySingleton<ChildRepository>(() => ChildRepository());
  getIt.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  getIt.registerLazySingleton<ParentRepository>(() => ParentRepository());
}

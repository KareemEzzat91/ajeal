import 'package:ajeal/features/admin/children/data/child_repository.dart';
import 'package:ajeal/features/admin/children/data/doctor_repository.dart';
import 'package:ajeal/features/parent/data/parent_repository.dart';
import 'package:get_it/get_it.dart';

/// Global GetIt service locator instance.
final GetIt sl = GetIt.instance;

/// Registers all dependencies. Call this once in [main] before [runApp].
void setupServiceLocator() {
  // Repositories – registered as lazy singletons so they are created
  // on first use and reused afterwards.
  sl.registerLazySingleton<ChildRepository>(() => ChildRepository());
  sl.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  sl.registerLazySingleton<ParentRepository>(() => ParentRepository());
}

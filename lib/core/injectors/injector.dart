import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:very_good_cofee_app/core/clients/main_http_client.dart';
import 'package:very_good_cofee_app/core/clients/shared_preferences_client.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository_impl.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_local_data_source.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

abstract class Injector {
  static Future<void> inject(GetIt getIt) async {
    final sharedPreferencesInstance = await SharedPreferences.getInstance();

    // Clients
    getIt.registerLazySingleton(() => MainHttpClient());
    getIt.registerLazySingleton(
      () =>
          SharedPreferencesClient(sharedPreferences: sharedPreferencesInstance),
    );

    // Sources
    getIt.registerLazySingleton(
      () => CoffeeRemoteDataSource(mainHttpClient: getIt.get<MainHttpClient>()),
    );
    getIt.registerLazySingleton(
      () => CoffeeLocalDataSource(
        sharedPreferencesClient: getIt.get<SharedPreferencesClient>(),
      ),
    );

    // Repositories
    getIt.registerLazySingleton<CoffeeRepository>(
      () => CoffeeRepositoryImpl(
        remoteDataSource: getIt.get<CoffeeRemoteDataSource>(),
        localDataSource: getIt.get<CoffeeLocalDataSource>(),
      ),
    );
  }
}

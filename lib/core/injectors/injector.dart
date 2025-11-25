import 'package:get_it/get_it.dart';
import 'package:very_good_cofee_app/core/clients/main_http_client.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository_impl.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

abstract class Injector {
  static Future<void> inject(GetIt getIt) async {
    // Clients
    getIt.registerLazySingleton(() => MainHttpClient());

    // Sources
    getIt.registerLazySingleton(
      () => CoffeeRemoteDataSource(mainHttpClient: getIt.get<MainHttpClient>()),
    );

    // Repositories
    getIt.registerLazySingleton<CoffeeRepository>(
      () => CoffeeRepositoryImpl(
        remoteDataSource: getIt.get<CoffeeRemoteDataSource>(),
      ),
    );
  }
}

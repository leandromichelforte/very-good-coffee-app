import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:very_good_cofee_app/core/injectors/injector.dart';
import 'package:very_good_cofee_app/core/clients/main_http_client.dart';
import 'package:very_good_cofee_app/core/clients/shared_preferences_client.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository_impl.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Injector', () {
    late GetIt getIt;

    setUp(() {
      getIt = GetIt.asNewInstance();
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() async {
      await getIt.reset();
    });

    test('should register and resolve all dependencies correctly', () async {
      await Injector.inject(getIt);

      // Clients
      final client1 = getIt.get<MainHttpClient>();
      final client2 = getIt.get<MainHttpClient>();
      expect(client1, isA<MainHttpClient>());
      expect(identical(client1, client2), isTrue);

      final prefsClient1 = getIt.get<SharedPreferencesClient>();
      final prefsClient2 = getIt.get<SharedPreferencesClient>();
      expect(prefsClient1, isA<SharedPreferencesClient>());
      expect(identical(prefsClient1, prefsClient2), isTrue);

      // Sources
      final remoteDataSource1 = getIt.get<CoffeeRemoteDataSource>();
      final remoteDataSource2 = getIt.get<CoffeeRemoteDataSource>();
      expect(remoteDataSource1, isA<CoffeeRemoteDataSource>());
      expect(identical(remoteDataSource1, remoteDataSource2), isTrue);

      final localDataSource1 = getIt.get<CoffeeLocalDataSource>();
      final localDataSource2 = getIt.get<CoffeeLocalDataSource>();
      expect(localDataSource1, isA<CoffeeLocalDataSource>());
      expect(identical(localDataSource1, localDataSource2), isTrue);

      // Repositories
      final repo1 = getIt.get<CoffeeRepository>();
      final repo2 = getIt.get<CoffeeRepository>();
      expect(repo1, isA<CoffeeRepositoryImpl>());
      expect(identical(repo1, repo2), isTrue);
    });
  });
}

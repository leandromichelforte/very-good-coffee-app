import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:very_good_cofee_app/core/injectors/injector.dart';
import 'package:very_good_cofee_app/core/clients/main_http_client.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository_impl.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

void main() {
  group('Injector', () {
    late GetIt getIt;

    setUp(() {
      getIt = GetIt.asNewInstance();
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

      // Sources
      final dataSource1 = getIt.get<CoffeeRemoteDataSource>();
      final dataSource2 = getIt.get<CoffeeRemoteDataSource>();
      expect(dataSource1, isA<CoffeeRemoteDataSource>());
      expect(identical(dataSource1, dataSource2), isTrue);

      // Repsositories
      final repo1 = getIt.get<CoffeeRepository>();
      final repo2 = getIt.get<CoffeeRepository>();
      expect(repo1, isA<CoffeeRepositoryImpl>());
      expect(identical(repo1, repo2), isTrue);
    });
  });
}

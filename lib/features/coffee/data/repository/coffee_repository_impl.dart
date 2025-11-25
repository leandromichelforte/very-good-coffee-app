import 'package:very_good_cofee_app/core/results/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_local_data_source.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  const CoffeeRepositoryImpl({
    required CoffeeRemoteDataSource remoteDataSource,
    required CoffeeLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final CoffeeRemoteDataSource _remoteDataSource;
  final CoffeeLocalDataSource _localDataSource;

  @override
  Future<Result<CoffeeModel>> fetchCoffee() => _remoteDataSource.fetchCoffee();

  @override
  Future<Result<List<CoffeeModel>>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  @override
  Future<Result<void>> addToFavorites(CoffeeModel coffee) {
    return _localDataSource.addToFavorites(coffee);
  }

  @override
  Future<Result<void>> removeFromFavorites(CoffeeModel coffee) {
    return _localDataSource.removeFromFavorites(coffee);
  }

  @override
  Future<Result<bool>> isCoffeeFavorite(CoffeeModel coffee) {
    return _localDataSource.isCoffeeFavorite(coffee);
  }
}

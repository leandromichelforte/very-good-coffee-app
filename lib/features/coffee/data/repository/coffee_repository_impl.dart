import 'package:very_good_cofee_app/core/result.dart';
import 'package:very_good_cofee_app/features/coffee/data/models/coffee_model.dart';
import 'package:very_good_cofee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:very_good_cofee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  const CoffeeRepositoryImpl({required CoffeeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CoffeeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<CoffeeModel>> fetchCoffee() => _remoteDataSource.fetchCoffee();
}

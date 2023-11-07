import '../../../core/exception.dart';
import '../../../core/result.dart';
import '../models/car.dart';
import '../models/car_bread.dart';
import '../models/car_group.dart';

abstract class CarSelectRepository {
  Future<Result<RequestException, List<CarGroup>>> groupList();

  Future<Result<RequestException, List<Car>>> carList(CarBread bread);
}

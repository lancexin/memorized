import 'package:memorized/modules/car_select/models/car_group.dart';
import 'package:memorized/modules/car_select/models/car_group_state.dart';

import '../../../core/exception.dart';
import '../../../core/http/http_util.dart';
import '../../../core/result.dart';
import '../models/car.dart';
import '../models/car_bread.dart';
import 'repository.dart';

class CarSelectRepositoryImpl implements CarSelectRepository {
  final HttpUtil _httpUtil;

  const CarSelectRepositoryImpl(this._httpUtil);

  @override
  Future<Result<RequestException, List<CarGroup>>> groupList() async {
    return const Failure(RequestException.noNetException);
  }

  @override
  Future<Result<RequestException, List<Car>>> carList(CarBread bread) {
    // TODO: implement carList
    throw UnimplementedError();
  }
}

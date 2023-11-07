import '../../../core/exception.dart';
import '../../../core/http/http_util.dart';
import '../../../core/result.dart';
import '../models/car.dart';
import '../models/car_bread.dart';
import '../models/car_group.dart';
import 'repository.dart';

class CarSelectRepositoryImplMock implements CarSelectRepository {
  final HttpUtil _httpUtil;

  const CarSelectRepositoryImplMock(this._httpUtil);

  @override
  Future<Result<RequestException, List<CarGroup>>> groupList() async {
    var carGroupList = List.generate(10, (index) => index)
        .map<CarGroup>((e1) => CarGroup(
            "",
            groupNameList[e1],
            List.generate(10, (index) => index)
                .map<CarBread>((e2) => CarBread("${groupNameList[e1]}$e2",
                    "Bread ${groupNameList[e1]} #$e2", ""))
                .toList()))
        .toList();
    return Success(carGroupList);
  }

  @override
  Future<Result<RequestException, List<Car>>> carList(CarBread bread) async {
    var carList = List.generate(30, (index) => index)
        .map<Car>((e1) => Car("", "Car ${bread.id} #$e1"))
        .toList();
    return Success(carList);
  }
}

const groupNameList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];

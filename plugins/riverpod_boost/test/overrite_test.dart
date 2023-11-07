import 'package:flutter/foundation.dart';

abstract class BindingBase {
  void initInstances() {
    print("BindingBase initInstances");
  }
}

mixin GestureBinding on BindingBase {
  @override
  void initInstances() {
    super.initInstances();
    print("GestureBinding initInstances");
  }
}

mixin SchedulerBinding on BindingBase {
  @override
  void initInstances() {
    super.initInstances();
    print("SchedulerBinding initInstances");
  }
}

class WidgetsFlutterBinding extends BindingBase
    with GestureBinding, SchedulerBinding {}

void main() {
  var binding = WidgetsFlutterBinding();
  binding.initInstances();
}

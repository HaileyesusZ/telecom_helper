import 'package:rxdart/rxdart.dart';
import 'package:telecom_helper/environment/constants/package_attributes.dart';

class Loader {
  BehaviorSubject loading = BehaviorSubject.seeded(false);

  Observable get stream => loading.stream;
  bool get current => loading.value;

  request() {
    loading.add(true);
  }

  endRequest() {
    loading.add(false);
  }
}

class CurrentPackage {
  BehaviorSubject currentPackage = BehaviorSubject.seeded(null);

  Observable get stream => currentPackage.stream;
  PACKAGE_TYPE get current => currentPackage.value;

  changeCurrentPackage(PACKAGE_TYPE packageType) {
    currentPackage.add(packageType);
  }
}

class PackagePlans {
  BehaviorSubject packagePlans = BehaviorSubject.seeded({});

  Observable get stream => packagePlans.stream;
  bool get current => packagePlans.value;

  setPackagePlans(Map newPackagePlans) {
    packagePlans.add(newPackagePlans);
  }
}

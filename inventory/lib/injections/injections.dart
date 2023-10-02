import 'package:get_it/get_it.dart';

import '../domains/auth/data/di/dependency.dart';
import '../domains/home/data/di/dependency.dart';
import 'dependencies/common_dependency.dart';
import 'dependencies/shared_dependency.dart';

final sl = GetIt.instance;

class Injections {
  Future<void> initialize() async {
    await _registerSharedDependencies();
    _registerDomains();
  }

  void _registerDomains() {
    AuthDependency();
    HomeDependency();
  }

  Future<void> _registerSharedDependencies() async {
    await const SharedLibDependency().registerCore();
    CommonDependency();
  }
}

import 'package:wolcg_qr_code/data/models/auth.dart';
import 'package:wolcg_qr_code/data/repositories/base_repository.dart';

class AuthRepository extends BaseRepository {
  Auth? _currentAuth;
  Auth? get currentAuth => _currentAuth;
  set currentAuth(Auth? auth) {
    if (auth != null) {
      _currentAuth = auth;
    }
  }

  @override
  void clean() {}
}

import 'package:wolcg_qr_code/app/app_flavor_config.dart';

class NetworkUrl {
  static String get baseURL => FlavorConfig.instance.env.getApiBaseUrl;

  static const checkin = 'admin/event/checkin';
  static const events = 'admin/event/filter';
  static const login = 'auth/admin/login';
}

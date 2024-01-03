enum Flavor { dev, staging, qc, production }

extension FlavorExt on Flavor {
  String get getApiBaseUrl {
    switch (this) {
      case Flavor.dev:
        return 'localhost';
      case Flavor.staging:
        return 'https://user.wordoflifeusa.online/api/v1/';
      case Flavor.qc:
        return 'https://gw.qc.wordoflifeusa.vn/user/api/v1/';
      default:
        return 'https://gw.wordoflifeusa.com/user/api/v1/';
    }
  }

  String get notAuthURL {
    switch (this) {
      case Flavor.staging:
        return "https://auth.wordoflifeusa.online/api/v1/auth/admin/login";
      case Flavor.qc:
        return "https://gw.qc.wordoflifeusa.vn/auth/api/v1/auth/admin/login";
      case Flavor.production:
        return "https://gw.wordoflifeusa.com/auth/api/v1/auth/admin/login";
      default:
        return "";
    }
  }
}

class FlavorConfig {
  FlavorConfig._internal(this.env);

  final Flavor env;

  static late FlavorConfig _instance;
  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.env == Flavor.production;
  static bool isDevelopment() => _instance.env == Flavor.dev;

  factory FlavorConfig({required Flavor env}) {
    return _instance = FlavorConfig._internal(env);
  }
}

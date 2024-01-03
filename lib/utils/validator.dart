class Validator {
  final String value;
  Validator(this.value);

  bool get username => _validate(value, _rUsername);

  bool get name => _validate(value, _rFullName);

  bool get phone => _validate(value, _rPhone);

  bool get email => _validate(value, _rEmail);

  bool get password => _validate(value, _rPassword);

  bool get identityCard => _validate(value, _rIdentityCard);

  bool firstLetterIsUppercase(String string) {
    return _validate(string, _rFirstLetterIsUppercase);
  }

  static const _rUsername = r'^(?=.*[a-z])(?=.*\d).{6,}$';
  static const _rFullName = r'^([A-Za-zÀ-Ỹà-ỹ]+( [A-Za-zÀ-Ỹà-ỹ]+)*)$';
  static const _rEmail = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const _rPassword = r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@#$%^&+=!])(.{8,})$';
  static const _rFirstLetterIsUppercase = r'^[A-Z].*$';
  static const _rPhone = r'^[0-9]{7,11}$';
  static const _rIdentityCard = r'^[A-Z0-9]{8,50}$';

  static bool _validate(String string, String pattern) {
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(string);
  }
}

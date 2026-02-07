class Validators {
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isValidPhone(String phone) {
    final regex = RegExp(r'^\+?\d{10,15}$');
    return regex.hasMatch(phone);
  }

  static bool isValidUsername(String username) {
    final regex = RegExp(r'^[a-zA-Z0-9_]{3,15}$');
    return regex.hasMatch(username);
  }

  static bool isValidName(String name) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(name);
  }

  static bool isValidDateOfBirth(String date) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regex.hasMatch(date);
  }

  static bool isValidUrl(String url) {
    final regex = RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$');
    return regex.hasMatch(url);
  }

  static bool isValidCreditCard(String cardNumber) {
    final regex = RegExp(r'^\d{16}$');
    return regex.hasMatch(cardNumber);
  }

  static bool isValidPostalCode(String postalCode) {
    final regex = RegExp(r'^\d{5}$');
    return regex.hasMatch(postalCode);
  }

  static bool isValidInteger(String value) {
    final regex = RegExp(r'^\d+$');
    return regex.hasMatch(value);
  }

  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  static bool isValidIpAddress(String ip) {
    final regex = RegExp(
      r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return regex.hasMatch(ip);
  }
}

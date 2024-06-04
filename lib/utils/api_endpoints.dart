class ApiEndPoints {
  static const String baseUrl = 'https://dev.internshipgate.com/public/api/';
  // ignore: library_private_types_in_public_api
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'studentReg';
  final String loginEmail = 'login';
  final String empLogin = 'employerlogin';
  final String registerEmployerWithEmail = 'employer';
}
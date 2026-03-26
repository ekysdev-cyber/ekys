/// Hata tipleri — Clean Architecture hata yönetimi
class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure($message)';
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Sunucu hatası oluştu']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Kimlik doğrulama hatası']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'İnternet bağlantısı yok']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Önbellek hatası']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Veri bulunamadı']);
}

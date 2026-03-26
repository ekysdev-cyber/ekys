/// Özel exception sınıfları
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Sunucu hatası']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Kimlik doğrulama hatası']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'İnternet bağlantısı yok']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Önbellek hatası']);

  @override
  String toString() => message;
}

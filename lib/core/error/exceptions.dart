class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Exception'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Exception'});
}

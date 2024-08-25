abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message = 'Server failure'});
}

class CacheFailure extends Failure {
  CacheFailure({super.message = 'Cache failure'});
}

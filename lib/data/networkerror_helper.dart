class NetworkException implements Exception {
  final dynamic e;

  NetworkException([this.e]);

  String toString() {
    if (e == null) return 'Unknown error.';

    return e.toString();
  }
}

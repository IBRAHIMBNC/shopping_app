class HttpException implements Exception {
  final String messege;

  HttpException({required this.messege});

  @override
  String toString() {
    return messege;
  }
}

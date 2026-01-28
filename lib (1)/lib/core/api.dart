import 'package:dio/dio.dart';

class Api {
  static const String baseUrl = "https://reza.tif-lbj.my.id/api-reza";

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // ✅ helper agar tidak perlu import Options/Headers di setiap file
  static Options formOptions() => Options(
    contentType: Headers.formUrlEncodedContentType,
  );
}

import 'enums.dart';
import 'client_stub.dart'
    if (dart.library.html) 'client_browser.dart'
    if (dart.library.io) 'client_io.dart';
import 'response.dart';
import 'upload_progress.dart';

abstract class Client {
  static const int CHUNK_SIZE = 5*1024*1024;
  late Map<String, String> config;
  late String _endPoint;
  late String? _endPointRealtime;

  String get endPoint => _endPoint;
  String? get endPointRealtime => _endPointRealtime;

  factory Client._(
          {String endPoint = 'https://HOSTNAME/v1',
          bool selfSigned = false}) =>
      createClient(endPoint: endPoint, selfSigned: selfSigned);

  static final instance = Client._();

  Client initialize({String endPoint = 'https://HOSTNAME/v1', String? projectId, bool selfSigned = false}) {
    instance
      .._setEndpoint(endPoint)
      .._setSelfSigned(status: selfSigned);

    if (projectId != null) {
      instance._setProject(projectId);
    }

    return instance;
  }

  Future webAuth(Uri url, {String? callbackUrlScheme});

  Future<Response> chunkedUpload({
    required String path,
    required Map<String, dynamic> params,
    required String paramName,
    required String idParamName,
    required Map<String, String> headers,
    Function(UploadProgress)? onProgress,
  });

  Client _setSelfSigned({bool status = true});

  Client _setEndpoint(String endPoint);

  Client setEndPointRealtime(String endPoint);

    /// Your project ID
  Client _setProject(String value);
    /// Your secret JSON Web Token
  Client setJWT(value);
  Client setLocale(value);

  Client addHeader(String key, String value);

  Future<Response> call(HttpMethod method, {
    String path = '',
    Map<String, String> headers = const {},
    Map<String, dynamic> params = const {},
    ResponseType? responseType,
  });
}

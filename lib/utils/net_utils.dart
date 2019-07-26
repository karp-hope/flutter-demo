import 'package:dio/dio.dart';

///在fultter中，使用网络访问大致分为3种方式：
///1.dart原生的网络请求HttpClient。
///2.第三方库 http
///3.国内牛人搞出来的dio，目前来看 dio是最好的，应该是应用最广泛的吧
class NetUtils{
  static var dio = new Dio();

  //通过get  post进行网络访问
  static Future get(String url, {Map<String, dynamic> params}) async{
    Response response = await dio.get(url, queryParameters: params);
    return response.data;
  }

  static Future post(String url, {Map<String, dynamic> params}) async{
    var response = await dio.post(url, queryParameters: params);
    return response.data;
  }

}
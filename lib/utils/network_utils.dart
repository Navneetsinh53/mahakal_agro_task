import 'dart:async';

import 'package:dio/dio.dart';



class NetworkUtils{

  final dio = Dio();

Future<Response> getHttp(String url,  Function(dynamic) onError) async {
  var response ;
  try{
   response = await dio.get(url);
   return response;
  }on DioException catch(e){
      // print(e);
      onError.call(e);
  } 
  // print(response);
  return response;
}


}
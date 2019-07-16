import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/routes/router_handler.dart';

class Routers{
  static String root = '/';
  static String home = '/home';

  static void configureRoutes(Router router){
    router.notFoundHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params){
      print('router not found handler');
    });

    //设置对应的路径的handler
    router.define(home, handler: homeHandler);
  }
}
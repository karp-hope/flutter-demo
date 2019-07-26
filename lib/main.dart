import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/utils/provider.dart';
import 'package:flutter_ty_demo/utils/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:fluro/fluro.dart';


import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

import 'components/BottomNavigationBar/bar.dart';
import 'routes/application.dart';
import 'routes/routers.dart';

SpUtil sp;
var db;

void main() async {
  final provider = Provider();
  await provider.init(true);

  sp = await SpUtil.getInstance();
  db = Provider.db;

  runApp(MyApp());

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    //设置相关状态栏的状况//用于设置系统的一些状态的信息等，其还有其他的几个参数可以使用
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

Color themeDef = Color(0xffEDEDED);

class MyApp extends StatelessWidget {

  MyApp(){
    //这里使用的是fluro第三方库的封装，方便使用router和navigator
    final router = new Router();
    Routers.configureRoutes(router);
    //最好存下来，这样便于后面使用
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter wx hope demo',
      theme: ThemeData(primaryColor: themeDef, cardColor: Color(0xff4C4C4C)),
//      For the / route, the home property, if non-null, is used.
      home: new Scaffold(body: new Bar()),
//      通过与materialApp的onGenerateRoute关联后，调用Navigator方便很多
      onGenerateRoute: Application.router.generator,
    );
  }
}

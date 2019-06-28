import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/tabs/block.dart';
import 'package:flutter_ty_demo/tabs/network.dart';
import 'package:flutter_ty_demo/tabs/webview.dart';
import 'package:flutter_ty_demo/utils/provider.dart';
import 'package:flutter_ty_demo/utils/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

SpUtil sp;
var db;

void main() async {
  final provider = Provider();
  await provider.init();

  sp = await SpUtil.getInstance();
  db = Provider.db;

  runApp(new MaterialApp(
    title: "tingyun demo",
    home: new TingYunHome(),
  ));

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    //设置相关状态栏的状况
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class TingYunHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyHomeState();
}

// SingleTickerProviderStateMixin is used for animation,当进行切换的时候应该有切换的动作的动画在这里面
class MyHomeState extends State<TingYunHome>
    with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Initialize the Tab Controller, 3表示tab的数量, 这里需要传入vsync，
    // 应该就是上面的with SingleTickerProviderStateMixin需要的原因吧
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        new Tab(
          icon: new Icon(Icons.network_wifi),
          text: '网络',
        ),
        new Tab(
          icon: new Icon(Icons.block),
          text: '卡顿',
        ),
        new Tab(
          icon: Icon(Icons.open_in_browser),
          text: 'webview',
        )
      ],
      // setup the controller
      controller: this.controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Using Tabs tingyun'),
        backgroundColor: Colors.blue,
        // Set the bottom property of the Appbar to include a Tab Bar
        bottom: getTabBar(),
      ),
      body:
          getTabBarView(<Widget>[new Network(), new Block(), new WebViewTy()]),
    );
  }
}

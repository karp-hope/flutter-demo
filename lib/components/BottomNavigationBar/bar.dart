import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/common/style/Style.dart';

class Bar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _BarState();
}

//_下标开始的是私有类
class _BarState extends State<Bar> {

  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //开始的时候调用
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose(); //end的时候调用，进去super里面可以看见详细api的说明
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //这里的willpopScope用于拦截返回按键的退出的操作
    return new WillPopScope(
        child: Scaffold(
//          挡在第四个界面的时候（"我"的界面的时候，没有顶部的appBar的内容，所以此时去掉）
          appBar: _currentIndex != 3 ? defaultAppBar : null,),
        onWillPop: () {
          return _dialogExitApp(context);
        });
  }

  Widget defaultAppBar = AppBar(
    title: const Text('微信'),
    /// The z-coordinate at which to place this app bar relative to its parent.
    /// 相当于是否整体的提高了，这样有阴影的效果
    elevation: 0.0,
    actions: <Widget>[
      IconButton(icon: Icon(Icons.search), onPressed: (){}),
      ///这里相当设置了一个空的container用来设置下我们的布局
      Container(width: 14.0,),
      PopupMenuButton(itemBuilder: (BuildContext context){
        return [
          PopupMenuItem(child: _buildPopupMenuItem(menus[0]), value: 0,),
          PopupMenuItem(child: _buildPopupMenuItem(menus[1]), value: 1,),
          PopupMenuItem(child: _buildPopupMenuItem(menus[2]), value: 2,),
          PopupMenuItem(child: _buildPopupMenuItem(menus[3]), value: 3,),
          PopupMenuItem(child: _buildPopupMenuItem(menus[4]), value: 4,),
        ];
      },
      padding: EdgeInsets.only(top: 0.0),
        //这样会存在一个阴影的效果
        elevation: 5.0,
        icon: Icon(Icons.add_circle_outline),
        ///这里的int的类型和上面的popmenuitem中的value属性的类型应该是保持一致的
        onSelected: (int value){ print("onselect value:${value}");},
      )
    ],

  );

  static _buildPopupMenuItem(PageMenu pageMenu){
    return Row(children: <Widget>[
      Icon(pageMenu.icon,
      color: Color(0xFFFFFFFF),),
      Container(width: 12.0,),
      Text(pageMenu.title,
        style: TextStyle(color: Color(0xFFFFFFFF)),)
    ],);
  }



  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(context: context, builder: (context) =>
    new AlertDialog(
//      title: Text('退出'),
      content: Text('确定退出应用'),
//      下面的navigator的写法在showDialog中有明确的说明
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.of(context).pop(false),
            child: new Text('取消', style: TextStyle(color: Colors.black54))),
        new FlatButton(onPressed: () => Navigator.of(context).pop(true),
            child: new Text('确定', style: TextStyle(color: Colors.black54),))
      ],
    ));
  }
}

class PageMenu {
  final String title;
  final IconData icon;
  const PageMenu({this.title, this.icon});
}

const List<PageMenu> menus = const <PageMenu>[
  const PageMenu(title: '发起群聊', icon: ICons.HOME_CHECKED),
  const PageMenu(title: '添加朋友', icon: ICons.ADDRESS_BOOK_CHECKED),
  const PageMenu(title: '扫一扫', icon: ICons.ADDRESS_BOOK_CHECKED),
  const PageMenu(title: '收付款', icon: ICons.ADDRESS_BOOK_CHECKED),
  const PageMenu(title: '帮助与反馈', icon: ICons.ADDRESS_BOOK_CHECKED),
];
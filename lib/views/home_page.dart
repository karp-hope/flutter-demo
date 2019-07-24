import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/components/liststate.dart';
import 'package:flutter_ty_demo/model/conversation.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

///AutomaticKeepAliveClientMixin用于把此table保留在内存中，避免频繁的释放掉
///这样在切换tab的时候再切回来可以保持原来的状态，不用走init等函数了
class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin<HomePage>,
        ListState<HomePage>,
        WidgetsBindingObserver {

  ConversationControlModel _conversationControlModel =
      new ConversationControlModel();

  Manager manager = new Manager();

  @override
  Widget build(BuildContext context) {
    super.build(context);// 如果不加这句，从子页面回来会重新加载didChangeDependencies()方法
    return null;
  }

  @override
  bool get isRefreshFirst => false;

  @override
  bool get wantKeepAlive => true;

}
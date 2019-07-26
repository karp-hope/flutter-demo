import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/components/PullLoadWidget.dart';
import 'package:flutter_ty_demo/components/UserIconWidget.dart';
import 'package:flutter_ty_demo/components/liststate.dart';
import 'package:flutter_ty_demo/model/conversation.dart';
import 'package:flutter_ty_demo/utils/net_utils.dart';
import 'package:flutter_ty_demo/common/style/Style.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

///AutomaticKeepAliveClientMixin用于把此table保留在内存中，避免频繁的释放掉
///这样在切换tab的时候再切回来可以保持原来的状态，不用走init等函数了
///
/// WidgetsBindingObserver用来监控application(非widget)的生命周期，就像activity和fragment的生命周期那样的意思，
/// 只不过application中的生命周期没有那么多，具体见文档
class _HomePageState extends State<HomePage>
    with
        AutomaticKeepAliveClientMixin<HomePage>,
        ListState<HomePage>,
        WidgetsBindingObserver {

  ConversationControlModel _conversationControlModel =
      new ConversationControlModel();

  Manager manager = new Manager();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  ///紧跟在initState之后调用
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    mockConversation.addAll(preConversation);
    pullLoadWidgetControl.dataList = mockConversation;
    _conversationControlModel.clear();
    ///获取第一页的数据,不过此函数中的参数看起来一点的作用都没有
    getIndexListData(1);
    setState(() {
      pullLoadWidgetControl.needLoadMore = true;
    });
  }

  String indexListGetUrl = "https://randomuser.me/api/?results=10";
  getIndexListData(page) async{
    try{
      var response = await NetUtils.get(indexListGetUrl);
      List<Conversation> arr = [];
      for(int i = 0; i < response['results'].length; i++){
        response['results'][i]['unReadMsgCount'] =
        i == Random().nextInt(10) ? Random().nextInt(20) : 0;

        arr.add(Conversation.fromJson(response['results'][i]));
        ///这里放在数据库中进行了保存的操作？
        await _conversationControlModel.insert(Conversation.fromJson(response['results'][i]));
      }
      manager.setState(true);

      setState(() {
        ///这里就把从网上获取到的数据放在了mockConversation中了，这样就在list中进行了展示的操作
        mockConversation.addAll(arr);
      });
    }catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);// 如果不加这句，从子页面回来会重新加载didChangeDependencies()方法
    return PullLoadWidget(
      pullLoadWidgetControl,
        (BuildContext context, int index){
          if(index == 0){
            return _DeviceInfoItem();
          }
          return _ConversationItem(
              conversation: pullLoadWidgetControl.dataList[index]);
        },
      handleRefresh,
      onLoadMore,
      refreshKey: refreshIndicatorKey,
    );
  }

  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    await getIndexListData(page);
    setState(() {
      // 3次加载数据
      pullLoadWidgetControl.needLoadMore =
      (mockConversation != null && mockConversation.length < 25);
    });
    isLoading = false;
    return null;
  }

  @override
  Future<Null> handleRefresh() async{
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    mockConversation.clear();
    mockConversation.addAll(preConversation);
    _conversationControlModel.clear();
    await getIndexListData(page);
    setState(() {
      pullLoadWidgetControl.needLoadMore =
      (mockConversation != null && mockConversation.length == 14);
    });
    isLoading = false;
    return null;
  }

  @override
  bool get isRefreshFirst => false;

  @override
  bool get wantKeepAlive => true;

}

class _DeviceInfoItem extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: Color(0xffd9d9d9), width: .4),
            bottom: BorderSide(color: Color(0xffd9d9d9), width: .5)),
        color: Color(0xffEDEDED),
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 22.0, right: 25.0),
            child: Icon(ICons.XIANSHIQI),
          ),
          Text(
            'Mac 微信已登录，手机通知已关闭',
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.black54,
              fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget{

  const _ConversationItem({Key key, this.conversation})
      : assert(conversation != null),
        super(key: key);

  final Conversation conversation;
  @override
  Widget build(BuildContext context) {
    //头像组件
    Widget userImage = new UserIconWidget(
        padding: const EdgeInsets.only(top: 0.0, right: 8.0, left: 10.0),
        width: 50.0,
        height: 50.0,
        image: conversation.avatar,
        isNetwork: conversation.isNetwork,
        onPressed: () {
          // NavigatorUtils.goPerson(context, eventViewModel.actionUser);
        });
    ///未读消息的角标
    Widget unReadMsgCountText;
    if (conversation.unReadMsgCount > 0) {
      unReadMsgCountText = Positioned(
        child: Container(
          width: 18.0,
          height: 18.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20 / 2.0),
              color: Color(0xffff3e3e)),
          child: Text(
            conversation.unReadMsgCount.toString(),
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color(0xffffffff)),
          ),
        ),
        right: 0.0,
        top: -5.0,
      );
    } else if (conversation.displayDot) {
      unReadMsgCountText = Positioned(
        child: Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20 / 2.0),
              color: Color(0xffff3e3e)),
        ),
        right: 2.0,
        top: -5.0,
      );
    } else {
      unReadMsgCountText = Positioned(
        child: Container(),
        right: 0.0,
        top: -5.0,
      );
    }

    return Container(
      height: 75,
      child:
      RawMaterialButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (c) {
          ///这里我暂时给屏蔽了，这里应该点击后进入另外一个页面中
//          return new HomeChatPage(conversation: conversation);
        }));
      },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                userImage,
                unReadMsgCountText,
              ],
            ),
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xffd9d9d9), width: .5))),
                  padding: EdgeInsets.only(top: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        conversation.title,
                        style: TextStyle(fontSize: 17.5),
                      ),
                      Container(
                        height: 2.0,
                      ),
                      Text(
                        conversation.describtion,
                        maxLines: 1,
                        style: TextStyle(color: Colors.grey, fontSize: 13.0),
                      )
                    ],
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Color(0xffd9d9d9), width: .5))),
                padding: EdgeInsets.only(top: 12.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      conversation.createAt,
                      style: TextStyle(color: Color(0xffBEBEBE), fontSize: 13.0),
                    ),
                  ],
                ))
          ],
        ),),
    );
  }
}
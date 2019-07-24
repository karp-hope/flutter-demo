import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/components/PullLoadWidget.dart';

/**
 * 上下拉刷新列表的通用State
 *
 * AutomaticKeepAliveClientMixin主要是保存原来的widget还存在于内存之中
 * 这样数据
 *
 * mixin相当于一个接口，但是可以有方法，因为dart中class只允许有一个extends， 另外，mixin要
 * 使用class的代码，需要使用 on 关键字, 相当于mixin 的class的父类的意思
 *
 */
mixin ListState<T extends StatefulWidget> on State<T>, AutomaticKeepAliveClientMixin<T>{

  bool isShow = false;
  bool isLoading = false;
  int page = 1;

  final List dataList = new List();

  final PullLoadWidgetControl pullLoadWidgetControl = new PullLoadWidgetControl();

  ///Creating the RefreshIndicator with a GlobalKey<RefreshIndicatorState>
  ///makes it possible to refer to the RefreshIndicatorState.
  ///通过key这个变量把RefreshIndicatorState 与RefreshIndicator关联起来，这样在使用RefreshIndicatorState对象的
  ///show函数的时候就可以显示refresh indicator 的widget了，同时run the refresh callback
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  ///调用此函数显示更新的指示的widget
  showRefreshLoading(){
    new Future.delayed(const Duration(seconds: 0), (){
      refreshIndicatorKey.currentState.show().then((e){});
    });
  }

  ///调用setState对列表的数据进行更新
  @protected
  resolveRefreshResult(res){
    if(res != null && res.result){
      pullLoadWidgetControl.dataList.clear();
      if(isShow){
        ///setState对widget的数据进行更新
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
  }

  ///这个应该是在顶端的时候下拉的更新的操作的逻辑
  @protected
  Future<Null> handleRefresh() async{
    if(isLoading){
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await requestRefresh();
    resolveRefreshResult(res);
    resolveDataResult(res);

    ///如果还有next的话，接着加载？
    if(res.next != null){
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    return null;
  }

  @protected
  resolveDataResult(res){
    if(isShow){
      ///此时又会导致build的刷新的操作
      setState(() {
        pullLoadWidgetControl.needLoadMore = (res != null && res.data != null && res.data.length == 20);
      });
    }
  }

  ///下拉刷新数据
  @protected
  requestRefresh() async{}

  ///上拉更多请求数据
  @protected
  requestLoadMore() async{}

  ///这个是应该向下拉取的方式
  @protected
  Future<Null> onLoadMore() async{
    if(isLoading){
      return null;
    }
    isLoading = true;
    page++;
    var res = await requestLoadMore();
    if(res != null && res.result){
      if(isShow){
        setState(() {
          ///这里是直接添加的，不像handlerRefresh那样是先clean然后添加的
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    return null;
  }

  @protected
  clearData(){
    if(isShow){
      setState(() {
        pullLoadWidgetControl.dataList.clear();
      });
    }
  }

  ///是否需要第一次进入自动刷新一下
  @protected
  bool get isRefreshFirst;

  ///是否需要头部
  @protected
  bool get needHeader => false;

  ///是否需要保持，这个是复写AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  List get getDataList => dataList;

  @override
  void initState() {
    super.initState();
    isShow = true;
    pullLoadWidgetControl.needHeader = needHeader;
    pullLoadWidgetControl.dataList = getDataList;
    if(pullLoadWidgetControl.dataList.length == 0 && isRefreshFirst){
      showRefreshLoading();
    }
  }

  @override
  void dispose() {
    isShow = false;
    isLoading = false;
    super.dispose();
  }

}
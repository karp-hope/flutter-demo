import 'package:flutter/material.dart';
import 'package:flutter_ty_demo/components/PullLoadWidget.dart';

/**
 * 上下拉刷新列表的通用State
 *
 * AutomaticKeepAliveClientMixin主要是保存原来的widget还存在于内存之中
 * 这样数据
 *
 * mixin相当于一个接口，但是可以有方法，因为dart中class只允许有一个extends， 另外，mixin要
 * 使用class的代码，需要使用 on 关键字
 *
 */
mixin ListState<T extends StatefulWidget> on State<T>,
    AutomaticKeepAliveClientMixin<T>{

  bool isShow = false;
  bool isLoading = false;
  int page = 1;

  final List dataList = new List();

  final PullLoadWidgetControl pullLoadWidgetControl = new PullLoadWidgetControl();

  //这里是listview等控件下拉刷新的做法
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  showRefreshLoading(){
    new Future.delayed(const Duration(seconds: 0), (){
      refreshIndicatorKey.currentState.show().then((e){});
      return true;
    });
  }

  @protected
  resolveRefreshResult(res){
    if(res != null && res.result){
      pullLoadWidgetControl.dataList.clear();

      if(isShow){
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
  }

  @protected
  resolveDataResult(res){
    if(isShow){
      setState(() {
        pullLoadWidgetControl.needLoadMore = (res != null && res.data != null && res.data.length == 20);
      });
    }
  }

  ///下拉刷新列表
  @protected
  requestRefresh() async{}

  ///上拉更多请求数据
  @protected
  requestLoadMore() async {}

  ///是否需要第一次进入自动刷新
  ///Getters and setters are special methods that provide
  ///read and write access to an object’s properties
  @protected
  bool get isRefreshFirst;

  @protected
  bool get needHeader => false;

  //是否需要保持,这个是AutomaticKeepAliveClientMixin接口里面的字段
  @override
  bool get wantKeepAlive => true;

  List get getDataList => dataList;

  @protected
  Future<Null> handleRefresh() async{
    if(isLoading){
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await requestRefresh();

    //解析相关的结果
    resolveRefreshResult(res);
    resolveDataResult(res);
    //如果还有的话，就再添加一下
    if(res.next != null){
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }

    isLoading = false;
    return null;
  }

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
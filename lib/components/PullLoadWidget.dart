
import 'package:flutter/material.dart';

//通用下上刷新控件
class PullLoadWidget extends StatefulWidget{
  ///item渲染
  final IndexedWidgetBuilder itemBuilder;

  ///加载更多回调
  final RefreshCallback onLoadMore;

  ///下拉刷新回调
  final RefreshCallback onRefresh;

  ///控制器，比如数据和一些配置
  final PullLoadWidgetControl control;

  final Key refreshKey;

  PullLoadWidget(this.control, this.itemBuilder, this.onRefresh, this.onLoadMore, {this.refreshKey});


  @override
  State<StatefulWidget> createState() => _PullLoadWidgetState(
    this.control, this.itemBuilder, this.onRefresh, this.onLoadMore, this.refreshKey
  );
}

class _PullLoadWidgetState extends State<PullLoadWidget>{
  final IndexedWidgetBuilder itemBuilder;
  final RefreshCallback onLoadMore;
  final RefreshCallback onRefresh;

  final Key refreshKey;

  PullLoadWidgetControl control;

  _PullLoadWidgetState(this.control, this.itemBuilder, this.onRefresh, this.onLoadMore, this.refreshKey);

  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    ///增加滑动监听
    _scrollController.addListener((){
      ///判断当前滑动位置是不是到达底部，触发加载更多回调
      if(_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent){
        if(this.control.needLoadMore){
          this.onLoadMore?.call();
        }
      }
    });
    super.initState();
  }

  ///根据配置状态返回实际列表数量
  ///实际上这里可以根据你的需要做更多的处理
  ///比如多个头部，是否需要空页面，是否需要显示加载更多。
  _getListCount(){
    ///是否需要头部
    if(control.needHeader){
      ///如果需要头部，用Item 0 的 Widget 作为ListView的头部
      ///列表数量大于0时，因为头部和底部加载更多选项，需要对列表数据总数+2
      return (control.dataList.length > 0)
          ? control.dataList.length + 2
          : control.dataList.length + 1;
    } else {
      ///如果不需要头部，在没有数据时，固定返回数量1用于空页面呈现
      if(control.dataList.length == 0){
        return 1;
      }

      return (control.dataList.length > 0)
          ? control.dataList.length + 1
          : control.dataList.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}


class PullLoadWidgetControl {
  ///数据，对齐增减，不能替换
  List dataList = new List();

  ///是否需要加载更多
  bool needLoadMore = true;

  ///是否需要头部
  bool needHeader = false;
}

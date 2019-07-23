
import 'package:event_bus/event_bus.dart';

class ThemeChangeEvent{
  int color;

  ThemeChangeEvent(this.color);
}

//使用的eventbus来进行的相关的模块的解耦
class ThemeChangeHandler{
  static final EventBus eventBus = new EventBus();

  //发出事件
  static themeChangeHandler(int color){
    eventBus.fire(new ThemeChangeEvent(color));
  }
}
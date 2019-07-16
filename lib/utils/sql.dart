import 'package:flutter_ty_demo/utils/provider.dart';
import 'package:sqflite/sqflite.dart';

class BaseModel{
  Database db;
  final String table = '';
  var query;

  BaseModel(this.db){
    query = db.query;
  }
}

class Sql extends BaseModel{
  final String tableName;

  //构造函数的调用顺序为：
  //1.initializer list
  //2.superclass’s no-arg constructor
  //3.main class’s no-arg constructor
  //这样的形式被称为命名构造函数，其也是构造函数的一种
  Sql.setTable(String name):
        tableName = name, super(Provider.db);

  Future<List> get() async{
    return await this.query(tableName);
  }

  Future<List> getAll() async{
    var result = await this.query(tableName);
    return result.toList();
  }

  getTableName(){
    return tableName;
  }

  Future<int> delete(String value, String key) async{
    return await this.db.delete(
      tableName, where: '$key = ?', whereArgs: [value]
    );
  }

  Future<int> clearTable(String tableName) async{
    return await this.db.delete(tableName);
  }

  Future<List> getByCondition({Map<dynamic, dynamic> conditions}) async{
    if(conditions == null || conditions.isEmpty){
      return this.get();
    }

    String stringConditions = "";
    int index = 0;
    //这forEach里面是一个function
    conditions.forEach((key, value){
      if(value == null)
        return ;

      if(value.runtimeType == String){
        stringConditions = '$stringConditions $key = "$value"';
      }

      //To get an object’s type at runtime, you can use Object’s runtimeType property
      if(value.runtimeType == int){
        stringConditions = '$stringConditions $key = "$value"';
      }

      if(index >= 0 && index < conditions.length - 1){
        stringConditions = '$stringConditions and';
      }
      index++;
    });
    return await this.query(tableName, where: stringConditions);
  }

  Future<Map<String, dynamic>> insert(Map<String, dynamic> json) async{
    var id = await this.db.insert(tableName, json);
    json['id'] = id;
    return json;
  }

///
/// 搜索
/// @param Object condition
/// @mods [And, Or] default is Or
/// search({'name': "hanxu', 'id': 1};
///
  Future<List> search(
  {Map<String, dynamic> conditions, String mods = 'Or'}
      ) async{
    if(conditions == null || conditions.isEmpty){
      return this.get();
    }

    String stringConditions = '';
    int index = 0;
    conditions.forEach((key, value){
      if(value == null)
        return;

      if (value.runtimeType == String) {
        stringConditions = '$stringConditions $key like "%$value%"';
      }
      if (value.runtimeType == int) {
        stringConditions = '$stringConditions $key = "%$value%"';
      }

      if(index >= 0 && index < conditions.length - 1){
        stringConditions = '$stringConditions $mods';
      }
      index++;
    });
    return await this.query(tableName, where: stringConditions);
  }

}
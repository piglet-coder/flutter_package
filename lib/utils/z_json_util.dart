import 'dart:convert';

import 'dart:developer';

/// @author zdl
/// date 2020/11/12 18:06
/// email zdl328465042@163.com
/// description json相关工具类
class ZJsonUtil {
  static const _tag = 'ZJsonUtil';

  static String toJson(var data) => data == null ? '' : json.encode(data);

  static Map getMap(var data){
    try{
      if(data is String){
        return json.decode(data);
      }else if(data is Map){
        return data;
      }else{
        return {};
      }
    }catch(e){
      log(e.toString(), name: _tag);
      return {};
    }
  }
}

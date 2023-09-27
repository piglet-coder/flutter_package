import 'package:flutter_package/flutter_package.dart';
import 'package:intl/intl.dart';

/// @author zdl
/// date 2021/03/29 17:19
/// email zdl328465042@163.com
/// description DateTime扩展类
extension ExtensionDateTime on DateTime{

  /// yyyy-MM-dd HH:mm:ss
  String get toDef => DateFormat(ZTimeFormat.def).format(this);

  /// yyyy年MM月dd日 HH点mm分ss秒
  String get toDefZh => DateFormat(ZTimeFormat.def_zh).format(this);

  /// yyyy-MM-dd HH:mm
  String get toYmdHm => DateFormat(ZTimeFormat.ymd_hm).format(this);

  /// yyyy年MM月dd日 HH点mm分
  String get toYmdHmZh => DateFormat(ZTimeFormat.ymd_hm_zh).format(this);

  /// yyyy-MM-dd
  String get toYmd => DateFormat(ZTimeFormat.ymd).format(this);

  /// yyyy年MM月dd日
  String get toYmdZh => DateFormat(ZTimeFormat.ymd_zh).format(this);

  /// YY-mm
  String get toYm => DateFormat(ZTimeFormat.ym).format(this);

  /// MM-dd
  String get toMd => DateFormat(ZTimeFormat.md).format(this);

  /// MM月dd日
  String get toMdZh => DateFormat(ZTimeFormat.md_zh).format(this);

  /// HH:mm:ss
  String get toHms => DateFormat(ZTimeFormat.hms).format(this);

  /// HH点mm分ss秒
  String get toHmsZh => DateFormat(ZTimeFormat.hms_zh).format(this);

  /// yyyy-MM-dd\'T\'HH:mm:ss\'.0Z\'
  String get toRfc3339 => DateFormat(ZTimeFormat.rfc3339).format(this);

  /// DateTime转字符串
  String toStr(String format){
    assert(format != null, 'format不可为null');
    try{
      return DateFormat(format).format(this);
    }catch(_){
      throw('format格式不符合规范，当前format为($format)');
    }
  }

  /// 获取指定DateTime这一天的开始时间
  DateTime get theDayStart => DateTime(this.year, this.month, this.day, 0, 0, 0);

  /// 获取指定DateTime这一天的结束时间
  DateTime get theDayEnd => DateTime(this.year, this.month, this.day, 23, 59, 59);
}
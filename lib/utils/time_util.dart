import 'package:intl/intl.dart';
import '../extension/extension_num.dart';

/// @author zdl
/// date 2021/03/29 15:46
/// email zdl328465042@163.com
/// description 时间相关
class ZTimeUtil {
  const ZTimeUtil._();

  static DateTime _now = DateTime.now();

  /// 获取年
  static int get getYear => _now.year;

  /// 获取月
  static int get getMonth => _now.month;

  /// 获取日
  static int get getDay => _now.day;

  /// 获取时
  static int get getHour => _now.hour;

  /// 获取分
  static int get getMinute => _now.minute;

  /// 获取秒
  static int get getSecond => _now.second;

  /// 获取时间戳-秒
  static int get getTimestamp => getTimestampMilli ~/ 1000;

  /// 获取时间戳-毫秒
  static int get getTimestampMilli => _now.millisecondsSinceEpoch;

  /// 获取周几
  static int get getWeekday => _now.weekday;

  /// 获取某天开始时间
  static DateTime getDayStart(DateTime dateTime) {
    assert(dateTime != null, "DateTime为null");
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
  }

  /// 获取某天结束时间
  static DateTime getDayEnd(DateTime dateTime) {
    assert(dateTime != null, "DateTime为null");
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }

  /// 获取当前时间
  /// [isStart] null:当前时间；true:今天开始时间；false:今天结束时间
  static DateTime getCurrentDay({bool isStart}) {
    return isStart == null ? _now : (isStart ? DateTime(getYear, getMonth, getDay, 0, 0, 0) : DateTime(getYear, getMonth, getDay, 23, 59, 59));
  }

  /// 获取季度
  /// [month] 指定解析月份
  static int getQuarter(int month) {
    assert(month.isMonth, '解析月份不正确，当前解析的月份为($month)');
    return (month / 3).ceil();
  }

  /// 在当前时间下，指定往前、往后几天
  /// [days] = 0，为今天；> 0，为往后多少天；< 0，为往前几天
  static DateTime getAssignDay(int days) {
    assert(days != null, '指定天数不正确，当前指定天数为($days)');
    return days >= 0 ? getDayEnd(_now.add(Duration(days: days))) : getDayStart(_now.subtract(Duration(days: days.abs())));
  }

  /// 字符串转DateTime
  static DateTime str2date(String dateStr, [String format = ZTimeFormat.def]) {
    assert(dateStr != null, '字符串不可为null');
    var df = DateFormat(format);
    try {
      return df.parse(dateStr);
    } catch (_) {
      throw ('字符串格式与format不匹配，当前字符串($dateStr)，当前format($format)');
    }
  }

  /// 时间戳转DateTime
  static DateTime time2date(int time) {
    assert(time != null, '时间戳不可为null');
    var timeLength = time.toString().length;
    assert(timeLength == 10 || timeLength == 13, '时间戳长度不正确，当前时间戳为($time)');
    return DateTime.fromMillisecondsSinceEpoch(timeLength == 10 ? time * 1000 : time);
  }

  /// 获取间隔天数
  static int getIntervalDay(DateTime date1, DateTime date2) {
    assert(date1 != null && date2 != null, 'DateTime不可为null');
    return date1.difference(date2).inDays.abs();
  }

  /// 获取月开始时间
  static DateTime getMonthStartOrEnd(bool isStart, {int year, int month}) {
    assert(isStart != null, '必须指定获取月初月末');
    if (year != null)
      assert(year > 0, '年份不正确，当前年份为($year)');
    else
      year = getYear;

    if (month != null)
      assert(month.isMonth, '月份不正确，当前月份为($month)');
    else
      month = getMonth;
    //dart已经处理了月份超出12的情况，比如month+1为12+1，则DateTime会跳到下一年1月
    return isStart ? DateTime(year, month, 1, 0, 0, 0) : DateTime(year, month + 1, 1, 23, 59, 59).subtract(Duration(days: 1));
  }

  /// 在当前时间下，指定往前、往后几月
  /// [months] = 0，为今天；> 0，为往后多少天；< 0，为往前几天
  static String getAssignMonth(int months, [int year, int month, String format = ZTimeFormat.ym_no_gap]){
    assert(months != null, '指定月份不正确，当前指定月份为($months)');
    assert(year == null || year.isYear, '指定年不正确，当前指定年为($year)');
    assert(month == null || month.isMonth, '指定月不正确，当前指定月为($month)');
    if (null == year) year = getYear;
    if (null == month) month = getMonth;
    var ym = DateTime(year, month + months);
    var df = DateFormat(format);
    return df.format(ym);
  }
}

class ZTimeFormat {
  const ZTimeFormat._();

  static const String def = 'yyyy-MM-dd HH:mm:ss';
  static const String def_zh = 'yyyy年MM月dd日 HH点mm分ss秒';
  static const String ymd_hm = 'yyyy-MM-dd HH:mm';
  static const String ymd_hm_zh = 'yyyy年MM月dd日 HH点mm分';
  static const String ymd = 'yyyy-MM-dd';
  static const String ymd_zh = 'yyyy年MM月dd日';
  static const String ym = 'yyyy-MM';
  static const String ym_no_gap = 'yyyyMM';
  static const String md = 'MM-dd';
  static const String md_zh = 'MM月dd日';
  static const String hms = 'HH:mm:ss';
  static const String hms_zh = 'HH点mm分ss秒';
  static const String rfc3339 = 'yyyy-MM-dd\'T\'HH:mm:ss\'.0Z\'';
}

import 'package:intl/intl.dart';
import '../utils/z_global.dart';
import '../extension/extension_num.dart';
import '../extension/extension_date_time.dart';

/// @author zdl
/// date 2020/3/31 10:45
/// email zdl328465042@163.com
/// description 日期时间相关工具类

class ZDateTimeFormat {
  const ZDateTimeFormat._();

  static const String formatDefault = 'yyyy-MM-dd HH:mm:ss';
  static const String formatYMD = 'yyyy-MM-dd';
  static const String formatHMS = 'HH:mm:ss';
  static const String formatYMDHM = 'yyyy-MM-dd HH:mm';
  static const String formatRFC3339 = 'yyyy-MM-dd\'T\'HH:mm:ss\'.0Z\'';
}

class ZDateTimeUtil {
  const ZDateTimeUtil._();

  static DateTime _now = DateTime.now();

  ///获取年
  static int get getYear => _now.year;

  ///获取月
  static int get getMonth => _now.month;

  ///获取日
  static int get getDay => _now.day;

  ///获取时
  static int get getHour => _now.hour;

  ///获取分
  static int get getMinute => _now.minute;

  ///获取秒
  static int get getSecond => _now.second;

  ///获取微秒
  static int get getCurrentMillisecondsSinceEpoch =>
      _now.millisecondsSinceEpoch;

  ///获取周几
  static dynamic getWeekday({bool isNum = true}) =>
      isNum ? _now.weekday : _now.weekday.toZh();

  ///获取季度
  ///month: 不传则获取本月季度
  static dynamic getQuarter({int month, bool isNum = true}) {
    if (ZGlobal.isEmpty(month)) month = getMonth;
    int quarter = 0;
    switch (month) {
      case 1:
      case 2:
      case 3:
        quarter = 1;
        break;
      case 4:
      case 5:
      case 6:
        quarter = 2;
        break;
      case 7:
      case 8:
      case 9:
        quarter = 3;
        break;
      case 10:
      case 11:
      case 12:
        quarter = 4;
        break;
      default:
        throw ('月份错误，请检查');
        break;
    }
    return isNum ? quarter : quarter.toZh();
  }

  ///在当前时间下，指定往前、往后几天
  ///days > 0，为往后多少天；days < 0，为往前几天
  static String getAssignDay(int days,
      {String format = ZDateTimeFormat.formatDefault}) {
    days = days ?? 0;
    int time;
    String end;
    if (days >= 0) {
      time = _now.add(Duration(days: days)).millisecondsSinceEpoch;
      end = '23:59:59';
    } else {
      time = _now.subtract(Duration(days: days.abs())).millisecondsSinceEpoch;
      end = '00:00:00';
    }
    if (format == ZDateTimeFormat.formatDefault)
      return time2str(time, format: format).replaceRange(11, 19, end);
    else
      return time2str(time, format: format);
  }

  ///获取今天开始的时间或者结束的时间
  static String getCurrentDay({bool isEnd = true}) =>
      '${time2str(getCurrentMillisecondsSinceEpoch, format: ZDateTimeFormat.formatYMD)} ${isEnd ? '23:59:59' : '00:00:00'}';

  ///时间戳转字符串日期
  static String time2str(int time,
      {String format = ZDateTimeFormat.formatDefault}) {
    if (time.toString().length == 10) time = time * 1000;
    DateFormat df = DateFormat(format);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    return df.format(date);
  }

  ///字符串转DateTime
  static DateTime str2dateTime(String str,
      {String format = ZDateTimeFormat.formatDefault}) {
    DateFormat df = DateFormat(format);
    DateTime dt;
    try {
      dt = df.parse(str);
    } catch (e) {
      print(e);
    }
    return dt ?? DateTime.now();
  }

  ///获取间隔天数
  static int intervalDay(DateTime date1, DateTime date2) {
    return ((date1.millisecondsSinceEpoch - date2.millisecondsSinceEpoch)
                .abs() /
            (1000 * 60 * 60 * 24))
        .floor();
  }

  /// 获取周开始结束时间
  static DateTime getWeekStartOrEnd(bool isStart, {int year, int month, int day}) {
    assert(isStart != null, '必须指定获取周的开始结束');
    if (year == null) year = getYear;
    if (month == null) month = getMonth;
    if (day == null) day = getDay;
    var weekday = DateTime(year, month, day).weekday;
    //dart已经处理了日期负数和超出31的情况，比如day为负数，则DateTime会往前多少天，超出31自动计算跳几个月
    //计算开始日期，必须+1，否则是从上周日到本周日
    return isStart ? DateTime(year, month, day+1 - weekday).theDayStart : DateTime(year, month, day + (7 - weekday)).theDayEnd;
  }
}

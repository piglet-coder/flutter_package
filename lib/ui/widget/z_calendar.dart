import 'package:flutter/material.dart';
import 'package:flutter_package/flutter_package.dart';

typedef OnChangeDay<int> = void Function(int index);
typedef OnChangeMonth<String> = void Function(String ym);

class ZCalendar extends StatefulWidget {
  final Map<int, int> signData;
  final OnChangeDay onChangeDay;
  final OnChangeMonth onChangeMonth;

  const ZCalendar(this.signData, this.onChangeDay, this.onChangeMonth);

  @override
  _ZCalendarState createState() => _ZCalendarState();
}

class _ZCalendarState extends State<ZCalendar> {
  int _year = DateTime.now().year; //当前展示年
  int _month = DateTime.now().month; //当前展示月
  int _day = DateTime.now().day; //当前展示日
  List _datas = []; //日期数组--只展示一个月份
  int _choose;

  @override
  void initState() {
    super.initState();
    _setData(year: _year, month: _month);
    _choose = _day;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.toFit()),
      ),
      child: Column(
        children: [
          _yearHeader(),
          _weekHeader(),
          _everyDay(),
          SizedBox(height: 20.toFit()),
        ],
      ),
    );
  }

//头部：月份，切换上下月
  Widget _yearHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.toFit(), vertical: 35.toFit()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _lastMonth(),
            child: Padding(
              padding: EdgeInsets.all(10.toFit()),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.black,
                size: 40.toFit(),
              ),
            ),
          ),
          Text(
            '${int.parse(_datas[10].substring(0, 2)).toZh()}月',
            style: TextStyle(
              color: '#292929'.toColor(),
              fontSize: 32.toFit(),
            ),
          ),
          InkWell(
            onTap: () => _nextMonth(),
            child: Padding(
              padding: EdgeInsets.all(10.toFit()),
              child: Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.black,
                size: 40.toFit(),
              ),
            ),
          ),
        ],
      ),
    );
  }

//中部周
  Widget _weekHeader() {
    var array = ["日", "一", "二", "三", "四", "五", "六"];
    return Container(
      alignment: Alignment.center,
      child: GridView.builder(
        itemCount: array.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, //每行7列
          crossAxisSpacing: 5.toFit(), //横轴间距
          mainAxisSpacing: 20.toFit(), //纵轴间距
        ),
        itemBuilder: (context, index) {
          return Container(
              alignment: Alignment.center,
              child: Text(
                array[index],
                style: TextStyle(
                  color: '#292929'.toColor(),
                  fontSize: 27.toFit(),
                ),
              ));
        },
      ),
    );
  }

  Widget _everyDay() {
    return Container(
      alignment: Alignment.center,
      child: GridView.builder(
        itemCount: _getRowsForMonthYear(year: _year, month: _month) * 7,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, //每行7列
          childAspectRatio: 1.2, //设置每子元素的大小（宽高比）
          crossAxisSpacing: 5.toFit(), //横轴间距
          mainAxisSpacing: 10.toFit(), //纵轴间距
        ),
        itemBuilder: (context, index) {
          int d = int.parse(_datas[index].substring(3, 5));
          bool currMonth = int.parse(_datas[index].substring(0, 2)) == _month;
          bool isChoose = d == _choose;
          return InkWell(
            onTap: () {
              setState(() {
                if (!currMonth) return;
                widget.onChangeDay(d);
                _choose = d;
              });
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: currMonth && isChoose ? '#347AF6'.toColor() : null,
                    borderRadius: BorderRadius.circular(8.toFit()),
                  ),
                  child: Text(
                    d.toString(),
                    style: TextStyle(
                      color: currMonth ? (isChoose ? Colors.white : '#292929'.toColor()) : '#292929'.toColor().withOpacity(0.6),
                      fontSize: 27.toFit(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Text(
                    widget.signData.containsKey(d) ? '签到${widget.signData[d]}' : '',
                    style: TextStyle(
                      color: currMonth ? (isChoose ? Colors.white : '#666666'.toColor()) : '#666666'.toColor().withOpacity(0.6),
                      fontSize: 20.toFit(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// 获取行数
  int _getRowsForMonthYear({int year, int month}) {
    //当前月天数
    var _currentMonthDays = _getCurrentMonthDays(year: year, month: month);
    //补齐空缺需要的天数
    var _placeholderDays = _getPlaceholderDays(year: year, month: month);

    //以2022年11月为例，本月30天，第一天为周二，补齐第一天前面的空缺需要1天，30+1=31为本月天数在日历中的占位数
    int rows = (_currentMonthDays + _placeholderDays) ~/ 7;

    //若不能被7整除，则行数在取整行数上+1
    int remainder = (_currentMonthDays + _placeholderDays) % 7;
    if (remainder > 0) {
      rows = rows + 1;
    }
    return rows;
  }

// 获取当前月份天数
  int _getCurrentMonthDays({int year, int month}) {
    if (month == 2) {
      //判断2月份是闰年月还是平年
      if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
      return 31;
    } else {
      return 30;
    }
  }

// weekday得到这个月的第一天是星期几
// 因为该日历的每行是从周日开始，因此获取到本月的第一天是周几后需要-1得到还需要多少天补齐前面的空缺
  int _getPlaceholderDays({int year, int month}) {
    return DateTime(year, month).weekday % 7;
  }

  /// 获取展示信息
  _setData({int year, int month}) {

    /// 上个月占位--以本月为2022年11月为例，10.31在11月占位
    var lastYear = year;
    var lastMonth = month - 1;
    if (month == 1) {
      lastYear = year - 1;
      lastMonth = 12;
    }

    var placeholderDays = _getPlaceholderDays(year: year, month: month); //补齐本月第一天前的空缺需要的天数
    var lastMonthDays = _getCurrentMonthDays(year: lastYear, month: lastMonth); //上个月天数
    var firstDay = lastMonthDays - placeholderDays;
    for (var i = 0; i < placeholderDays; i++) {
      _datas.add('${_dateFormat(lastMonth)}-${_dateFormat(firstDay + i + 1)}');
    }

    /// 本月显示
    var currentMonthDays = _getCurrentMonthDays(year: year, month: month); //本月天数
    for (var i = 0; i < currentMonthDays; i++) {
      _datas.add('${_dateFormat(_month)}-${_dateFormat(i + 1)}');
    }

    /// 下个月占位--以本月为2022年11月为例，12月1-4日在11月占位
    var nextYear = year;
    var nextMonth = month + 1;
    if (month == 12) {
      nextYear = year + 1;
      nextMonth = 1;
    }
    var nextPlaceholderDays = _getPlaceholderDays(year: nextYear, month: nextMonth); //下个月补齐空缺需要的天数
    for (var i = 0; i < 7 - nextPlaceholderDays; i++) {
      _datas.add('${_dateFormat(nextMonth)}-${_dateFormat(i + 1)}');
    }
  }

//日期格式化-加0
  _dateFormat(int num) {
    if (num < 10) {
      return '0$num';
    } else {
      return '$num';
    }
  }

// 上月
  _lastMonth() {
    setState(() {
      //当前月是1月，上个月就是上一年的12月
      if (_month == 1) {
        _year = _year - 1;
        _month = 12;
      } else {
        _month = _month - 1;
      }
      _day = 1; //查看上一个月时，默认选中的为第一天
      _datas.clear();
      _setData(year: _year, month: _month);
      widget.onChangeMonth('$_year-$_month');
    });
  }

// 下月
  _nextMonth() {
    //判断展示年是否小于当前年,若是则操作上下月不受限制
    if (_year < DateTime.now().year) {
      _setNextMonthData();
    }
    //判断展示年是否是当前年，若是则需要再判断月份
    else if (_year == DateTime.now().year) {
      //当展示月大于等于当前月时，不能点击下个月，反之则需要设置下个月数据
      if (_month < DateTime.now().month) {
        _setNextMonthData();
      }
    }
  }

//设置下个月的数据
  _setNextMonthData() {
    setState(() {
      //当前月是12月，下个月就是下一年的1月
      if (_month == 12) {
        _year = _year + 1;
        _month = 1;
      } else {
        _month = _month + 1;
      }
      if (_month == DateTime.now().month) {
        //如果下个月时当前月，默认选中当天
        _day = DateTime.now().day;
      } else {
        //如果不是当前月，默认选中第一天
        _day = 1;
      }
      _datas.clear();
      _setData(year: _year, month: _month);
      widget.onChangeMonth('$_year-$_month');
    });
  }
}

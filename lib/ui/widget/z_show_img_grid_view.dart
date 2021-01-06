import 'package:flutter/material.dart';
import '../../flutter_package.dart';

/// @author zdl
/// date 2021/1/6 11:16
/// email zdl328465042@163.com
/// description 仿朋友样式九宫格展示图片
BuildContext _context;

class ZShowImgGridView extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color bgColor;

  final List<String> imgList;
  final int maxLength;
  final bool showDelete;
  final VoidCallback onClickAdd;
  final Function(int) onClickDelete;

  const ZShowImgGridView({
    this.margin,
    this.padding,
    this.bgColor,
    this.imgList,
    this.maxLength = 9,
    this.showDelete = true,
    this.onClickAdd,
    this.onClickDelete,
  })  : assert(imgList != null),
        assert(maxLength != null && maxLength >= 1);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      margin: margin,
      padding: padding,
      color: bgColor,
      child: _grid(),
    );
  }

  Widget _grid() {
    int listLength = imgList.length;
    int itemCount = listLength < maxLength ? listLength + 1 : listLength;
    return Container(
      margin: EdgeInsets.only(top: 50.toFit(), bottom: 20.toFit()),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (listLength == maxLength) {
            return _item(index, false);
          } else {
            return _item(index, index == itemCount - 1);
          }
        },
        itemCount: itemCount,
      ),
    );
  }

  Widget _item(int index, bool isAdd) {
    var widgetAdd;
    widgetAdd= Container(
      width: 180.toFit(),
      height: 180.toFit(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.toFit()),
        border:
        Border.all(color: Colors.grey, width: 1.toFit()),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.add,
        color: Colors.grey,
        size: 80.toFit(),
      ),
    );
    if(onClickAdd != null){
      widgetAdd = InkWell(
        onTap: onClickAdd,
        child: widgetAdd,
      );
    }
    var widgetDelete;
    widgetDelete = ZDot(
      radius: 40.toFit(),
      color: Colors.grey,
      child: Icon(
        Icons.clear,
        color: Colors.white,
        size: 30.toFit(),
      ),
    );
    if(onClickDelete != null){
      widgetDelete = InkWell(
        onTap: onClickDelete(index),
        child: widgetDelete,
      );
    }
    return Container(
      width: 200.toFit(),
      height: 200.toFit(),
      child: Stack(
        children: [
          Positioned(
            top: 20.toFit(),
            right: 20.toFit(),
            child: isAdd
                ? widgetAdd
                : InkWell(
                    onTap: () {
                      ZShowBigImg.show(
                        _context,
                        urls: imgList,
                        selectIndex: index,
                      );
                    },
                    child: ZImage(
                      src: imgList[index],
                      width: 180.toFit(),
                      height: 180.toFit(),
                      radius: 6.toFit(),
                    ),
                  ),
          ),
          Positioned(
            right: 0,
            child: Visibility(
              visible: !isAdd && showDelete == true,
              child: widgetDelete,
            ),
          ),
        ],
      ),
    );
  }
}

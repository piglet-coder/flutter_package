import 'package:flutter/material.dart';
import '../../flutter_package.dart';

/// @author zdl
/// date 2021/1/6 11:16
/// email zdl328465042@163.com
/// description 仿朋友样式九宫格展示图片

typedef OnDelete<int> = void Function(int index);

class ZAddImgGridView extends StatefulWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color bgColor;

  final List<String> imgList;
  final int maxLength;
  final bool showDelete;
  final OnDelete onDelete;
  final VoidCallback onClickAdd;

  const ZAddImgGridView({
    this.margin,
    this.padding,
    this.bgColor,
    this.imgList,
    this.maxLength = 9,
    this.showDelete = true,
    this.onDelete,
    this.onClickAdd,
  })  : assert(imgList != null),
        assert(maxLength != null && maxLength >= 1);

  @override
  _ZAddImgGridViewState createState() => _ZAddImgGridViewState();
}

class _ZAddImgGridViewState extends State<ZAddImgGridView> {
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      color: widget.bgColor,
      child: _grid(),
    );
  }

  Widget _grid() {
    int listLength = widget.imgList.length;
    int itemCount = listLength < widget.maxLength ? listLength + 1 : listLength;
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
          if (listLength == widget.maxLength) {
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
    return Container(
      width: 200.toFit(),
      height: 200.toFit(),
      child: Stack(
        children: [
          Positioned(
            top: 20.toFit(),
            right: 20.toFit(),
            child: isAdd
                ? InkWell(
                    onTap: widget.onClickAdd,
                    child: Container(
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
                    ),
                  )
                : InkWell(
                    onTap: () {
                      ZShowBigImg.show(
                        _context,
                        urls: widget.imgList,
                        selectIndex: index,
                      );
                    },
                    child: ZImage(
                      src: widget.imgList[index],
                      width: 180.toFit(),
                      height: 180.toFit(),
                      radius: 6.toFit(),
                    ),
                  ),
          ),
          Positioned(
            right: 0,
            child: Visibility(
              visible: !isAdd && widget.showDelete == true,
              child: InkWell(
                onTap: () {
                  widget.imgList.removeAt(index);
                  if(widget.onDelete != null)
                    widget.onDelete(index);
                  setState(() {});
                },
                child: ZDot(
                  radius: 40.toFit(),
                  color: Colors.grey,
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 30.toFit(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

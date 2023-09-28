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
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  final List<String> imgList;
  final int maxLength;
  final bool showDelete;
  final OnDelete onDelete;
  final VoidCallback onClickAdd;

  const ZAddImgGridView({
    this.margin,
    this.padding,
    this.bgColor,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: widget.mainAxisSpacing ?? 0,
        crossAxisSpacing: widget.crossAxisSpacing ?? 0,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (listLength == widget.maxLength) {
          return _item(index, false);
        } else {
          return _item(index, index == itemCount - 1);
        }
      },
      itemCount: itemCount,
    );
  }

  Widget _item(int index, bool isAdd) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth - 15.toFit();
        final height = constraints.maxHeight - 15.toFit();
        return Stack(
          children: [
            Positioned(
              top: 15.toFit(),
              right: 15.toFit(),
              child: isAdd
                  ? InkWell(
                      onTap: widget.onClickAdd,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.toFit()),
                          border: Border.all(color: Colors.grey, width: 1.toFit()),
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
                        width: width,
                        height: height,
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
                    if (widget.onDelete != null) widget.onDelete(index);
                    setState(() {});
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.grey,
                    size: 40.toFit(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

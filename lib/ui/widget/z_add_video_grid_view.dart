import 'package:flutter/material.dart';
import '../../flutter_package.dart';

/// @author zdl
/// date 2023/10/13 18:44
/// email zdl328465042@163.com
/// description

class ZAddVideoGridView extends StatefulWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color bgColor;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  final List<String> imgList;
  final int maxLength;
  final bool showDelete;
  final Function(int) onDelete;
  final VoidCallback onClickAdd;
  final Function(int) onClickPlay;

  const ZAddVideoGridView({
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
    this.onClickPlay,
  })  : assert(imgList != null),
        assert(maxLength != null && maxLength >= 1);

  @override
  _ZAddVideoGridViewState createState() => _ZAddVideoGridViewState();
}

class _ZAddVideoGridViewState extends State<ZAddVideoGridView> {
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
    bool onlyView = widget.showDelete == true;
    int listLength = widget.imgList.length;
    int itemCount = onlyView ? listLength : (listLength < widget.maxLength ? listLength + 1 : listLength);
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
          return _item(index, onlyView ? false : (index == itemCount - 1));
        }
      },
      itemCount: itemCount,
    );
  }

  Widget _item(int index, bool isAdd) {
    bool onlyView = widget.showDelete == true;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth - (onlyView ? 0 : 15.toFit());
        final height = constraints.maxHeight - (onlyView ? 0 : 15.toFit());
        return Stack(
          children: [
            Positioned(
              top: onlyView ? 0 : 15.toFit(),
              right: onlyView ? 0 : 15.toFit(),
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
                      onTap: () => widget.onClickPlay(index),
                      child: Stack(
                        children: [
                          ZImage(
                            src: widget.imgList[index],
                            width: width,
                            height: height,
                            radius: 6.toFit(),
                          ),
                          Container(
                            width: width,
                            height: height,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.grey.withOpacity(0.6),
                              size: 60.toFit(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Positioned(
              right: 0,
              child: Visibility(
                visible: !isAdd && onlyView,
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

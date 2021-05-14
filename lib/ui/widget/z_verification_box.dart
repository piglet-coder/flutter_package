import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// @author zdl
/// date 2021/05/14 11:01
/// email zdl328465042@163.com
/// description 验证码输入框
/// copy by https://github.com/LaoMengFlutter/flutter-do/tree/master/flutter_verification_box
class ZVerificationBox extends StatefulWidget {
  ZVerificationBox(
      {this.count = 6,
      this.itemWidget = 45,
      this.onSubmitted,
      this.type = ZVerificationBoxItemType.box,
      this.decoration,
      this.borderWidth = 2.0,
      this.borderRadius = 5.0,
      this.textStyle,
      this.focusBorderColor,
      this.borderColor,
      this.unFocus = true,
      this.autoFocus = true,
      this.showCursor = false,
      this.cursorWidth = 2,
      this.cursorColor,
      this.cursorIndent = 10,
      this.cursorEndIndent = 10});

  // 几位验证码，一般6位，还有4位的
  final int count;

  // 每一个item的宽
  final double itemWidget;

  // 输入完成回调
  final ValueChanged onSubmitted;

  // 每个item的装饰类型，[VerificationBoxItemType]
  final ZVerificationBoxItemType type;

  // 每个item的样式
  final Decoration decoration;

  // 边框宽度
  final double borderWidth;

  // 边框颜色
  final Color borderColor;

  // 获取焦点边框的颜色
  final Color focusBorderColor;

  // [VerificationBoxItemType.box] 边框圆角
  final double borderRadius;

  // 文本样式
  final TextStyle textStyle;

  // 输入完成后是否失去焦点，默认true，失去焦点后，软键盘消失
  final bool unFocus;

  // 是否自动获取焦点
  final bool autoFocus;

  // 是否显示光标
  final bool showCursor;

  // 光标颜色
  final Color cursorColor;

  // 光标宽度
  final double cursorWidth;

  // 光标距离顶部距离
  final double cursorIndent;

  // 光标距离底部距离
  final double cursorEndIndent;

  @override
  State<StatefulWidget> createState() => _ZVerificationBox();
}

class _ZVerificationBox extends State<ZVerificationBox> {
  TextEditingController _controller;

  FocusNode _focusNode;

  List _contentList = [];

  @override
  void initState() {
    List.generate(widget.count, (index) {
      _contentList.add('');
    });
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.count, (index) {
                return Container(
                  width: widget.itemWidget,
                  child: VerificationBoxItem(
                    data: _contentList[index],
                    textStyle: widget.textStyle,
                    type: widget.type,
                    decoration: widget.decoration,
                    borderRadius: widget.borderRadius,
                    borderWidth: widget.borderWidth,
                    borderColor: (_controller.text.length == index ? widget.focusBorderColor : widget.borderColor) ?? widget.borderColor,
                    showCursor: widget.showCursor && _controller.text.length == index,
                    cursorColor: widget.cursorColor,
                    cursorWidth: widget.cursorWidth,
                    cursorIndent: widget.cursorIndent,
                    cursorEndIndent: widget.cursorEndIndent,
                  ),
                );
              }),
            ),
          ),
          _buildTextField(),
        ],
      ),
    );
  }

  ///
  /// 构建TextField
  ///
  _buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      ),
      cursorWidth: 0,
      autofocus: widget.autoFocus,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
      maxLength: widget.count,
      buildCounter: (
        BuildContext context, {
        int currentLength,
        int maxLength,
        bool isFocused,
      }) {
        return Text('');
      },
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.transparent),
      onChanged: _onValueChange,
    );
  }

  _onValueChange(value) {
    for (int i = 0; i < widget.count; i++) {
      if (i < value.length) {
        _contentList[i] = value.substring(i, i + 1);
      } else {
        _contentList[i] = '';
      }
    }
    setState(() {});

    if (value.length == widget.count) {
      if (widget.unFocus) {
        _focusNode.unfocus();
      }
      if (widget.onSubmitted != null) {
        widget.onSubmitted(value);
      }
    }
  }
}

///
/// 输入框样式
///
enum ZVerificationBoxItemType {
  //下划线
  underline,

  // 盒子
  box,
}

///
/// 单个输入框
///
class VerificationBoxItem extends StatelessWidget {
  VerificationBoxItem(
      {this.data = '',
      this.textStyle,
      this.type = ZVerificationBoxItemType.box,
      this.decoration,
      this.borderRadius = 5.0,
      this.borderWidth = 2.0,
      this.borderColor,
      this.showCursor = false,
      this.cursorColor,
      this.cursorWidth = 2,
      this.cursorIndent = 5,
      this.cursorEndIndent = 5});

  final String data;
  final ZVerificationBoxItemType type;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final TextStyle textStyle;
  final Decoration decoration;

  // 是否显示光标
  final bool showCursor;

  // 光标颜色
  final Color cursorColor;

  // 光标宽度
  final double cursorWidth;

  // 光标距离顶部距离
  final double cursorIndent;

  // 光标距离底部距离
  final double cursorEndIndent;

  @override
  Widget build(BuildContext context) {
    var borderColor = this.borderColor ?? Theme.of(context).dividerColor;
    var text = _buildText();
    var widget;
    if (type == ZVerificationBoxItemType.box) {
      widget = _buildBoxDecoration(text, borderColor);
    } else {
      widget = _buildUnderlineDecoration(text, borderColor);
    }

    return Stack(
      children: <Widget>[
        widget,
        showCursor
            ? Positioned.fill(
                child: ZVerificationBoxCursor(
                color: cursorColor ?? Theme.of(context).cursorColor,
                width: cursorWidth,
                indent: cursorIndent,
                endIndent: cursorEndIndent,
              ))
            : Container()
      ],
    );
  }

  ///
  /// 绘制盒子类型
  ///
  _buildBoxDecoration(Widget child, Color borderColor) {
    return Container(
      alignment: Alignment.center,
      decoration: decoration ?? BoxDecoration(borderRadius: BorderRadius.circular(this.borderRadius), border: Border.all(color: borderColor, width: this.borderWidth)),
      child: child,
    );
  }

  ///
  /// 绘制下划线类型
  ///
  _buildUnderlineDecoration(Widget child, Color borderColor) {
    return Container(
      alignment: Alignment.center,
      decoration: UnderlineTabIndicator(borderSide: BorderSide(width: this.borderWidth, color: borderColor)),
      child: child,
    );
  }

  ///
  /// 文本
  ///
  _buildText() {
    return Text(
      '$data',
      style: textStyle,
    );
  }
}

///
/// des: 模拟光标
///
class ZVerificationBoxCursor extends StatefulWidget {
  ZVerificationBoxCursor({this.color, this.width, this.indent, this.endIndent});

  // 光标颜色
  final Color color;

  // 光标宽度
  final double width;

  // 光标距离顶部距离
  final double indent;

  // 光标距离底部距离
  final double endIndent;

  @override
  State<StatefulWidget> createState() => _ZVerificationBoxCursorState();
}

class _ZVerificationBoxCursorState extends State<ZVerificationBoxCursor> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: VerticalDivider(
        thickness: widget.width,
        color: widget.color,
        indent: widget.indent,
        endIndent: widget.endIndent,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

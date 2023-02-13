import 'package:flutter/material.dart';
import 'package:flutter_package/flutter_package.dart';
import 'package:flutter_package/utils/z_device_data_util.dart';
import 'package:flutter_package/extension/extension_num.dart';

class ZFeedbackWithKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final String sendText;
  final int maxLines;
  final ValueChanged clickSend;
  final String contentNullHintText;

  const ZFeedbackWithKeyboard._(
    this.controller,
    this.sendText,
    this.maxLines,
    this.clickSend,
    this.contentNullHintText,
  );

  //请使用此方法调用
  static void show(
    BuildContext context,
    TextEditingController controller, {
    String sendText = '发送',
    int maxLines = 1,
    ValueChanged clickSend,
    String contentNullHintText = '内容不可为空',
  }) {
    showDialog(
      context: context,
      builder: (_) => ZFeedbackWithKeyboard._(
        controller,
        sendText,
        maxLines,
        clickSend,
        contentNullHintText,
      ),
    );
  }

  @override
  _ZFeedbackWithKeyboardState createState() => _ZFeedbackWithKeyboardState();
}

class _ZFeedbackWithKeyboardState extends State<ZFeedbackWithKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: AnimatedPadding(
            //可以添加一个动画效果
            padding: MediaQuery.of(context).viewInsets, //边距（必要）
            duration: const Duration(milliseconds: 1000), //动画时常 （必要）
            child: Container(
              color: Colors.white, //评论位置颜色
              padding: new EdgeInsets.only(bottom: ZDeviceDataUtil.botBarHeight), //距离底部边界距离，这个是为了适配全面屏的，keyboard，bool类型，代表键盘的弹起和收回。true谈起，false收回，这个值怎么获取下面会有提到。
              child: Container(
                height: 200.toFit(), //设置输入框谈起和收回时的高度
                width: double.infinity, //设置宽度
                child: Flex(
                  //控件横向排版弹性布局
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center, //右边显示
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.all(10.toFit()),
                        child: TextField(
                          autofocus: true,
                          maxLines: widget.maxLines,
                          maxLength: 200,
                          controller: widget.controller,
                          //绑定TextEditController更好操作
                          style: TextStyle(
                            //设置字体、颜色
                            fontSize: 28.toFit(),
                            color: ZColorUtil.color_666,
                          ),
                          autocorrect: true,
                          decoration: InputDecoration(
                            //设置提示内容，字体颜色、大小等
                            border: InputBorder.none,
                            hintText: '请发表你的评论',
                            hintStyle: TextStyle(
                              fontSize: 28.toFit(),
                              color: ZColorUtil.color_999,
                            ),
                            contentPadding: EdgeInsets.all(10.toFit()),
                          ),
                          onChanged: (text) {
                            // 获取时时输入框的内容
                          },
                        ),
                        decoration: BoxDecoration(
                            //设置边框、圆角效果
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.toFit()),
                            border: new Border.all(width: 0.5.toFit(), color: Colors.grey)),
                      ),
                    ),
                    ZText(widget.sendText,
                      style: TextStyle(color: Colors.white, fontSize: 28.toFit()),
                      padding: EdgeInsets.all(10.toFit()),
                      margin: EdgeInsets.all(20.toFit()),
                      borderRadius: BorderRadius.all(Radius.circular(10.toFit())),
                      bgColor: Colors.blueAccent,
                      onTap: () {
                        // 点击发布按钮判断输入框内容是否为空，并提示用户
                        if ((widget.controller.text ?? '').isEmpty) {
                          ZToastUtil.show(widget.contentNullHintText);
                          return;
                        }
                        if(null != widget.clickSend){
                          widget.clickSend(widget.controller.text);
                        }
                        widget.controller.text = ''; //不为空，点击发布后，清空内容
                        ZGlobal.closeKeyBoard(context);
                        ZIntentUtil.finish(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

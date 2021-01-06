import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// @author zdl
/// date 2020/11/16 15:36
/// email zdl328465042@163.com
/// description 图片控件
class ZImage extends StatefulWidget {
  final dynamic src;
  final double width;
  final double height;
  final Color color;
  final BoxFit fit;
  final bool useCached;
  final double radius;
  final double aspectRatio;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String imageFolder;

  const ZImage({
    @required this.src,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.cover,
    this.useCached = false,
    this.radius = 0,
    this.aspectRatio,
    this.onTap,
    this.onLongPress,
    this.imageFolder = 'assets',
  });

  @override
  _ZImageState createState() => _ZImageState();
}

class _ZImageState extends State<ZImage> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    var image;
    //加载
    if (widget.src.startsWith(widget.imageFolder)) {
      //资源文件图片
      image = Image.asset(
        widget.src,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        fit: widget.fit,
      );
    } else if (widget.src.startsWith('http')) {
      //网络图片
      if (widget.useCached) {
        image = CachedNetworkImage(
          imageUrl: widget.src,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          fit: widget.fit,
        );
      } else {
        // image = FadeInImage.assetNetwork(
        //   placeholder: Icons.image,
        //   image: widget.src,
        //   width: widget.width,
        //   height: widget.height,
        //   fit: widget.fit,
        // );
        image = Image.network(
          widget.src,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      }
    } else if (widget.src is File) {
      //本地文件图片
      image = Image.file(
        widget.src,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    } else {
      image = Icon(
        Icons.image,
        size: widget.width,
      );
    }
    //裁剪
    if (widget.radius != 0) {
      if (widget.radius == double.infinity) {
        image = ClipOval(child: image);
      } else {
        image = ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: image,
        );
      }
    }
    //固定宽高比
    if (widget.aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: image,
      );
    }
    //点击事件
    if (widget.onTap != null || widget.onLongPress != null) {
      image = InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          foregroundDecoration: BoxDecoration(
            color: isDown ? Colors.white.withOpacity(0.5) : Colors.transparent,
          ),
          child: image,
        ),
        onTapDown: (_){
          setState(() {
            isDown = true;
          });
        },
        onTapCancel: (){
          setState(() {
            isDown = false;
          });
        },
        onHighlightChanged: (b){
          setState(() {
            if(!b) isDown = false;
          });
        },
      );
    }
    return image;
  }
}

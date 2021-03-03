import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_package/flutter_package.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';

/// @author zdl
/// date 2020/11/25 14:18
/// email zdl328465042@163.com
/// description 页面上点击查看大图
class ZShowBigImg extends StatelessWidget {
  final BuildContext context;
  final dynamic urls;
  final int selectIndex;
  final PageController pageController;

  ZShowBigImg._(
    this.context,
    this.urls,
    this.selectIndex,
    this.pageController,
  );

  static void show(
    BuildContext context, {
    dynamic urls,
    int selectIndex = 0,
    PageController pageController,
  }) {
    assert(selectIndex >= 0, 'selectIndex必须大于等于0');
    assert(urls is String || urls is List || urls is File,
        'ZShowBigImg中urls格式不正确，请检查');
    if (urls == null || urls == '' || urls == []) {
      return ZToastUtil.show('没有可以查看的图片');
    }
    pageController = pageController ?? PageController(initialPage: selectIndex);
    var page = ZShowBigImg._(
      context,
      urls,
      selectIndex,
      pageController,
    );
    ZIntentUtil.push(context, widget: page);
  }

  @override
  Widget build(BuildContext context) {
    List urlList = [];
    if (urls is String || urls is File) {
      urlList.add(urls);
    } else if (urls is List) {
      urlList.addAll(urls);
    }
    assert(selectIndex <= urlList.length - 1, 'selectIndex不能超出显示图片的张数');
    return Scaffold(
      body: InkWell(
        onTap: () {
          ZIntentUtil.finish(context);
        },
        onLongPress: () => onLongPress(),
        child: Stack(
          children: [
            _buildPhotoViewGallery(urlList),
            //只有一张图片，不展示圆点
            _buildIndicator(urlList.length == 1 ? 0 : urlList.length),
          ],
        ),
      ),
    );
  }

  void onLongPress() {
    showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.toFit())),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 220.toFit(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20.toFit())),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => saveImage(pageController.page.round()),
                  child: Container(
                    height: 100.toFit(),
                    alignment: Alignment.center,
                    child: Text(
                      '保存图片',
                      style: TextStyle(
                        color: '#121212'.toColor(),
                        fontSize: 32.toFit(),
                      ),
                    ),
                  ),
                ),
                ZLine(lineColor: '#F8F8F8'.toColor(), height: 20.toFit(),),
                InkWell(
                  onTap: () => ZIntentUtil.finish(context),
                  child: Container(
                    height: 100.toFit(),
                    alignment: Alignment.center,
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: '#121212'.toColor(),
                        fontSize: 32.toFit(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void saveImage(int index) async {
    var appDocDir = await ZIoUtil.getTempPath();
    String savePath = '$appDocDir/${ZDateTimeUtil.getCurrentMillisecondsSinceEpoch}.png';
    await Dio().download(urls[index], savePath);
    await ImageGallerySaver.saveFile(savePath);
    ZToastUtil.show('保存成功');
    ZIntentUtil.finish(context);
  }

  PhotoViewGallery _buildPhotoViewGallery(List urlList) {
    return PhotoViewGallery.builder(
      pageController: pageController,
      scrollPhysics: ClampingScrollPhysics(),
      backgroundDecoration: BoxDecoration(color: Colors.black),
      itemCount: urlList.length,
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: _imageProvider(urlList[index]),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.contained * 2,
        );
      },
      loadingBuilder: (context, progress) {
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        );
      },
    );
  }

  ImageProvider _imageProvider(dynamic url) {
    if (url.startsWith('assets')) {
      //资源文件图片
      return AssetImage(url);
    } else if (url.startsWith('http')) {
      //网络图片
      return NetworkImage(url);
    } else {
      //本地文件图片
      return FileImage(File(url));
    }
  }

  Positioned _buildIndicator(int length) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          ///自定义的圆点切换指示器
          child: _buildDotsIndicator(length),
        ),
      ),
    );
  }

  ///自定义的圆点切换指示器
  _DotsIndicator _buildDotsIndicator(int length) {
    return _DotsIndicator(
      ///与PageView联动的控制器
      controller: pageController,

      ///小圆点的个数
      itemCount: length,

      ///点击小圆点的回调
      onPageSelected: (int pageIndex) {
        ///主动切换页面
        pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
    );
  }
}

class _DotsIndicator extends AnimatedWidget {
  _DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.grey,
  }) : super(listenable: controller);

  final PageController controller;

  final int itemCount;

  final ValueChanged<int> onPageSelected;

  final Color color;

  static const double _kDotSize = 8.0;

  static const double _kMaxZoom = 2.0;

  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selected = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selected;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

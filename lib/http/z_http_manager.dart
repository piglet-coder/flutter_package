// import 'dart:developer';
//
// import 'package:connectivity/connectivity.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter_package/flutter_package.dart';
// import 'z_api.dart';
//
// /// @author zdl
// /// date 2020/11/12 17:26
// /// email zdl328465042@163.com
// /// description http_manager
// class ZHttpManager {
//   static const _tag = 'ZHttpManager';
//
//   static Future<ZResponseShell<T>> post<T>(
//     String url,
//     Map<String, dynamic> params, {
//     bool autoShowDialog = true,
//     bool autoHideDialog = true,
//     ValueChanged<T> onSuccess,
//     ValueChanged<T> onCache,
//     ValueChanged<String> onError,
//     RefreshController refreshController,
//   }) async {
//     //TODO autoShowDialog
//     if (autoShowDialog) ;
//     params = params ?? {};
//     params.addAll(ZHttpConfig.baseParams);
//     ZResponseShell responseShell =
//         await _netStart(url, params, RequestOptions(method: 'POST'));
//     ZResponseShell<T> data = ZResponseShell(responseShell.code, responseShell.msg);
//     if (data.code == ZHttpCode.ok) {
//       var queryDataType = T.toString();
//       if (queryDataType == 'String') {
//         data.data = responseShell.data;
//       } else if (queryDataType == 'List<String>') {
//         data.data = List<String>.from(responseShell.data) as T;
//       } else if (queryDataType == 'dynamic') {
//         data.data = responseShell.data;
//       } else {
//         data.data =
//         await Future.value(JsonConvert.fromJsonAsT<T>(responseShell.data));
//       }
//       if (onSuccess != null) onSuccess(data.data);
//     } else {
//       if (onError != null) onError('${data.msg ?? data.data}' ?? '请求失败');
//     }
//     //TODO autoHideDialog
//     if (autoHideDialog) ;
//     return Future.value(data);
//   }
//
//   static Future<ZResponseShell> _netStart(
//       String url, Map<String, dynamic> params, RequestOptions options) async {
//     assert(options != null);
//     var connectivityResult = await Connectivity().checkConnectivity();
//     switch (connectivityResult) {
//       case ConnectivityResult.none:
//         ZToastUtil.show('网络异常');
//         return Future.value(ZResponseShell(ZHttpCode.networkError, '网络异常'));
//         break;
//       case ConnectivityResult.mobile:
//         break;
//       case ConnectivityResult.wifi:
//         break;
//     }
//
//     options.headers.addAll(ZHttpConfig.baseHeader);
//     options.connectTimeout = ZHttpConfig.connectTimeout;
//     options.contentType = ZHttpConfig.bodyContentType;
//
//     Dio dio;
//     if (ZHttpConfig.bodyContentType == ZHttpConfig.CONTENT_TYPE_FORM_DATA) {
//       //form-data请求方式
//       BaseOptions baseOptions = BaseOptions(
//           baseUrl: ZApi.host,
//           connectTimeout: ZHttpConfig.connectTimeout,
//           contentType: ZHttpConfig.bodyContentType,
//           responseType: ResponseType.plain);
//       dio = Dio(baseOptions);
//     } else {
//       dio = Dio();
//     }
//
//     try {
//       FormData formData = FormData.fromMap(params);
//       Response response =
//           await dio.request(url, data: formData, options: options);
//       //打印成功数据
//       _logInfo(url, params, response.toString(), false);
//       var decode = response.data;
//       if (decode is String) {
//         decode = ZJsonUtil.getMap(response.data);
//       }
//       if (decode is List) {
//         decode = {'code': ZHttpCode.ok, 'data': decode};
//       } else if (decode is Map && !decode.containsKey('code')) {
//         decode = {'code': ZHttpCode.ok, 'data': decode};
//       }
//
//       ZResponseShell responseShell = ZResponseShell.fromJson(decode);
//       return Future.value(responseShell);
//     } on DioError catch (e) {
//       Response errorResponse =
//           e.response ?? Response(statusCode: ZHttpCode.noResponseError);
//       switch (e.type) {
//         case DioErrorType.CONNECT_TIMEOUT:
//           break;
//         case DioErrorType.SEND_TIMEOUT:
//           break;
//         case DioErrorType.RECEIVE_TIMEOUT:
//           break;
//         case DioErrorType.RESPONSE:
//           break;
//         case DioErrorType.CANCEL:
//           break;
//         case DioErrorType.DEFAULT:
//           break;
//       }
//       //打印异常数据
//       _logInfo(url, params, e.toString(), true);
//       var map = ZJsonUtil.getMap(e.response.toString());
//       int code =
//           map.containsKey('code') ? map['code'] : errorResponse.statusCode;
//       String msg = map.containsKey('msg') ? map['msg'] : '';
//       return Future.value(ZResponseShell(code, msg));
//     } catch (e) {
//       log(e.toString(), name: _tag);
//       return Future.value(
//           ZResponseShell(ZHttpCode.logicError, 'ZHttpManager逻辑异常'));
//     }
//   }
//
//   static void _logInfo(String url, Map params, String resStr, bool isError) {
//     if (ZConfig.isDebug) {
//       log('请求${isError ? '异常' : ''}url：$url', name: _tag);
//       log('请求${isError ? '异常' : ''}params：${ZJsonUtil.toJson(params)}',
//           name: _tag);
//       log('请求${isError ? '异常' : ''}header：${ZJsonUtil.toJson(ZHttpConfig.baseHeader)}',
//           name: _tag);
//       log('返回${isError ? '异常' : ''}数据：$resStr', name: _tag);
//     }
//   }
// }

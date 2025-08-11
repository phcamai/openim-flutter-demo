import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class Config {
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final path = (await getApplicationDocumentsDirectory()).path;
      cachePath = '$path/';
      await DataSp.init();
      await Hive.initFlutter(path);
      MediaKit.ensureInitialized();
      HttpUtil.init();
    } catch (_) {}

    runApp();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));

    final packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
  }

  static late String _appName;

  static late String cachePath;
  static const uiW = 375.0;
  static const uiH = 812.0;

  static const double textScaleFactor = 1.0;

  static const discoverPageURL = 'https://docs.openim.io/';
  static const allowSendMsgNotFriend = '1';
  // amap key
  static const webKey = 'webKey';
  static const webServerKey = 'webServerKey';
  static const locationHost = 'http://218.95.39.186/11001';

  static OfflinePushInfo get offlinePushInfo => OfflinePushInfo(
        title: _appName,
        desc: StrRes.offlineMessage,
        iOSBadgeCount: true,
      );

  static const friendScheme = "io.openim.app/addFriend/";
  static const groupScheme = "io.openim.app/joinGroup/";

  static const _host = "218.95.39.186";

  static const _ipRegex = '((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';

  static bool get _isIP => RegExp(_ipRegex).hasMatch(_host);

  static String get serverIp {
    String? ip;
    var server = DataSp.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
    }
    return ip ?? _host;
  }

  static String get chatTokenUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['chatTokenUrl'];
    }
    return url ?? (_isIP ? "http://$_host:10009" : "https://$_host/chat");
  }

  static String get appAuthUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
    }
    return url ?? (_isIP ? "http://$_host:10008" : "https://$_host/chat");
  }

  static String get imApiUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
    }
    return url ?? (_isIP ? 'http://$_host:10002' : "https://$_host/api");
  }

  static String get imWsUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
    }
    return url ?? (_isIP ? "ws://$_host:10001" : "wss://$_host/msg_gateway");
  }

  static int get logLevel {
    String? level;
    var server = DataSp.getServerConfig();
    if (null != server) {
      level = server['logLevel'];
    }
    return level == null ? 5 : int.parse(level);
  }
}

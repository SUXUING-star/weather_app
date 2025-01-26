// permission_request.dart
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationPermissionRequest extends StatefulWidget {
  final Function(LocationData?) onLocationReceived;
  final Function(String) onError;

  const LocationPermissionRequest({
    Key? key,
    required this.onLocationReceived,
    required this.onError,
  }) : super(key: key);

  @override
  State<LocationPermissionRequest> createState() =>
      _LocationPermissionRequestState();
}

class _LocationPermissionRequestState extends State<LocationPermissionRequest> {
  final Location location = Location();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationDialog().then((accepted) {
        if (accepted) {
          _checkPermission();
        }
      });
    });
  }

  Future<void> _checkPermission() async {
    void _fallbackToBeijing(String error) {
      debugPrint('位置获取失败，使用北京作为默认位置。错误: $error');
      widget.onLocationReceived(null);
    }

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _fallbackToBeijing("位置服务未启用");
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _fallbackToBeijing("位置权限未授予");
          return;
        }
      }

      try {
        // 添加10秒超时
        final LocationData? position =
            await location.getLocation().timeout(const Duration(seconds: 10));

        // 检查位置数据有效性
        if (position == null ||
            position.latitude == null ||
            position.longitude == null ||
            position.latitude == 0 ||
            position.longitude == 0) {
          _fallbackToBeijing("获取位置信息异常");
          return;
        }

        widget.onLocationReceived(position);
      } catch (e) {
        _fallbackToBeijing("获取位置失败: $e");
      }
    } catch (e) {
      _fallbackToBeijing("获取位置失败: $e");
    }
  }

  Future<bool> _showLocationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('位置权限请求'),
          content: const Text('为了提供准确的天气信息，我们需要访问您的位置信息。'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(false);
                widget.onError("需要位置权限才能获取天气信息");
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: SizedBox.shrink());
  }
}

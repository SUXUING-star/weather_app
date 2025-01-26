import 'package:flutter/material.dart';
import 'weather_detail_page.dart';

class WeatherDetailItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const WeatherDetailItem({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  Map<String, dynamic> _getDetailInfo() {
    switch (title) {
      case '湿度':
        return {
          'description': '湿度是空气中水汽含量的度量。它直接影响我们的体感温度和舒适度。',
          'characteristics': [
            {
              'title': '低湿度 (0-30%)',
              'content': '容易导致皮肤干燥、静电增加，建议使用加湿器。'
            },
            {
              'title': '适中湿度 (30-60%)',
              'content': '最适宜人体的湿度范围，空气清新舒适。'
            },
            {
              'title': '高湿度 (60%以上)',
              'content': '可能感觉闷热，容易滋生霉菌，建议开启除湿设备。'
            },
          ]
        };
      case '风速':
        return {
          'description': '风速表示空气流动的快慢，对天气变化和户外活动有重要影响。',
          'characteristics': [
            {
              'title': '微风 (0-11 km/h)',
              'content': '适合所有户外活动，树叶轻微摇摆。'
            },
            {
              'title': '中风 (12-28 km/h)',
              'content': '适合放风筝，树枝摇摆，外出注意保暖。'
            },
            {
              'title': '强风 (29+ km/h)',
              'content': '不适合撑伞，注意户外安全，谨防物品被吹落。'
            },
          ]
        };
      case '风向':
        return {
          'description': '风向指示风的来向，可帮助预测天气变化和空气质量。',
          'characteristics': [
            {
              'title': '季节性风向',
              'content': '不同季节主导风向变化，影响温度和降水。'
            },
            {
              'title': '天气系统',
              'content': '风向变化常预示天气系统的变化。'
            },
            {
              'title': '局地环境',
              'content': '建筑物和地形会影响局地风向。'
            },
          ]
        };
      case '气压':
        return {
          'description': '气压是单位面积上大气的压力，是重要的天气指标。',
          'characteristics': [
            {
              'title': '高气压 (1013 hPa以上)',
              'content': '常伴随晴朗天气，空气下沉。'
            },
            {
              'title': '正常气压 (1000-1013 hPa)',
              'content': '天气较为稳定，适合户外活动。'
            },
            {
              'title': '低气压 (1000 hPa以下)',
              'content': '可能出现降水或恶劣天气，注意防范。'
            },
          ]
        };
      default:
        return {
          'description': '天气数据详情',
          'characteristics': []
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailInfo = _getDetailInfo();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherDetailPage(
              title: title,
              value: value,
              icon: icon,
              description: detailInfo['description'],
              characteristics: List<Map<String, String>>.from(detailInfo['characteristics']),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
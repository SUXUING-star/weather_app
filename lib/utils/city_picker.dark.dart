// city_data.dart

class CityData {
  static const Map<String, Map<String, String>> provinces = {
    "北京市": {
      "北京": "101010100",
    },
    "上海市": {
      "上海": "101020100",
    },
    "广东省": {
      "广州": "101280101",
      "深圳": "101280601",
      "珠海": "101280701",
      "佛山": "101280800",
      "东莞": "101281601",
      "中山": "101281701",
    },
    "浙江省": {
      "杭州": "101210101",
      "宁波": "101210401",
      "温州": "101210701",
      "金华": "101210901",
    },
    "江苏省": {
      "南京": "101190101",
      "苏州": "101190401",
      "南通": "101190501",
      "常州": "101191101",
    },
    "四川省": {
      "成都": "101270101",
      "绵阳": "101270401",
      "宜宾": "101271101",
      "泸州": "101271001",
    },
  };

  static List<String> getProvinces() {
    return provinces.keys.toList();
  }

  static List<String> getCitiesByProvince(String province) {
    return provinces[province]?.keys.toList() ?? [];
  }

  static String? getCityCode(String province, String city) {
    return provinces[province]?[city];
  }
}
import "package:flutter/material.dart";

class LightTeam {
  LightTeam(
    final int id,
    final int number,
    final String name,
    final int colorsIndex,
  ) : this._inner(
          id,
          number,
          name,
          _teamNumberToColor[number] ?? _colors[colorsIndex],
          colorsIndex,
        );
  LightTeam.fromJson(final dynamic e)
      : this(
          e["id"] as int,
          e["number"] as int,
          e["name"] as String,
          e["colors_index"] as int,
        );
  LightTeam._inner(
    this.id,
    this.number,
    this.name,
    this.color,
    this.colorsIndex,
  );

  @override
  int get hashCode => Object.hashAll(<Object?>[id, number, colorsIndex, color]);

  final int id;
  final int number;
  final String name;
  final Color color;
  final int colorsIndex;

  @override
  bool operator ==(final Object other) =>
      other is LightTeam &&
      other.name == name &&
      other.id == id &&
      other.number == number &&
      other.colorsIndex == colorsIndex;
}

const Map<int, Color> _teamNumberToColor = <int, Color>{
  1: Color.fromARGB(255, 255, 255, 0),
  8: Color.fromARGB(255, 3, 87, 44),
  11: Color.fromARGB(255, 200, 34, 34),
  16: Color.fromARGB(255, 25, 35, 100),
  21: Color.fromARGB(255, 255, 255, 0),
  33: Color.fromARGB(255, 255, 184, 28),
  48: Color.fromARGB(255, 255, 255, 51),
  59: Color.fromARGB(255, 5, 56, 117),
  60: Color.fromARGB(255, 10, 60, 220),
  67: Color.fromARGB(255, 237, 134, 24),
  68: Color.fromARGB(255, 244, 84, 6),
  79: Color.fromARGB(255, 26, 178, 251),
  86: Color.fromARGB(255, 97, 253, 0),
  87: Color.fromARGB(255, 220, 110, 234),
  103: Color.fromARGB(255, 0, 0, 52),
  108: Color.fromARGB(255, 28, 92, 166),
  115: Color.fromARGB(255, 85, 5, 117),
  118: Color.fromARGB(255, 254, 176, 0),
  125: Color.fromARGB(255, 236, 41, 41),
  126: Color.fromARGB(255, 249, 166, 2),
  130: Color.fromARGB(255, 255, 128, 0),
  148: Color.fromARGB(255, 3, 7, 8),
  163: Color.fromARGB(255, 109, 38, 36),
  167: Color.fromARGB(255, 44, 179, 77),
  173: Color.fromARGB(255, 255, 42, 42),
  178: Color.fromARGB(255, 255, 208, 0),
  179: Color.fromARGB(255, 16, 250, 0),
  180: Color.fromARGB(255, 15, 35, 134),
  217: Color.fromARGB(255, 0, 217, 0),
  224: Color.fromARGB(255, 251, 192, 45),
  230: Color.fromARGB(255, 255, 165, 0),
  233: Color.fromARGB(255, 246, 99, 154),
  238: Color.fromARGB(255, 0, 0, 0),
  245: Color.fromARGB(255, 255, 216, 0),
  246: Color.fromARGB(255, 255, 36, 0),
  254: Color.fromARGB(255, 0, 112, 255),
  319: Color.fromARGB(255, 254, 91, 10),
  330: Color.fromARGB(255, 51, 15, 255),
  341: Color.fromARGB(255, 0, 134, 203),
  353: Color.fromARGB(255, 30, 72, 156),
  359: Color.fromARGB(255, 238, 30, 1),
  360: Color.fromARGB(255, 0, 51, 204),
  364: Color.fromARGB(255, 254, 137, 31),
  365: Color.fromARGB(255, 0, 255, 0),
  368: Color.fromARGB(255, 251, 214, 11),
  379: Color.fromARGB(255, 236, 16, 16),
  384: Color.fromARGB(255, 241, 91, 38),
  386: Color.fromARGB(255, 238, 241, 51),
  401: Color.fromARGB(255, 211, 84, 1),
  422: Color.fromARGB(255, 31, 178, 90),
  442: Color.fromARGB(255, 4, 4, 2),
  469: Color.fromARGB(255, 252, 240, 3),
  488: Color.fromARGB(255, 0, 0, 153),
  492: Color.fromARGB(255, 0, 153, 0),
  548: Color.fromARGB(255, 255, 152, 18),
  568: Color.fromARGB(255, 51, 102, 255),
  612: Color.fromARGB(255, 255, 101, 1),
  619: Color.fromARGB(255, 255, 103, 31),
  624: Color.fromARGB(255, 4, 240, 0),
  694: Color.fromARGB(255, 255, 0, 0),
  744: Color.fromARGB(255, 1, 177, 234),
  753: Color.fromARGB(255, 102, 255, 153),
  801: Color.fromARGB(255, 254, 255, 57),
  847: Color.fromARGB(255, 255, 204, 0),
  865: Color.fromARGB(255, 30, 46, 74),
  930: Color.fromARGB(255, 30, 34, 170),
  945: Color.fromARGB(255, 213, 226, 15),
  948: Color.fromARGB(255, 255, 0, 0),
  949: Color.fromARGB(255, 12, 40, 72),
  955: Color.fromARGB(255, 153, 0, 0),
  957: Color.fromARGB(255, 255, 255, 26),
  973: Color.fromARGB(255, 230, 121, 32),
  987: Color.fromARGB(255, 96, 43, 50),
  997: Color.fromARGB(255, 0, 0, 153),
  1065: Color.fromARGB(255, 0, 0, 254),
  1072: Color.fromARGB(255, 30, 49, 85),
  1114: Color.fromARGB(255, 180, 21, 11),
  1251: Color.fromARGB(255, 245, 67, 27),
  1258: Color.fromARGB(255, 0, 51, 153),
  1294: Color.fromARGB(255, 51, 102, 0),
  1318: Color.fromARGB(255, 89, 0, 179),
  1323: Color.fromARGB(255, 188, 195, 238),
  1325: Color.fromARGB(255, 33, 63, 153),
  1359: Color.fromARGB(255, 230, 0, 0),
  1369: Color.fromARGB(255, 169, 9, 43),
  1382: Color.fromARGB(255, 255, 105, 0),
  1410: Color.fromARGB(255, 50, 179, 76),
  1425: Color.fromARGB(255, 0, 0, 0),
  1432: Color.fromARGB(255, 255, 102, 0),
  1492: Color.fromARGB(255, 255, 255, 0),
  1510: Color.fromARGB(255, 255, 0, 0),
  1523: Color.fromARGB(255, 209, 42, 47),
  1540: Color.fromARGB(255, 255, 214, 2),
  1557: Color.fromARGB(255, 0, 0, 150),
  1571: Color.fromARGB(255, 255, 255, 255),
  1574: Color.fromARGB(255, 126, 12, 43),
  1576: Color.fromARGB(255, 252, 124, 23),
  1577: Color.fromARGB(255, 255, 165, 0),
  1580: Color.fromARGB(255, 4, 178, 241),
  1592: Color.fromARGB(255, 235, 106, 41),
  1595: Color.fromARGB(255, 255, 0, 0),
  1619: Color.fromARGB(255, 29, 188, 186),
  1640: Color.fromARGB(255, 0, 0, 255),
  1646: Color.fromARGB(255, 158, 0, 1),
  1648: Color.fromARGB(255, 255, 0, 0),
  1649: Color.fromARGB(255, 255, 246, 35),
  1657: Color.fromARGB(255, 53, 105, 30),
  1678: Color.fromARGB(255, 60, 212, 47),
  1690: Color.fromARGB(255, 0, 0, 252),
  1700: Color.fromARGB(255, 56, 118, 38),
  1732: Color.fromARGB(255, 0, 20, 50),
  1736: Color.fromARGB(255, 196, 0, 0),
  1744: Color.fromARGB(255, 255, 255, 255),
  1746: Color.fromARGB(255, 255, 0, 0),
  1756: Color.fromARGB(255, 240, 184, 35),
  1777: Color.fromARGB(255, 248, 217, 0),
  1778: Color.fromARGB(255, 0, 102, 255),
  1786: Color.fromARGB(255, 255, 140, 25),
  1797: Color.fromARGB(255, 147, 33, 26),
  1816: Color.fromARGB(255, 68, 176, 100),
  1825: Color.fromARGB(255, 17, 238, 17),
  1884: Color.fromARGB(255, 63, 63, 56),
  1885: Color.fromARGB(255, 102, 51, 153),
  1899: Color.fromARGB(255, 0, 0, 153),
  1902: Color.fromARGB(255, 247, 77, 41),
  1923: Color.fromARGB(255, 0, 0, 0),
  1937: Color.fromARGB(255, 0, 100, 204),
  1939: Color.fromARGB(255, 30, 198, 0),
  1943: Color.fromARGB(255, 30, 0, 220),
  1954: Color.fromARGB(255, 31, 86, 182),
  1983: Color.fromARGB(255, 0, 0, 0),
  1984: Color.fromARGB(255, 255, 255, 0),
  1986: Color.fromARGB(255, 76, 187, 23),
  2046: Color.fromARGB(255, 0, 0, 0),
  2052: Color.fromARGB(255, 115, 38, 38),
  2056: Color.fromARGB(255, 235, 55, 58),
  2062: Color.fromARGB(255, 0, 0, 0),
  2096: Color.fromARGB(255, 250, 232, 34),
  2102: Color.fromARGB(255, 255, 193, 7),
  2122: Color.fromARGB(255, 245, 186, 27),
  2147: Color.fromARGB(255, 0, 0, 153),
  2152: Color.fromARGB(255, 208, 100, 24),
  2168: Color.fromARGB(255, 216, 8, 0),
  2212: Color.fromARGB(255, 0, 21, 111),
  2230: Color.fromARGB(255, 49, 104, 205),
  2231: Color.fromARGB(255, 204, 4, 0),
  2262: Color.fromARGB(255, 30, 30, 30),
  2363: Color.fromARGB(255, 253, 184, 19),
  2370: Color.fromARGB(255, 147, 213, 0),
  2374: Color.fromARGB(255, 0, 102, 0),
  2383: Color.fromARGB(255, 37, 33, 34),
  2411: Color.fromARGB(255, 0, 51, 204),
  2412: Color.fromARGB(255, 237, 32, 51),
  2415: Color.fromARGB(255, 13, 70, 37),
  2425: Color.fromARGB(255, 245, 84, 100),
  2468: Color.fromARGB(255, 255, 0, 0),
  2471: Color.fromARGB(255, 191, 0, 0),
  2498: Color.fromARGB(255, 0, 0, 0),
  2499: Color.fromARGB(255, 40, 41, 72),
  2500: Color.fromARGB(255, 255, 0, 0),
  2501: Color.fromARGB(255, 0, 0, 0),
  2502: Color.fromARGB(255, 91, 106, 128),
  2503: Color.fromARGB(255, 0, 0, 0),
  2521: Color.fromARGB(255, 102, 1, 152),
  2522: Color.fromARGB(255, 250, 201, 38),
  2539: Color.fromARGB(255, 239, 127, 67),
  2550: Color.fromARGB(255, 0, 0, 0),
  2556: Color.fromARGB(255, 95, 84, 160),
  2557: Color.fromARGB(255, 219, 255, 36),
  2586: Color.fromARGB(255, 255, 179, 0),
  2605: Color.fromARGB(255, 0, 183, 63),
  2614: Color.fromARGB(255, 178, 34, 23),
  2619: Color.fromARGB(255, 0, 118, 40),
  2630: Color.fromARGB(255, 51, 164, 108),
  2635: Color.fromARGB(255, 26, 198, 255),
  2679: Color.fromARGB(255, 249, 160, 37),
  2702: Color.fromARGB(255, 189, 9, 9),
  2714: Color.fromARGB(255, 255, 102, 0),
  2733: Color.fromARGB(255, 102, 0, 204),
  2767: Color.fromARGB(255, 240, 185, 28),
  2791: Color.fromARGB(255, 0, 33, 64),
  2797: Color.fromARGB(255, 229, 208, 163),
  2811: Color.fromARGB(255, 0, 0, 128),
  2813: Color.fromARGB(255, 0, 0, 128),
  2834: Color.fromARGB(255, 71, 0, 104),
  2847: Color.fromARGB(255, 200, 30, 20),
  2898: Color.fromARGB(255, 0, 0, 230),
  2903: Color.fromARGB(255, 0, 0, 0),
  2907: Color.fromARGB(255, 0, 0, 255),
  2910: Color.fromARGB(255, 13, 163, 73),
  2916: Color.fromARGB(255, 4, 167, 208),
  2928: Color.fromARGB(255, 158, 12, 15),
  2930: Color.fromARGB(255, 217, 217, 217),
  2944: Color.fromARGB(255, 0, 0, 0),
  2972: Color.fromARGB(255, 0, 0, 0),
  2976: Color.fromARGB(255, 51, 90, 64),
  2980: Color.fromARGB(255, 255, 255, 255),
  2990: Color.fromARGB(255, 204, 204, 204),
  2996: Color.fromARGB(255, 249, 200, 3),
  3005: Color.fromARGB(255, 0, 35, 225),
  3015: Color.fromARGB(255, 25, 23, 74),
  3019: Color.fromARGB(255, 221, 25, 25),
  3024: Color.fromARGB(255, 204, 0, 0),
  3034: Color.fromARGB(255, 146, 4, 4),
  3065: Color.fromARGB(255, 255, 82, 0),
  3070: Color.fromARGB(255, 255, 102, 0),
  3075: Color.fromARGB(255, 80, 58, 123),
  3083: Color.fromARGB(255, 45, 110, 255),
  3131: Color.fromARGB(255, 255, 102, 0),
  3161: Color.fromARGB(255, 169, 132, 25),
  3175: Color.fromARGB(255, 255, 0, 0),
  3201: Color.fromARGB(255, 127, 20, 22),
  3211: Color.fromARGB(255, 45, 180, 236),
  3216: Color.fromARGB(255, 45, 49, 148),
  3218: Color.fromARGB(255, 0, 184, 230),
  3219: Color.fromARGB(255, 0, 153, 51),
  3223: Color.fromARGB(255, 0, 204, 255),
  3238: Color.fromARGB(255, 255, 26, 26),
  3316: Color.fromARGB(255, 255, 154, 30),
  3324: Color.fromARGB(255, 161, 32, 35),
  3339: Color.fromARGB(255, 245, 212, 9),
  3374: Color.fromARGB(255, 255, 165, 0),
  3388: Color.fromARGB(255, 231, 2, 2),
  3393: Color.fromARGB(255, 230, 92, 0),
  3538: Color.fromARGB(255, 0, 148, 148),
  3574: Color.fromARGB(255, 115, 0, 153),
  3588: Color.fromARGB(255, 0, 0, 102),
  3620: Color.fromARGB(255, 0, 38, 99),
  3623: Color.fromARGB(255, 0, 0, 0),
  3636: Color.fromARGB(255, 0, 0, 128),
  3641: Color.fromARGB(255, 0, 0, 0),
  3647: Color.fromARGB(255, 130, 28, 30),
  3663: Color.fromARGB(255, 0, 0, 128),
  3674: Color.fromARGB(255, 0, 179, 0),
  3711: Color.fromARGB(255, 0, 255, 0),
  3729: Color.fromARGB(255, 255, 0, 0),
  3763: Color.fromARGB(255, 0, 0, 77),
  3786: Color.fromARGB(255, 0, 128, 0),
  3835: Color.fromARGB(255, 0, 109, 255),
  3847: Color.fromARGB(255, 255, 255, 255),
  3863: Color.fromARGB(255, 69, 69, 69),
  3928: Color.fromARGB(255, 255, 153, 0),
  3940: Color.fromARGB(255, 180, 160, 200),
  4026: Color.fromARGB(255, 255, 255, 102),
  4028: Color.fromARGB(255, 80, 7, 120),
  4043: Color.fromARGB(255, 0, 0, 230),
  4061: Color.fromARGB(255, 255, 153, 51),
  4068: Color.fromARGB(255, 28, 48, 108),
  4180: Color.fromARGB(255, 0, 102, 0),
  4272: Color.fromARGB(255, 128, 24, 26),
  4293: Color.fromARGB(255, 116, 195, 215),
  4311: Color.fromARGB(255, 29, 78, 219),
  4319: Color.fromARGB(255, 255, 48, 207),
  4320: Color.fromARGB(255, 138, 0, 0),
  4338: Color.fromARGB(255, 241, 54, 64),
  4362: Color.fromARGB(255, 142, 14, 0),
  4392: Color.fromARGB(255, 47, 47, 130),
  4414: Color.fromARGB(255, 0, 182, 174),
  4416: Color.fromARGB(255, 68, 97, 115),
  4469: Color.fromARGB(255, 255, 209, 26),
  4488: Color.fromARGB(255, 0, 0, 0),
  4513: Color.fromARGB(255, 15, 97, 164),
  4522: Color.fromARGB(255, 240, 179, 3),
  4536: Color.fromARGB(255, 0, 0, 0),
  4549: Color.fromARGB(255, 128, 0, 0),
  4550: Color.fromARGB(255, 254, 45, 50),
  4586: Color.fromARGB(255, 45, 111, 180),
  4590: Color.fromARGB(255, 0, 255, 0),
  4607: Color.fromARGB(255, 0, 0, 0),
  4645: Color.fromARGB(255, 50, 105, 168),
  4649: Color.fromARGB(255, 214, 10, 0),
  4661: Color.fromARGB(255, 129, 19, 22),
  4681: Color.fromARGB(255, 170, 0, 0),
  4744: Color.fromARGB(255, 4, 48, 126),
  4757: Color.fromARGB(255, 215, 161, 29),
  4784: Color.fromARGB(255, 204, 153, 51),
  4855: Color.fromARGB(255, 65, 37, 97),
  4910: Color.fromARGB(255, 75, 42, 123),
  4911: Color.fromARGB(255, 180, 34, 39),
  4915: Color.fromARGB(255, 20, 85, 251),
  4944: Color.fromARGB(255, 73, 162, 249),
  4990: Color.fromARGB(255, 0, 80, 150),
  5010: Color.fromARGB(255, 255, 105, 0),
  5013: Color.fromARGB(255, 217, 40, 24),
  5026: Color.fromARGB(255, 154, 0, 0),
  5030: Color.fromARGB(255, 6, 73, 253),
  5038: Color.fromARGB(255, 255, 153, 51),
  5053: Color.fromARGB(255, 255, 255, 255),
  5113: Color.fromARGB(255, 255, 255, 0),
  5119: Color.fromARGB(255, 0, 0, 0),
  5123: Color.fromARGB(255, 41, 41, 41),
  5135: Color.fromARGB(255, 153, 153, 153),
  5172: Color.fromARGB(255, 107, 156, 75),
  5190: Color.fromARGB(255, 105, 10, 15),
  5291: Color.fromARGB(255, 204, 0, 0),
  5344: Color.fromARGB(255, 4, 30, 66),
  5414: Color.fromARGB(255, 90, 191, 52),
  5468: Color.fromARGB(255, 20, 198, 0),
  5498: Color.fromARGB(255, 255, 0, 0),
  5511: Color.fromARGB(255, 28, 70, 142),
  5554: Color.fromARGB(255, 0, 51, 102),
  5584: Color.fromARGB(255, 71, 69, 69),
  5614: Color.fromARGB(255, 51, 102, 51),
  5635: Color.fromARGB(255, 51, 0, 153),
  5654: Color.fromARGB(255, 255, 153, 51),
  5675: Color.fromARGB(255, 68, 114, 196),
  5687: Color.fromARGB(255, 147, 31, 33),
  5735: Color.fromARGB(255, 243, 127, 36),
  5747: Color.fromARGB(255, 102, 0, 51),
  5803: Color.fromARGB(255, 230, 0, 0),
  5928: Color.fromARGB(255, 51, 51, 153),
  5940: Color.fromARGB(255, 130, 24, 30),
  5951: Color.fromARGB(255, 255, 51, 51),
  5980: Color.fromARGB(255, 255, 206, 8),
  5987: Color.fromARGB(255, 0, 153, 153),
  5990: Color.fromARGB(255, 0, 153, 255),
  6104: Color.fromARGB(255, 0, 0, 0),
  6201: Color.fromARGB(255, 254, 0, 0),
  6230: Color.fromARGB(255, 153, 102, 153),
  6404: Color.fromARGB(255, 0, 128, 0),
  6445: Color.fromARGB(255, 255, 255, 255),
  6502: Color.fromARGB(255, 255, 93, 115),
  6574: Color.fromARGB(255, 236, 32, 36),
  6736: Color.fromARGB(255, 24, 61, 77),
  6738: Color.fromARGB(255, 153, 153, 153),
  6740: Color.fromARGB(255, 255, 0, 204),
  6741: Color.fromARGB(255, 51, 0, 0),
  6800: Color.fromARGB(255, 0, 0, 0),
  6814: Color.fromARGB(255, 124, 81, 165),
  6831: Color.fromARGB(255, 255, 255, 255),
  6845: Color.fromARGB(255, 255, 255, 255),
  6886: Color.fromARGB(255, 255, 165, 0),
  6908: Color.fromARGB(255, 0, 0, 255),
  7034: Color.fromARGB(255, 0, 153, 0),
  7039: Color.fromARGB(255, 0, 0, 0),
  7048: Color.fromARGB(255, 255, 0, 0),
  7067: Color.fromARGB(255, 255, 102, 51),
  7079: Color.fromARGB(255, 0, 0, 0),
  7112: Color.fromARGB(255, 51, 153, 51),
  7165: Color.fromARGB(255, 0, 0, 0),
  7222: Color.fromARGB(255, 0, 150, 255),
  7457: Color.fromARGB(255, 198, 186, 86),
  7769: Color.fromARGB(255, 0, 0, 128),
  8032: Color.fromARGB(255, 255, 0, 0),
};
const List<Color> _colors = <Color>[
  Color.fromARGB(255, 237, 192, 41),
  Color.fromARGB(255, 150, 122, 237),
  Color.fromARGB(255, 20, 192, 5),
  Color.fromARGB(255, 66, 187, 167),
  Color.fromARGB(255, 208, 218, 60),
  Color.fromARGB(255, 144, 173, 91),
  Color.fromARGB(255, 41, 190, 146),
  Color.fromARGB(255, 186, 123, 112),
  Color.fromARGB(255, 67, 160, 227),
  Color.fromARGB(255, 223, 190, 231),
  Color.fromARGB(255, 203, 18, 63),
  Color.fromARGB(255, 70, 98, 52),
  Color.fromARGB(255, 38, 225, 210),
  Color.fromARGB(255, 92, 125, 43),
  Color.fromARGB(255, 51, 175, 20),
  Color.fromARGB(255, 170, 246, 103),
  Color.fromARGB(255, 88, 197, 26),
  Color.fromARGB(255, 164, 82, 190),
  Color.fromARGB(255, 180, 24, 79),
  Color.fromARGB(255, 160, 27, 209),
  Color.fromARGB(255, 192, 133, 23),
  Color.fromARGB(255, 132, 66, 149),
  Color.fromARGB(255, 118, 175, 18),
  Color.fromARGB(255, 78, 46, 67),
  Color.fromARGB(255, 9, 99, 236),
  Color.fromARGB(255, 123, 219, 178),
  Color.fromARGB(255, 12, 60, 64),
  Color.fromARGB(255, 194, 27, 159),
  Color.fromARGB(255, 85, 147, 77),
  Color.fromARGB(255, 171, 176, 105),
  Color.fromARGB(255, 144, 23, 18),
  Color.fromARGB(255, 141, 176, 45),
  Color.fromARGB(255, 80, 19, 98),
  Color.fromARGB(255, 158, 104, 170),
  Color.fromARGB(255, 231, 30, 25),
  Color.fromARGB(255, 233, 126, 92),
  Color.fromARGB(255, 197, 197, 64),
  Color.fromARGB(255, 218, 252, 247),
  Color.fromARGB(255, 139, 30, 183),
  Color.fromARGB(255, 211, 221, 179),
  Color.fromARGB(255, 146, 112, 81),
  Color.fromARGB(255, 28, 252, 5),
  Color.fromARGB(255, 151, 209, 8),
  Color.fromARGB(255, 114, 169, 110),
  Color.fromARGB(255, 144, 209, 54),
  Color.fromARGB(255, 154, 158, 49),
  Color.fromARGB(255, 12, 246, 168),
  Color.fromARGB(255, 234, 23, 49),
  Color.fromARGB(255, 105, 183, 111),
  Color.fromARGB(255, 223, 232, 168),
  Color.fromARGB(255, 72, 240, 23),
  Color.fromARGB(255, 105, 118, 240),
  Color.fromARGB(255, 243, 126, 205),
  Color.fromARGB(255, 212, 136, 184),
  Color.fromARGB(255, 157, 67, 42),
  Color.fromARGB(255, 177, 124, 138),
  Color.fromARGB(255, 156, 77, 199),
  Color.fromARGB(255, 153, 177, 37),
  Color.fromARGB(255, 246, 106, 9),
  Color.fromARGB(255, 106, 171, 126),
  Color.fromARGB(255, 243, 47, 7),
  Color.fromARGB(255, 193, 12, 69),
  Color.fromARGB(255, 11, 2, 23),
  Color.fromARGB(255, 192, 130, 180),
  Color.fromARGB(255, 49, 111, 240),
  Color.fromARGB(255, 34, 15, 78),
  Color.fromARGB(255, 216, 239, 66),
  Color.fromARGB(255, 181, 176, 183),
  Color.fromARGB(255, 58, 174, 69),
  Color.fromARGB(255, 169, 50, 142),
  Color.fromARGB(255, 19, 105, 83),
  Color.fromARGB(255, 227, 169, 161),
  Color.fromARGB(255, 47, 15, 33),
  Color.fromARGB(255, 213, 19, 139),
  Color.fromARGB(255, 93, 24, 117),
  Color.fromARGB(255, 7, 20, 228),
  Color.fromARGB(255, 113, 198, 140),
  Color.fromARGB(255, 198, 173, 207),
  Color.fromARGB(255, 162, 124, 244),
  Color.fromARGB(255, 130, 96, 253),
  Color.fromARGB(255, 201, 130, 181),
  Color.fromARGB(255, 33, 238, 190),
  Color.fromARGB(255, 193, 236, 254),
  Color.fromARGB(255, 163, 155, 13),
  Color.fromARGB(255, 130, 155, 98),
  Color.fromARGB(255, 61, 99, 209),
  Color.fromARGB(255, 61, 32, 46),
  Color.fromARGB(255, 109, 194, 14),
  Color.fromARGB(255, 95, 221, 3),
  Color.fromARGB(255, 179, 42, 82),
  Color.fromARGB(255, 103, 33, 231),
  Color.fromARGB(255, 154, 107, 216),
  Color.fromARGB(255, 31, 79, 250),
  Color.fromARGB(255, 221, 231, 65),
  Color.fromARGB(255, 206, 93, 180),
  Color.fromARGB(255, 85, 223, 125),
  Color.fromARGB(255, 64, 95, 244),
  Color.fromARGB(255, 40, 209, 240),
  Color.fromARGB(255, 142, 17, 144),
  Color.fromARGB(255, 142, 76, 134),
];

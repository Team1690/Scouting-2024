import "dart:typed_data";

extension ToBytes on String {
  Uint8List toUint8List() {
    final List<int> codeUnits = this.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }
}

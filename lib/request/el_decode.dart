import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class SpDecodeUtils {
  static const int BF_SIZE = 2048;
  static const String EN_STR_TAG = r'$';

  static Uint8List randSalt() {
    final rand = Random.secure();
    final size = rand.nextInt(49) + 16; // 16..64
    final salt = Uint8List(size);
    for (int i = 0; i < size; i++) {
      salt[i] = rand.nextInt(256);
    }
    return salt;
  }

  static Uint8List en(Uint8List data) {
    if (data.isEmpty) return data;
    final salt = randSalt();
    final retData = <int>[];
    retData.add(salt.length);
    retData.addAll(salt);
    final encryptedData = enWithSalt(data, salt);
    retData.addAll(encryptedData);
    return Uint8List.fromList(retData);
  }

  static Uint8List de(Uint8List data) {
    if (data.isEmpty) return data;
    final saltLen = data[0];
    final salt = data.sublist(1, 1 + saltLen);
    final encrypted = data.sublist(1 + saltLen);
    return deWithSalt(encrypted, salt);
  }

  static Uint8List enWithSalt(Uint8List data, Uint8List salt) {
    final mixedData = mixSalt(data, salt);
    return cxEd(mixedData);
  }

  static Uint8List deWithSalt(Uint8List data, Uint8List salt) {
    final decryptedData = cxEd(data);
    return removeSalt(decryptedData, salt);
  }

  static Uint8List cxEd(Uint8List data) {
    return Uint8List.fromList(data.map((b) => b ^ 0xFF).toList());
  }

  static int calSalt(int v, int s) {
    final r = v ^ 0xFF;
    return s > r ? (s - r - 1) & 0xFF : (v + s) & 0xFF;
  }

  static int calRemoveSalt(int v, int s) {
    return v >= s ? (v - s) & 0xFF : (0xFF - (s - v) + 1) & 0xFF;
  }

  static Uint8List mixSalt(Uint8List data, Uint8List salt) {
    if (salt.isEmpty) return data;
    final ret = <int>[];
    for (int i = 0; i < data.length; i++) {
      final s = salt[i % salt.length];
      ret.add(calSalt(data[i], s));
    }
    return Uint8List.fromList(ret);
  }

  static Uint8List removeSalt(Uint8List data, Uint8List salt) {
    if (salt.isEmpty) return data;
    final ret = <int>[];
    for (int i = 0; i < data.length; i++) {
      final s = salt[i % salt.length];
      ret.add(calRemoveSalt(data[i], s));
    }
    return Uint8List.fromList(ret);
  }

  static String cxEStr(String data) {
    return cxEStrAsBytes(
      data,
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List cxEStrAsBytes(String data) {
    return cxEd(Uint8List.fromList(utf8.encode(data)));
  }

  static String cxDStr(String data) {
    final bytes = Uint8List.fromList([
      for (int i = 0; i < data.length; i += 2)
        int.parse(data.substring(i, i + 2), radix: 16),
    ]);
    return utf8.decode(cxEd(bytes));
  }

  static String enStr(String data) {
    return enBytesStr(Uint8List.fromList(utf8.encode(data)));
  }

  static String enBytesStr(Uint8List data) {
    final encrypted = en(data);
    return '$EN_STR_TAG${encrypted.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }

  static String deStr(String data) {
    return utf8.decode(deStrBytes(data));
  }

  static Uint8List deStrBytes(String data) {
    if (!data.startsWith(EN_STR_TAG)) {
      throw ArgumentError("Invalid encoded string");
    }
    final hexData = data.substring(1);
    final bytes = Uint8List.fromList([
      for (int i = 0; i < hexData.length; i += 2)
        int.parse(hexData.substring(i, i + 2), radix: 16),
    ]);
    return de(bytes);
  }

  static Future<int> copy(
    Stream<List<int>> reader,
    StreamSink<List<int>> writer,
  ) async {
    int total = 0;
    await for (final chunk in reader) {
      total += chunk.length;
      final encrypted = chunk.map((b) => b ^ 0xFF).toList();
      writer.add(encrypted);
    }
    await writer.close();
    return total;
  }

  static Uint8List cxEd1(Uint8List data) {
    return Uint8List.fromList(
      data.map((b) => (b % 2 == 1) ? (b ^ 0xFF) : b).toList(),
    );
  }
}

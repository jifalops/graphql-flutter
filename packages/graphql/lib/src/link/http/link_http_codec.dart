import 'package:crypto/crypto.dart';
import 'package:utf/utf.dart';

typedef Encoder = List<int> Function(String);
typedef Decoder = String Function(List<int>);

class GqlCodec {
  const GqlCodec._(this._encoder, this._decoder);

  final Encoder _encoder;
  final Decoder _decoder;

  List<int> encode(String string) => _encoder(string);
  String decode(List<int> bytes) => _decoder(bytes);

  /// For cache file names, not secure (uses md5).
  String hash(String string, [int maxLen]) {
    assert(maxLen == null || maxLen > 0);
    final hashed = md5.convert(encode(string)).toString();
    if (maxLen != null && maxLen < hashed.length) {
      return hashed.substring(0, maxLen);
    } else {
      return hashed;
    }
  }

  @override
  String toString() => this == utf16 ? 'utf16' : 'utf8';

  static GqlCodec fromString(String string) => string == 'utf16' ? utf16 : utf8;

  static const utf8 = GqlCodec._(encodeUtf8, decodeUtf8);
  static const utf16 = GqlCodec._(encodeUtf16, decodeUtf16);
}

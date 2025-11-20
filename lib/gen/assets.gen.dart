/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsDbGen {
  const $AssetsDbGen();

  /// File path: assets/db/db_prahse.db
  String get dbPrahse => 'assets/db/db_prahse.db';

  /// File path: assets/db/wordsnew_db.db
  String get wordsnewDb => 'assets/db/wordsnew_db.db';

  /// List of all assets
  List<String> get values => [dbPrahse, wordsnewDb];
}

class Assets {
  const Assets._();

  static const AssetGenImage ai = AssetGenImage('assets/ai.png');
  static const AssetGenImage book2 = AssetGenImage('assets/book-2.png');
  static const AssetGenImage bookSale = AssetGenImage('assets/book-sale.png');
  static const AssetGenImage celebration =
      AssetGenImage('assets/celebration.png');
  static const AssetGenImage daliyQuiz = AssetGenImage('assets/daliy_quiz.png');
  static const $AssetsDbGen db = $AssetsDbGen();
  static const AssetGenImage dictionary2 =
      AssetGenImage('assets/dictionary-2.png');
  static const AssetGenImage dictionary =
      AssetGenImage('assets/dictionary.png');
  static const AssetGenImage magicBook = AssetGenImage('assets/magic-book.png');
  static const AssetGenImage more = AssetGenImage('assets/more.png');
  static const AssetGenImage search11 = AssetGenImage('assets/search11.png');
  static const AssetGenImage statistics =
      AssetGenImage('assets/statistics.png');
  static const AssetGenImage translate = AssetGenImage('assets/translate.png');

  /// List of all assets
  static List<AssetGenImage> get values => [
        ai,
        book2,
        bookSale,
        celebration,
        daliyQuiz,
        dictionary2,
        dictionary,
        magicBook,
        more,
        search11,
        statistics,
        translate
      ];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

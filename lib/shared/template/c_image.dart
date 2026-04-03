import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chord_list_app/shared/constant.dart';
import 'package:chord_list_app/shared/exports.dart';
import 'package:lottie/lottie.dart';

class CImage extends HookWidget {
  const CImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorBlendMode,
    this.color,
    this.alignment = Alignment.center,
  });

  final String? src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    final error = useMemoized(
      () => Image.memory(
        const Base64Codec().decode(EMPTY_IMAGE),
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
      ),
      [],
    );

    final src = this.src?.replaceFirst('https', 'http');

    if (src == null) {
      return error;
    }

    final ext = src.split('.').last;

    return switch (ext) {
      'json' => _Lottie(
        src: src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        alt: error,
      ),
      'svg' => _Svg(
        src: src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        alt: error,
      ),
      _ => _General(
        src: src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode,
        alt: error,
      ),
    };
  }
}

class _Lottie extends StatelessWidget {
  const _Lottie({
    required this.src,
    this.width,
    this.height,
    required this.fit,
    required this.alignment,
    required this.alt,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Widget alt;

  @override
  Widget build(BuildContext context) {
    if (src.startsWith('http')) {
      return Lottie.network(
        src,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => alt,
      );
    }

    return Lottie.asset(
      src,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => alt,
    );
  }
}

class _Svg extends StatelessWidget {
  const _Svg({
    required this.src,
    this.width,
    this.height,
    required this.fit,
    required this.alignment,
    required this.alt,
    required this.color,
    required this.colorBlendMode,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Widget alt;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    final color = this.color;

    if (src.startsWith('http')) {
      return SvgPicture.network(
        src,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcATop),
        alignment: alignment,
      );
    }

    return SvgPicture.asset(
      src,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcATop),
      alignment: alignment,
    );
  }
}

class _General extends StatelessWidget {
  const _General({
    required this.src,
    this.width,
    this.height,
    required this.fit,
    required this.alignment,
    required this.alt,
    required this.color,
    required this.colorBlendMode,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Widget alt;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    if (src.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: src,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        errorWidget: (context, error, stackTrace) => alt,
      );
    }

    return Image.asset(
      src,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) => alt,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter/shared/widgets/safe_image.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('SafeImage resolves start alignment for $direction', (
      tester,
    ) async {
      late CachedNetworkImage image;
      await tester.pumpWidget(
        Directionality(
          textDirection: direction,
          child: Builder(
            builder: (context) {
              image = const SafeImage(
                imageUrl: 'https://example.com/photo.png',
                alignment: AlignmentDirectional.centerStart,
              ).build(context) as CachedNetworkImage;
              // Inspect the adapter without starting an HTTP request.
              return const SizedBox();
            },
          ),
        ),
      );
      expect(
        image.alignment,
        direction == TextDirection.ltr
            ? Alignment.centerLeft
            : Alignment.centerRight,
      );
      expect(image.fadeInDuration, const Duration(milliseconds: 500));
    });
  }
  testWidgets('SafeImage preserves an explicit fade duration', (tester) async {
    late CachedNetworkImage image;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            image = const SafeImage(
              imageUrl: 'https://example.com/photo.png',
              fadeInDuration: Duration.zero,
            ).build(context) as CachedNetworkImage;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(image.fadeInDuration, Duration.zero);
  });
}

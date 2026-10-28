import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/features/home/presentation/pages/home_page.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:flutter_starter/shared/widgets/responsive_scaffold.dart';

Future<GoRouter> mountWorkspace(
  WidgetTester tester, {
  required double width,
  String location = '/home',
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(initialLocation: location, routes: [
    ShellRoute(
      builder: (_, __, child) => ResponsiveScaffold(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        for (final path in ['/dashboard', '/users', '/notifications', '/settings'])
          GoRoute(
            path: path,
            builder: (_, __) => Scaffold(body: Text('Screen: $path')),
          ),
      ],
    ),
  ]);
  addTearDown(router.dispose);
  await tester.pumpWidget(ProviderScope(child: MaterialApp.router(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  )));
  await tester.pumpAndSettle();
  return router;
}

void expectSelection(WidgetTester tester, double width, int index) {
  if (width > 1000) {
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).selectedIndex, index);
  } else {
    expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, index);
  }
  expect(tester.takeException(), isNull);
}

void main() {
  for (final width in [390.0, 1200.0]) {
    testWidgets('Direct notifications route selects its tab at $width', (tester) async {
      await mountWorkspace(tester, width: width, location: '/notifications');
      expect(find.text('Screen: /notifications'), findsOneWidget);
      expectSelection(tester, width, 3);
    });

    testWidgets('Home notification card and navigation stay in sync at $width', (tester) async {
      final router = await mountWorkspace(tester, width: width);
      final card = find.ancestor(
        of: find.descendant(of: find.byType(HomePage), matching: find.byIcon(Icons.notifications_outlined)),
        matching: find.byType(Card),
      );
      final button = find.descendant(
        of: card,
        matching: find.byWidgetPredicate((widget) => widget is FilledButton),
      );
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/notifications');
      expectSelection(tester, width, 3);

      final navigation = find.byType(width > 1000 ? NavigationRail : NavigationBar);
      const paths = ['/home', '/dashboard', '/users', '/notifications', '/settings'];
      const icons = [Icons.home_outlined, Icons.dashboard_outlined, Icons.people_outline, Icons.notifications_outlined, Icons.settings_outlined];
      for (final index in [4, 3, 2, 1, 0]) {
        final label = find.descendant(of: navigation, matching: find.byIcon(icons[index]));
        await tester.tap(label);
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, paths[index]);
        expectSelection(tester, width, index);
      }
    });
  }

  testWidgets('Notifications selection survives switching from phone to desktop and back', (tester) async {
    final router = await mountWorkspace(tester, width: 390, location: '/notifications');
    for (final width in [1200.0, 390.0]) {
      tester.view.physicalSize = Size(width, 844);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/notifications');
      expectSelection(tester, width, 3);
    }
  });
}

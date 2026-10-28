import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/features/auth/data/auth_repository.dart';
import 'package:flutter_starter/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_starter/features/home/presentation/pages/home_page.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';

class _TestAuthRepository extends AuthRepository {
  @override
  Future<void> logout() async {}
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(bool authenticated) : super(_TestAuthRepository()) {
    state = AuthState(isAuthenticated: authenticated);
  }
}

Future<GoRouter> mountHome(
  WidgetTester tester, {
  String language = 'es',
  Size size = const Size(390, 844),
  bool authenticated = false,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  // Destination stubs isolate the home page's navigation contract.
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      for (final path in [
        '/dashboard',
        '/notifications',
        '/settings',
        '/login',
        '/showcase/ui',
        '/forms',
        '/showcase/upload',
        '/showcase/language',
      ])
        GoRoute(
          path: path,
          builder: (_, __) => Scaffold(body: Text('Destination: $path')),
        ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => _TestAuthNotifier(authenticated)),
      ],
      child: MaterialApp.router(
        locale: Locale(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  const greetings = {
    'es': 'Bienvenido a NEXXO',
    'en': 'Welcome to NEXXO',
    'fr': 'Bienvenue dans NEXXO',
  };
  for (final entry in greetings.entries) {
    for (final width in [390.0, 1200.0]) {
      testWidgets('Home renders ${entry.key} at width $width', (tester) async {
        await mountHome(tester, language: entry.key, size: Size(width, 844));
        expect(find.text(entry.value), findsOneWidget);
        expect(find.text('NEXXO'), findsOneWidget);
        expect(find.byWidgetPredicate((widget) => widget is FilledButton), findsNWidgets(3));
        expect(tester.takeException(), isNull);
      });
    }
  }

  final destinations = {
    Icons.dashboard_outlined: '/dashboard',
    Icons.notifications_outlined: '/notifications',
    Icons.tune_outlined: '/settings',
  };
  for (final entry in destinations.entries) {
    testWidgets('Home opens ${entry.value}', (tester) async {
      final router = await mountHome(tester);
      final card = find.ancestor(
        of: find.byIcon(entry.key),
        matching: find.byType(Card),
      );
      final button = find.descendant(
        of: card,
        matching: find.byWidgetPredicate((widget) => widget is FilledButton),
      );
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, entry.value);
      expect(find.text('Destination: ${entry.value}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Guest can open login', (tester) async {
    final router = await mountHome(tester);
    expect(find.byIcon(Icons.logout), findsNothing);
    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/login');
  });

  testWidgets('Logout changes home to guest controls', (tester) async {
    await mountHome(tester, authenticated: true);
    expect(find.byIcon(Icons.login), findsNothing);
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.login), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsNothing);
    expect(tester.takeException(), isNull);
  });

  const toolPaths = [
    '/showcase/ui',
    '/forms',
    '/showcase/upload',
    '/showcase/language',
  ];
  for (var index = 0; index < toolPaths.length; index++) {
    final toolIndex = index;
    final path = toolPaths[index];
    testWidgets('Development tools open $path', (tester) async {
      final router = await mountHome(tester);
      final heading = find.text('Herramientas de prueba');
      await tester.ensureVisible(heading);
      await tester.tap(heading);
      await tester.pumpAndSettle();
      final tile = find.byType(ListTile).at(toolIndex + 1);
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, path);
      expect(tester.takeException(), isNull);
    });
  }
}

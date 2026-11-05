import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../l10n/app_localizations.dart';

/// NEXXO's internal workspace landing page.
///
/// This is intentionally a first functional draft: visual branding and the
/// business-specific modules will be designed after the owner reviews them.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final copy = _HomeCopy.fromLanguage(
      Localizations.localeOf(context).languageCode,
    );
    final authState = ref.watch(authProvider);

    final destinations = [
      _WorkspaceDestination(
        title: l10n.dashboard,
        description: copy.dashboardDescription,
        icon: Icons.dashboard_outlined,
        path: '/dashboard',
      ),
      _WorkspaceDestination(
        title: l10n.notifications,
        description: copy.notificationsDescription,
        icon: Icons.notifications_outlined,
        path: '/notifications',
      ),
      _WorkspaceDestination(
        title: l10n.settings,
        description: copy.settingsDescription,
        icon: Icons.tune_outlined,
        path: '/settings',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEXXO'),
        actions: [
          if (authState.isAuthenticated)
            IconButton(
              tooltip: l10n.logout,
              onPressed: () => ref.read(authProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
            )
          else
            IconButton(
              tooltip: l10n.login,
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    copy.welcome,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    copy.introduction,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    copy.availableScreens,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    copy.demoNotice,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 14.0;
                      final cardWidth = constraints.maxWidth >= 720
                          ? (constraints.maxWidth - spacing) / 2
                          : constraints.maxWidth;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: [
                          for (final destination in destinations)
                            SizedBox(
                              width: cardWidth,
                              child: _WorkspaceCard(
                                destination: destination,
                                openLabel: copy.open,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  Card(
                    child: ExpansionTile(
                      leading: const Icon(Icons.build_outlined),
                      title: Text(copy.starterTools),
                      subtitle: Text(copy.starterToolsDescription),
                      children: [
                        ListTile(
                          title: Text(l10n.uiComponents),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/showcase/ui'),
                        ),
                        ListTile(
                          title: Text(l10n.forms),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/forms'),
                        ),
                        ListTile(
                          title: Text(l10n.fileUpload),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/showcase/upload'),
                        ),
                        ListTile(
                          title: Text(l10n.language),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/showcase/language'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkspaceDestination {
  const _WorkspaceDestination({
    required this.title,
    required this.description,
    required this.icon,
    required this.path,
  });

  final String title;
  final String description;
  final IconData icon;
  final String path;
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({
    required this.destination,
    required this.openLabel,
  });

  final _WorkspaceDestination destination;
  final String openLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(destination.icon, color: colors.primary, size: 32),
            const SizedBox(height: 12),
            Text(
              destination.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              destination.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: () => context.go(destination.path),
                icon: const Icon(Icons.arrow_forward),
                label: Text(openLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCopy {
  const _HomeCopy({
    required this.welcome,
    required this.introduction,
    required this.availableScreens,
    required this.demoNotice,
    required this.dashboardDescription,
    required this.notificationsDescription,
    required this.settingsDescription,
    required this.starterTools,
    required this.starterToolsDescription,
    required this.open,
  });

  final String welcome;
  final String introduction;
  final String availableScreens;
  final String demoNotice;
  final String dashboardDescription;
  final String notificationsDescription;
  final String settingsDescription;
  final String starterTools;
  final String starterToolsDescription;
  final String open;

  static _HomeCopy fromLanguage(String language) {
    switch (language) {
      case 'es':
        return const _HomeCopy(
          welcome: 'Bienvenido a NEXXO',
          introduction:
              'Tu espacio personal de trabajo y creación. '
              'El catálogo comercial público tendrá su propia sección.',
          availableScreens: 'Primeras pantallas',
          demoNotice:
              'Estas herramientas vienen de la base inicial; '
              'todavía no muestran información real del negocio.',
          dashboardDescription: 'Explora el panel incluido en la base.',
          notificationsDescription: 'Consulta la pantalla de avisos.',
          settingsDescription: 'Configura las opciones disponibles.',
          starterTools: 'Herramientas de prueba',
          starterToolsDescription:
              'Componentes de ejemplo para el desarrollo.',
          open: 'Abrir',
        );
      case 'fr':
        return const _HomeCopy(
          welcome: 'Bienvenue dans NEXXO',
          introduction:
              'Votre espace privé de travail et de création. '
              'Le catalogue public sera développé séparément.',
          availableScreens: 'Premiers écrans',
          demoNotice:
              'Ces écrans proviennent du modèle initial ; '
              'ils ne présentent pas encore de données réelles.',
          dashboardDescription: 'Explorer le tableau de bord de base.',
          notificationsDescription: 'Voir les notifications.',
          settingsDescription: 'Configurer les options disponibles.',
          starterTools: 'Outils de démonstration',
          starterToolsDescription: 'Exemples utiles au développement.',
          open: 'Ouvrir',
        );
      default:
        return const _HomeCopy(
          welcome: 'Welcome to NEXXO',
          introduction:
              'Your personal workspace for managing and creating. '
              'The public storefront will be developed separately.',
          availableScreens: 'First screens',
          demoNotice:
              'These screens come from the starter template; '
              'they do not yet contain real business data.',
          dashboardDescription: 'Explore the starter dashboard.',
          notificationsDescription: 'View the notifications screen.',
          settingsDescription: 'Adjust the available settings.',
          starterTools: 'Development examples',
          starterToolsDescription: 'Sample components for building NEXXO.',
          open: 'Open',
        );
    }
  }
}

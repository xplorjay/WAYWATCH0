import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final Map<String, dynamic> _profile = {
    'name': 'John Doe',
    'phone': '+1 555-123-4567',
    'shareCount': 5,
    'circleCount': 2,
  };
  bool _shareEnabled = true, _notifEnabled = true, _autoShare = false;

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _editProfile() {
    final ctrl = TextEditingController(text: _profile['name'] as String);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Display Name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              setState(() => _profile['name'] = ctrl.text.trim());
              Navigator.pop(context);
              _showSnack('Profile updated');
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String profileName = _profile['name'] as String;
    final String profilePhone = _profile['phone'] as String;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                    Theme.of(context)
                        .colorScheme
                        .tertiaryContainer
                        .withOpacity(0.6),
                  ],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          child: Text(
                            profileName.isNotEmpty ? profileName[0] : '',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(profileName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white)),
                        Text(profilePhone,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white70)),
                      ],
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        onPressed: _editProfile,
                        icon: const Icon(Icons.edit_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(children: [
                _statCard('Circles', _profile['circleCount'] as int,
                    Icons.groups_rounded, context),
                const SizedBox(width: 12),
                _statCard('Shared With', _profile['shareCount'] as int,
                    Icons.people_rounded, context),
              ]),
              const SizedBox(height: 24),
              Text('Quick Settings',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _switchTile(Icons.location_on_rounded, 'Location Sharing',
                  'Share your location', _shareEnabled, (v) {
                setState(() => _shareEnabled = v);
                _showSnack(v ? 'Enabled' : 'Disabled');
              }),
              const Divider(),
              _switchTile(Icons.notifications_rounded, 'Notifications',
                  'Receive alerts', _notifEnabled, (v) {
                setState(() => _notifEnabled = v);
              }),
              const Divider(),
              _switchTile(Icons.auto_awesome_rounded, 'Auto-Share',
                  'Auto share new places', _autoShare, (v) {
                setState(() => _autoShare = v);
              }),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.lock_rounded),
                title: const Text('Privacy Settings'),
                onTap: () => _showSnack('Opening Privacy'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.red),
                title:
                    const Text('Sign Out', style: TextStyle(color: Colors.red)),
                onTap: () => _showSnack('Signed Out'),
              ),
            ]),
          ),
        )
      ]),
    );
  }

  Widget _statCard(String title, int value, IconData icon, BuildContext ctx) {
    final color = Theme.of(ctx).colorScheme.primary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text('$value',
              style: Theme.of(ctx)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: color)),
          Text(title,
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.7))),
        ]),
      ),
    );
  }

  Widget _switchTile(IconData icon, String title, String subtitle, bool value,
      ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon),
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}

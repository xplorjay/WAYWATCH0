import 'package:flutter/material.dart';
import 'dart:math';

class CirclesTab extends StatefulWidget {
  const CirclesTab({super.key});

  @override
  State<CirclesTab> createState() => _CirclesTabState();
}

class _CirclesTabState extends State<CirclesTab>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _circles = [
    {
      'id': '1',
      'name': 'Family',
      'members': [
        {'name': 'Sarah Johnson', 'status': 'online', 'role': 'admin'},
        {'name': 'Mike Johnson', 'status': 'away', 'role': 'member'},
      ],
      'color': Colors.blue,
      'icon': Icons.family_restroom,
    },
    {
      'id': '2',
      'name': 'Work Team',
      'members': [
        {'name': 'Emily Chen', 'status': 'online', 'role': 'member'},
      ],
      'color': Colors.green,
      'icon': Icons.work,
    },
  ];

  final List<Map<String, dynamic>> _invites = [
    {
      'circleName': 'College Friends',
      'inviterName': 'Alex Thompson',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showCreateDialog() {
    final ctrl = TextEditingController();
    IconData icon = Icons.group;
    Color color = Colors.blue;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (_, setState) {
        return AlertDialog(
          title: const Text('Create New Circle'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                  labelText: 'Circle Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Icon:'),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.group),
                color: icon == Icons.group ? color : null,
                onPressed: () => setState(() => icon = Icons.group),
              ),
              IconButton(
                icon: Icon(Icons.family_restroom),
                color: icon == Icons.family_restroom ? color : null,
                onPressed: () =>
                    setState(() => icon = Icons.family_restroom),
              ),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Color:'),
              const SizedBox(width: 8),
              ...[Colors.blue, Colors.green, Colors.orange].map((c) {
                return GestureDetector(
                  onTap: () => setState(() => color = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: color == c
                          ? Border.all(width: 2, color: Colors.black)
                          : null,
                    ),
                  ),
                );
              }).toList()
            ]),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = ctrl.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _circles.add({
                      'id': Random().nextInt(10000).toString(),
                      'name': name,
                      'members': [
                        {'name': 'You', 'status': 'online', 'role': 'admin'}
                      ],
                      'color': color,
                      'icon': icon,
                    });
                  });
                  Navigator.pop(context);
                  _showSnack('Circle "$name" created');
                }
              },
              child: const Text('Create'),
            )
          ],
        );
      }),
    );
  }

  void _showInviteSheet(Map<String, dynamic> circle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Invite to ${circle['name']}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: Text('waywatch.app/join/abc123')),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Navigator.pop(context);
                  _showSnack('Link copied');
                },
              )
            ]),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              onPressed: () {
                Navigator.pop(context);
                _showSnack('Invite shared');
              },
            )
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                      Theme.of(context)
                          .colorScheme
                          .tertiaryContainer
                          .withOpacity(0.2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Circles',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text('${_circles.length} active',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.7))),
                        ],
                      ),
                      const Spacer(),
                      IconButton.filled(
                        onPressed: _showCreateDialog,
                        icon: const Icon(Icons.add),
                      )
                    ]),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: Colors.transparent,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  tabs: [
                    const Tab(icon: Icon(Icons.groups), text: 'My Circles'),
                    Tab(
                      icon: const Icon(Icons.mail_outline),
                      text:
                          'Invites${_invites.isNotEmpty ? ' (${_invites.length})' : ''}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Circles List
            _circles.isEmpty
                ? Center(child: Text('No circles yet'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _circles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final c = _circles[i];
                      return ListTile(
                        tileColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        leading: Icon(c['icon'], color: c['color']),
                        title: Text(c['name']),
                        subtitle: Text('${c['members'].length} members'),
                        onTap: () => _showInviteSheet(c),
                      );
                    },
                  ),
            // Invites List
            _invites.isEmpty
                ? Center(child: Text('No pending invites'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _invites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final inv = _invites[i];
                      return ListTile(
                        tileColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        leading: const Icon(Icons.mail_outline),
                        title: Text(
                            '${inv['inviterName']} invited you'),
                        subtitle: Text(
                            'to "${inv['circleName']}" • ${_timeAgo(inv['timestamp'])}'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          TextButton(
                            onPressed: () {
                              setState(() => _invites.removeAt(i));
                              _showSnack('Declined');
                            },
                            child: const Text('Decline'),
                          ),
                          FilledButton(
                            onPressed: () {
                              setState(() => _invites.removeAt(i));
                              _showSnack('Joined');
                            },
                            child: const Text('Accept'),
                          )
                        ]),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

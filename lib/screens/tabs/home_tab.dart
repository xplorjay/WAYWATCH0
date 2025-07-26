import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  final String userName;
  final List<Map<String, dynamic>> contacts;

  const HomeTab({
    super.key,
    required this.userName,
    required this.contacts,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isGhostModeActive = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showGhostModeSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isGhostModeActive
            ? 'Ghost mode activated - You are now hidden'
            : 'Ghost mode deactivated - You are now visible'),
        backgroundColor: _isGhostModeActive ? Colors.orange : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Add to Circle'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share_location),
            title: const Text('Share Location'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing your location')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Show QR Code'),
            onTap: () => Navigator.pop(context),
          ),
        ]),
      ),
    );
  }

  String _getTimeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$greeting,',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                )),
                        Text(widget.userName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          _isGhostModeActive = !_isGhostModeActive;
                        });
                        _showGhostModeSnackbar();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isGhostModeActive
                              ? Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.1)
                              : Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _isGhostModeActive
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: _isGhostModeActive
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Status Card
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  Text('Your Status',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isGhostModeActive
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            if (!_isGhostModeActive)
                              BoxShadow(
                                color: Colors.green
                                    .withOpacity(0.3 * _pulseController.value),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                          ],
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isGhostModeActive
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isGhostModeActive ? 'Hidden' : 'Sharing',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _isGhostModeActive
                                  ? Colors.orange.shade800
                                  : Colors.green.shade800,
                            ),
                          )
                        ]),
                      );
                    },
                  )
                ]),
              ),
              const SizedBox(height: 24),
              // Map Placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Stack(children: [
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: _GridPainter(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.1),
                    ),
                  ),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Interactive map\ncoming soon',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
              // People Section
              Text('Your Circle',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (widget.contacts.isEmpty)
                _emptyCircleCard()
              else
                for (var c in widget.contacts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _contactCard(c),
                  ),
            ]),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _emptyCircleCard() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Column(children: [
          Icon(Icons.people_outline,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('Your circle is empty',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Add family and friends to share locations',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.7))),
        ]),
      );

  Widget _contactCard(Map<String, dynamic> c) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 20,
            child: Text(c['name'][0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c['name'], style: Theme.of(context).textTheme.bodyLarge),
              Text(
                  c['status'] == 'online'
                      ? 'Active now'
                      : 'Last seen ${_getTimeAgo(c['lastSeen'])}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6))),
            ]),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c['status'] == 'online' ? Colors.green : Colors.orange),
          ),
        ]),
      );
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

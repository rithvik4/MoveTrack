import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';

class MoveTrackApp extends ConsumerWidget {
  const MoveTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MoveTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<AuthGate>(builder: (_) => const AuthGate()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colors.primary, colors.secondary],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_run,
                          size: 92,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'MoveTrack',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Train better. Track smarter.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.goalKm,
    required this.heightCm,
    required this.weightKg,
  });

  final String name;
  final double goalKm;
  final int heightCm;
  final int weightKg;

  UserProfile copyWith({
    String? name,
    double? goalKm,
    int? heightCm,
    int? weightKg,
  }) {
    return UserProfile(
      name: name ?? this.name,
      goalKm: goalKm ?? this.goalKm,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}

class ActivityRecord {
  const ActivityRecord({
    required this.title,
    required this.distanceKm,
    required this.duration,
    required this.date,
  });

  final String title;
  final double distanceKm;
  final Duration duration;
  final DateTime date;
}

class ChallengeItem {
  const ChallengeItem({
    required this.id,
    required this.title,
    required this.targetKm,
    required this.progressKm,
  });

  final int id;
  final String title;
  final double targetKm;
  final double progressKm;

  ChallengeItem copyWith({double? progressKm}) {
    return ChallengeItem(
      id: id,
      title: title,
      targetKm: targetKm,
      progressKm: progressKm ?? this.progressKm,
    );
  }

  double get progressRatio => (progressKm / targetKm).clamp(0.0, 1.0);
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.weekKm,
  });

  final int rank;
  final String name;
  final double weekKm;
}

class AppState {
  const AppState({
    required this.loggedIn,
    required this.profile,
    required this.stepCount,
    required this.activeMinutes,
    required this.calories,
    required this.todayDistanceKm,
    required this.totalDistanceKm,
    required this.currentStreak,
    required this.notificationsEnabled,
    required this.activities,
    required this.challenges,
    required this.leaderboard,
    required this.notifications,
    required this.runningSession,
    required this.sessionSeconds,
  });

  final bool loggedIn;
  final UserProfile profile;
  final int stepCount;
  final int activeMinutes;
  final int calories;
  final double todayDistanceKm;
  final double totalDistanceKm;
  final int currentStreak;
  final bool notificationsEnabled;
  final List<ActivityRecord> activities;
  final List<ChallengeItem> challenges;
  final List<LeaderboardEntry> leaderboard;
  final List<String> notifications;
  final bool runningSession;
  final int sessionSeconds;

  static AppState initial() {
    return AppState(
      loggedIn: false,
      profile: const UserProfile(
        name: 'Rithvik Runner',
        goalKm: 8.0,
        heightCm: 174,
        weightKg: 68,
      ),
      stepCount: 8420,
      activeMinutes: 64,
      calories: 513,
      todayDistanceKm: 5.2,
      totalDistanceKm: 312.4,
      currentStreak: 12,
      notificationsEnabled: true,
      activities: <ActivityRecord>[
        ActivityRecord(
          title: 'Morning Run',
          distanceKm: 5.2,
          duration: const Duration(minutes: 29),
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ActivityRecord(
          title: 'Recovery Walk',
          distanceKm: 2.1,
          duration: const Duration(minutes: 22),
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ActivityRecord(
          title: 'Tempo Run',
          distanceKm: 7.4,
          duration: const Duration(minutes: 42),
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      challenges: const <ChallengeItem>[
        ChallengeItem(id: 1, title: 'June 50K', targetKm: 50, progressKm: 31),
        ChallengeItem(id: 2, title: '7-Day Streak', targetKm: 21, progressKm: 14.5),
        ChallengeItem(id: 3, title: 'City Sprint', targetKm: 30, progressKm: 7),
      ],
      leaderboard: const <LeaderboardEntry>[
        LeaderboardEntry(rank: 1, name: 'Ava', weekKm: 41.2),
        LeaderboardEntry(rank: 2, name: 'Liam', weekKm: 37.9),
        LeaderboardEntry(rank: 3, name: 'Rithvik Runner', weekKm: 34.6),
        LeaderboardEntry(rank: 4, name: 'Noah', weekKm: 30.1),
      ],
      notifications: const <String>[
        'Challenge unlocked: June 50K is waiting for you.',
        'You are 2.8 km away from today\'s goal.',
        'Weekly leaderboard updated. You are currently #3.',
      ],
      runningSession: false,
      sessionSeconds: 0,
    );
  }

  AppState copyWith({
    bool? loggedIn,
    UserProfile? profile,
    int? stepCount,
    int? activeMinutes,
    int? calories,
    double? todayDistanceKm,
    double? totalDistanceKm,
    int? currentStreak,
    bool? notificationsEnabled,
    List<ActivityRecord>? activities,
    List<ChallengeItem>? challenges,
    List<LeaderboardEntry>? leaderboard,
    List<String>? notifications,
    bool? runningSession,
    int? sessionSeconds,
  }) {
    return AppState(
      loggedIn: loggedIn ?? this.loggedIn,
      profile: profile ?? this.profile,
      stepCount: stepCount ?? this.stepCount,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      calories: calories ?? this.calories,
      todayDistanceKm: todayDistanceKm ?? this.todayDistanceKm,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      currentStreak: currentStreak ?? this.currentStreak,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      activities: activities ?? this.activities,
      challenges: challenges ?? this.challenges,
      leaderboard: leaderboard ?? this.leaderboard,
      notifications: notifications ?? this.notifications,
      runningSession: runningSession ?? this.runningSession,
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  final Random _random = Random();

  void signIn(String name) {
    final String displayName = name.trim().isEmpty ? 'Runner' : name.trim();
    state = state.copyWith(
      loggedIn: true,
      profile: state.profile.copyWith(name: displayName),
      notifications: <String>[
        'Welcome $displayName! Let\'s move.',
        ...state.notifications,
      ],
    );
  }

  void signOut() {
    state = AppState.initial();
  }

  void updateProfile({
    required String name,
    required double goalKm,
    required int heightCm,
    required int weightKg,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        name: name,
        goalKm: goalKm,
        heightCm: heightCm,
        weightKg: weightKg,
      ),
    );
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void startSession() {
    if (state.runningSession) {
      return;
    }
    state = state.copyWith(runningSession: true, sessionSeconds: 0);
  }

  void stopSession() {
    if (!state.runningSession) {
      return;
    }

    final double sessionKm = (state.sessionSeconds / 300).clamp(0.2, 4.5).toDouble();
    final Duration duration = Duration(seconds: state.sessionSeconds);

    final ActivityRecord newActivity = ActivityRecord(
      title: 'Live Session',
      distanceKm: double.parse(sessionKm.toStringAsFixed(1)),
      duration: duration,
      date: DateTime.now(),
    );

    final List<ChallengeItem> updatedChallenges = state.challenges
        .map((ChallengeItem challenge) => challenge.copyWith(
              progressKm: min<double>(
                challenge.targetKm,
                challenge.progressKm + sessionKm,
              ),
            ))
        .toList(growable: false);

    state = state.copyWith(
      runningSession: false,
      sessionSeconds: 0,
      todayDistanceKm: state.todayDistanceKm + sessionKm,
      totalDistanceKm: state.totalDistanceKm + sessionKm,
      activeMinutes: state.activeMinutes + max<int>(1, duration.inMinutes),
      calories: state.calories + (sessionKm * 62).toInt(),
      stepCount: state.stepCount + (sessionKm * 1300).toInt(),
      activities: <ActivityRecord>[newActivity, ...state.activities],
      challenges: updatedChallenges,
      notifications: <String>[
        'Session complete: ${sessionKm.toStringAsFixed(1)} km added.',
        ...state.notifications,
      ],
    );
  }

  void tickSession() {
    if (!state.runningSession) {
      return;
    }

    final int nextSeconds = state.sessionSeconds + 1;
    state = state.copyWith(sessionSeconds: nextSeconds);

    if (nextSeconds % 30 == 0) {
      final double distanceDelta = 0.08 + (_random.nextDouble() * 0.04);
      state = state.copyWith(
        todayDistanceKm: state.todayDistanceKm + distanceDelta,
        totalDistanceKm: state.totalDistanceKm + distanceDelta,
        stepCount: state.stepCount + 110,
        calories: state.calories + 3,
      );
    }
  }

  void joinChallenge(int id) {
    final List<ChallengeItem> updated = state.challenges
        .map((ChallengeItem item) => item.id == id
            ? item.copyWith(progressKm: min<double>(item.targetKm, item.progressKm + 1.0))
            : item)
        .toList(growable: false);

    state = state.copyWith(
      challenges: updated,
      notifications: <String>[
        'Challenge joined. Keep the pace!',
        ...state.notifications,
      ],
    );
  }

  void clearNotifications() {
    state = state.copyWith(notifications: const <String>[]);
  }

  void refreshLeaderboard() {
    final List<LeaderboardEntry> shuffled = List<LeaderboardEntry>.from(state.leaderboard)
      ..sort((LeaderboardEntry a, LeaderboardEntry b) =>
          (b.weekKm + _random.nextDouble()).compareTo(a.weekKm + _random.nextDouble()));

    final List<LeaderboardEntry> updated = shuffled
        .asMap()
        .entries
        .map((MapEntry<int, LeaderboardEntry> entry) => LeaderboardEntry(
              rank: entry.key + 1,
              name: entry.value.name,
              weekKm:
                  double.parse((entry.value.weekKm + _random.nextDouble()).toStringAsFixed(1)),
            ))
        .toList(growable: false);

    state = state.copyWith(leaderboard: updated);
  }
}

final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((StateNotifierProviderRef<AppStateNotifier, AppState> ref) {
  return AppStateNotifier();
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool loggedIn = ref.watch(appStateProvider.select((AppState s) => s.loggedIn));
    return loggedIn ? const MainShell() : const SignInScreen();
  }
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Rithvik Runner';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.primary.withValues(alpha: 0.9),
              colorScheme.secondary.withValues(alpha: 0.75),
              colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Welcome to MoveTrack',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to start tracking activities and challenges.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref
                              .read(appStateProvider.notifier)
                              .signIn(_nameController.text);
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const DashboardTab(),
      const ActivityTab(),
      const ChallengesTab(),
      const LeaderboardTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int value) => setState(() => _currentIndex = value),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run_rounded), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.flag_rounded), label: 'Challenges'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard_rounded), label: 'Ranks'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);
    final double progress = (state.todayDistanceKm / state.profile.goalKm).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<NotificationsScreen>(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _HeroProgressCard(
            name: state.profile.name,
            todayDistanceKm: state.todayDistanceKm,
            goalKm: state.profile.goalKm,
            progress: progress,
            streak: state.currentStreak,
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: _MetricCard(
                  label: 'Steps',
                  value: '${state.stepCount}',
                  icon: Icons.straighten_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Calories',
                  value: '${state.calories}',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Active Min',
                  value: '${state.activeMinutes}',
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Recent Activities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ...state.activities
              .take(3)
              .map((ActivityRecord activity) => _ActivityTile(activity: activity)),
        ],
      ),
    );
  }
}

class ActivityTab extends ConsumerStatefulWidget {
  const ActivityTab({super.key});

  @override
  ConsumerState<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends ConsumerState<ActivityTab> {
  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  void _startTicker() {
    Future<void>.delayed(const Duration(seconds: 1), _tickLoop);
  }

  void _tickLoop() {
    if (!mounted) {
      return;
    }

    ref.read(appStateProvider.notifier).tickSession();
    Future<void>.delayed(const Duration(seconds: 1), _tickLoop);
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = ref.watch(appStateProvider);
    final AppStateNotifier notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Activity Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state.runningSession ? 'Session in progress' : 'Session ready',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${_formatDuration(Duration(seconds: state.sessionSeconds))}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: state.runningSession
                                ? null
                                : () => notifier.startSession(),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Start'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: state.runningSession
                                ? () => notifier.stopSession()
                                : null,
                            icon: const Icon(Icons.stop_rounded),
                            label: const Text('Stop & Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Saved Activities', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: state.activities.length,
                itemBuilder: (BuildContext context, int index) {
                  return _ActivityTile(activity: state.activities[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengesTab extends ConsumerWidget {
  const ChallengesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);
    final AppStateNotifier notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: state.challenges.map((ChallengeItem challenge) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    challenge.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${challenge.progressKm.toStringAsFixed(1)} / ${challenge.targetKm.toStringAsFixed(1)} km',
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: challenge.progressRatio),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.tonalIcon(
                      onPressed: () => notifier.joinChallenge(challenge.id),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add 1 km'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class LeaderboardTab extends ConsumerWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: <Widget>[
          IconButton(
            onPressed: () => ref.read(appStateProvider.notifier).refreshLeaderboard(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.leaderboard.length,
        itemBuilder: (BuildContext context, int index) {
          final LeaderboardEntry entry = state.leaderboard[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${entry.rank}')),
              title: Text(entry.name),
              subtitle: Text('${entry.weekKm.toStringAsFixed(1)} km this week'),
              trailing: entry.rank <= 3
                  ? const Icon(Icons.emoji_events_rounded, color: Colors.amber)
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  late final TextEditingController _nameController;
  late final TextEditingController _goalController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final UserProfile profile = ref.read(appStateProvider).profile;
    _nameController = TextEditingController(text: profile.name);
    _goalController = TextEditingController(text: profile.goalKm.toString());
    _heightController = TextEditingController(text: profile.heightCm.toString());
    _weightController = TextEditingController(text: profile.weightKg.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = ref.watch(appStateProvider);
    final AppStateNotifier notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  const CircleAvatar(radius: 34, child: Icon(Icons.person_rounded)),
                  const SizedBox(height: 8),
                  Text(
                    state.profile.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Total distance: ${state.totalDistanceKm.toStringAsFixed(1)} km'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _goalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Daily goal (km)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: state.notificationsEnabled,
            onChanged: notifier.toggleNotifications,
            title: const Text('Enable Notifications'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              notifier.updateProfile(
                name: _nameController.text.trim().isEmpty
                    ? state.profile.name
                    : _nameController.text.trim(),
                goalKm:
                    double.tryParse(_goalController.text.trim()) ?? state.profile.goalKm,
                heightCm: int.tryParse(_heightController.text.trim()) ??
                    state.profile.heightCm,
                weightKg: int.tryParse(_weightController.text.trim()) ??
                    state.profile.weightKg,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated')),
              );
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Profile'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: notifier.signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> notifications =
        ref.watch(appStateProvider.select((AppState s) => s.notifications));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          TextButton(
            onPressed: () => ref.read(appStateProvider.notifier).clearNotifications(),
            child: const Text('Clear'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) => ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: Text(notifications[index]),
              ),
            ),
    );
  }
}

class _HeroProgressCard extends StatelessWidget {
  const _HeroProgressCard({
    required this.name,
    required this.todayDistanceKm,
    required this.goalKm,
    required this.progress,
    required this.streak,
  });

  final String name;
  final double todayDistanceKm;
  final double goalKm;
  final double progress;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hey $name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${todayDistanceKm.toStringAsFixed(1)} / ${goalKm.toStringAsFixed(1)} km today',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            '$streak day streak',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final ActivityRecord activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.directions_run_rounded)),
        title: Text(activity.title),
        subtitle: Text(
          '${activity.distanceKm.toStringAsFixed(1)} km • ${_formatDuration(activity.duration)}',
        ),
        trailing: Text(
          '${activity.date.month}/${activity.date.day}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final int h = duration.inHours;
  final int m = duration.inMinutes % 60;
  final int s = duration.inSeconds % 60;

  if (h > 0) {
    return '${h}h ${m}m';
  }

  if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m ${s.toString().padLeft(2, '0')}s';
  }

  return '${duration.inSeconds}s';
}

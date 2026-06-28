import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'core/theme/app_theme.dart';

const String _apiBaseUrl = String.fromEnvironment(
  'MOVETRACK_API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000/api/v1',
);
const String _apiAuthToken = String.fromEnvironment(
  'MOVETRACK_API_TOKEN',
  defaultValue: '',
);

class MoveTrackApp extends ConsumerWidget {
  const MoveTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MoveTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
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
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fade = Tween<double>(begin: 0.1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<AuthGate>(builder: (_) => const AuthGate()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
            colors: <Color>[
              colors.primary,
              colors.secondary,
              const Color(0xFF5A0A3A),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _logoScale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.directions_run_rounded,
                      color: Colors.white,
                      size: 58,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'MoveTrack',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Move, Compete, Belong',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
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
    required this.followers,
    required this.following,
    required this.posts,
  });

  final String name;
  final double goalKm;
  final int heightCm;
  final int weightKg;
  final int followers;
  final int following;
  final int posts;

  UserProfile copyWith({
    String? name,
    double? goalKm,
    int? heightCm,
    int? weightKg,
    int? followers,
    int? following,
    int? posts,
  }) {
    return UserProfile(
      name: name ?? this.name,
      goalKm: goalKm ?? this.goalKm,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
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
    required this.dateText,
    required this.category,
  });

  final int id;
  final String title;
  final double targetKm;
  final double progressKm;
  final String dateText;
  final String category;

  ChallengeItem copyWith({double? progressKm}) {
    return ChallengeItem(
      id: id,
      title: title,
      targetKm: targetKm,
      progressKm: progressKm ?? this.progressKm,
      dateText: dateText,
      category: category,
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

class ClubItem {
  const ClubItem({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.accent,
    this.joined = false,
  });

  final int id;
  final String name;
  final int memberCount;
  final Color accent;
  final bool joined;

  ClubItem copyWith({bool? joined}) {
    return ClubItem(
      id: id,
      name: name,
      memberCount: memberCount,
      accent: accent,
      joined: joined ?? this.joined,
    );
  }
}

class MoveTrackApiService {
  const MoveTrackApiService({http.Client? client}) : _client = client;

  final http.Client? _client;

  http.Client get _http => _client ?? http.Client();

  Future<List<ChallengeItem>> fetchChallenges() async {
    final Uri uri = Uri.parse('$_apiBaseUrl/challenges');
    final http.Response response = await _http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch challenges (${response.statusCode})');
    }

    final dynamic decoded = jsonDecode(response.body);
    final List<dynamic> rows = (decoded is Map<String, dynamic> && decoded['data'] is List)
        ? decoded['data'] as List<dynamic>
        : <dynamic>[];

    return rows
        .map((dynamic row) => _challengeFromRow(row as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<ChallengeItem>> fetchEventsAsChallenges() async {
    final Uri uri = Uri.parse('$_apiBaseUrl/events');
    final http.Response response = await _http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch events (${response.statusCode})');
    }

    final dynamic decoded = jsonDecode(response.body);
    final List<dynamic> rows = (decoded is Map<String, dynamic> && decoded['data'] is List)
        ? decoded['data'] as List<dynamic>
        : <dynamic>[];

    return rows
        .map((dynamic row) => _challengeFromEventRow(row as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<UserProfile?> fetchMyProfile(String token) async {
    if (token.trim().isEmpty) {
      return null;
    }

    final Uri uri = Uri.parse('$_apiBaseUrl/profile/me');
    final http.Response response = await _http.get(
      uri,
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return null;
    }

    final dynamic decoded = jsonDecode(response.body);
    final Map<String, dynamic>? data =
        decoded is Map<String, dynamic> ? decoded['data'] as Map<String, dynamic>? : null;
    if (data == null) {
      return null;
    }

    return UserProfile(
      name: (data['full_name'] as String?) ?? (data['username'] as String?) ?? 'Runner',
      goalKm: 8,
      heightCm: (data['height'] as num?)?.toInt() ?? 170,
      weightKg: (data['weight'] as num?)?.toInt() ?? 70,
      followers: 0,
      following: 0,
      posts: 0,
    );
  }

  ChallengeItem _challengeFromRow(Map<String, dynamic> row) {
    final num target = (row['target_value'] as num?) ?? 30;
    final num progress = (row['current_value'] as num?) ?? 0;
    final String title = (row['title'] as String?)?.trim().isNotEmpty == true
        ? row['title'] as String
        : 'Challenge';

    final String unit = (row['target_unit'] as String?) ?? 'km';
    final String category = (row['category'] as String?) ?? (row['type'] as String?) ?? 'General';

    return ChallengeItem(
      id: _stableIntId(row['id']),
      title: title,
      targetKm: target.toDouble(),
      progressKm: progress.toDouble(),
      dateText: _shortDateRange(row['start_date'], row['end_date']),
      category: '$category • ${target.toStringAsFixed(0)} $unit',
    );
  }

  ChallengeItem _challengeFromEventRow(Map<String, dynamic> row) {
    final String title = (row['title'] as String?)?.trim().isNotEmpty == true
        ? row['title'] as String
        : 'Event';
    final String type = (row['type'] as String?) ?? 'Activity';
    final String category = (row['category'] as String?) ?? type;
    return ChallengeItem(
      id: _stableIntId(row['id']),
      title: title,
      targetKm: 50,
      progressKm: 0,
      dateText: _shortDateRange(row['start_date'], row['end_date']),
      category: '$category • $type',
    );
  }

  int _stableIntId(dynamic source) {
    final String raw = (source ?? '').toString();
    return int.tryParse(raw) ?? raw.hashCode.abs();
  }

  String _shortDateRange(dynamic start, dynamic end) {
    final DateTime? s = DateTime.tryParse((start ?? '').toString());
    final DateTime? e = DateTime.tryParse((end ?? '').toString());
    if (s == null || e == null) {
      return 'Upcoming';
    }
    return '${s.day.toString().padLeft(2, '0')} ${_month(s.month)} - ${e.day.toString().padLeft(2, '0')} ${_month(e.month)}';
  }

  String _month(int m) {
    const List<String> shortMonths = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return shortMonths[m.clamp(1, 12) - 1];
  }
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
    required this.activeActivity,
    required this.joinedChallenges,
    required this.clubs,
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
  final String activeActivity;
  final Set<int> joinedChallenges;
  final List<ClubItem> clubs;

  static AppState initial() {
    return AppState(
      loggedIn: false,
      profile: const UserProfile(
        name: 'Rithvik Kumar',
        goalKm: 8.0,
        heightCm: 174,
        weightKg: 68,
        followers: 0,
        following: 0,
        posts: 0,
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
          title: 'Lake Run',
          distanceKm: 5.2,
          duration: const Duration(minutes: 29),
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ActivityRecord(
          title: 'City Ride',
          distanceKm: 12.1,
          duration: const Duration(minutes: 41),
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ActivityRecord(
          title: 'Recovery Walk',
          distanceKm: 2.1,
          duration: const Duration(minutes: 22),
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      challenges: const <ChallengeItem>[
        ChallengeItem(
          id: 1,
          title: 'Green Summer Challenge',
          targetKm: 40,
          progressKm: 22,
          dateText: '25 Jun - 02 Jul 2026',
          category: 'Ride 40 km',
        ),
        ChallengeItem(
          id: 2,
          title: 'Monsoon Virtual Challenge',
          targetKm: 60,
          progressKm: 31,
          dateText: '03 Jul - 16 Jul 2026',
          category: 'Walk, Run, Cycle',
        ),
        ChallengeItem(
          id: 3,
          title: 'Apex2026 Series',
          targetKm: 80,
          progressKm: 47,
          dateText: 'All Season',
          category: 'Series Progress',
        ),
      ],
      leaderboard: const <LeaderboardEntry>[
        LeaderboardEntry(rank: 1, name: 'Ava', weekKm: 41.2),
        LeaderboardEntry(rank: 2, name: 'Liam', weekKm: 37.9),
        LeaderboardEntry(rank: 3, name: 'Rithvik Kumar', weekKm: 34.6),
        LeaderboardEntry(rank: 4, name: 'Noah', weekKm: 30.1),
      ],
      notifications: const <String>[
        'Challenge joined: Green Summer Challenge.',
        'You are 2.8 km away from today\'s goal.',
        'Weekly leaderboard updated. You are currently #3.',
      ],
      runningSession: false,
      sessionSeconds: 0,
      activeActivity: 'Walking',
      joinedChallenges: const <int>{1},
      clubs: const <ClubItem>[
        ClubItem(
          id: 1,
          name: 'Crew Fit Club',
          memberCount: 2890,
          accent: Color(0xFFC41C4D),
          joined: true,
        ),
        ClubItem(
          id: 2,
          name: 'Mountain Club',
          memberCount: 1170,
          accent: Color(0xFF2E86DE),
        ),
        ClubItem(
          id: 3,
          name: 'Canal Riders',
          memberCount: 930,
          accent: Color(0xFF16A085),
        ),
        ClubItem(
          id: 4,
          name: 'One More Mile',
          memberCount: 780,
          accent: Color(0xFF8E44AD),
        ),
      ],
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
    String? activeActivity,
    Set<int>? joinedChallenges,
    List<ClubItem>? clubs,
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
      activeActivity: activeActivity ?? this.activeActivity,
      joinedChallenges: joinedChallenges ?? this.joinedChallenges,
      clubs: clubs ?? this.clubs,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  final Random _random = Random();
  final MoveTrackApiService _api = const MoveTrackApiService();

  Future<void> syncPublicData() async {
    try {
      final List<ChallengeItem> challenges = await _api.fetchChallenges();
      final List<ChallengeItem> events = await _api.fetchEventsAsChallenges();
      final UserProfile? profile = await _api.fetchMyProfile(_apiAuthToken);
      final Map<int, ChallengeItem> merged = <int, ChallengeItem>{
        for (final ChallengeItem item in <ChallengeItem>[...challenges, ...events]) item.id: item,
      };

      if (merged.isEmpty) {
        return;
      }

      final List<ChallengeItem> live = merged.values.toList(growable: false);
      state = state.copyWith(
        challenges: live,
        profile: profile ?? state.profile,
        notifications: <String>[
          'Live data synced from backend.',
          ...state.notifications,
        ],
      );
    } catch (_) {
      // Keep local seeded content when API is unavailable.
    }
  }

  void signIn(String name) {
    final String displayName = name.trim().isEmpty ? 'Runner' : name.trim();
    state = state.copyWith(
      loggedIn: true,
      profile: state.profile.copyWith(name: displayName),
      notifications: <String>['Welcome $displayName. Let\'s move!', ...state.notifications],
    );

    unawaited(syncPublicData());
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

  void setActivityType(String value) {
    state = state.copyWith(activeActivity: value);
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

    final double sessionKm =
        (state.sessionSeconds / 300).clamp(0.2, 4.5).toDouble();
    final Duration duration = Duration(seconds: state.sessionSeconds);

    final ActivityRecord newActivity = ActivityRecord(
      title: '${state.activeActivity} Session',
      distanceKm: double.parse(sessionKm.toStringAsFixed(1)),
      duration: duration,
      date: DateTime.now(),
    );

    final List<ChallengeItem> updatedChallenges = state.challenges
        .map(
          (ChallengeItem challenge) => challenge.copyWith(
            progressKm: min<double>(
              challenge.targetKm,
              challenge.progressKm + sessionKm,
            ),
          ),
        )
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
    final Set<int> joined = Set<int>.of(state.joinedChallenges)..add(id);

    final List<ChallengeItem> updated = state.challenges
        .map(
          (ChallengeItem item) => item.id == id
              ? item.copyWith(
                  progressKm: min<double>(item.targetKm, item.progressKm + 1),
                )
              : item,
        )
        .toList(growable: false);

    state = state.copyWith(
      challenges: updated,
      joinedChallenges: joined,
      notifications: <String>['Challenge joined. Keep the pace!', ...state.notifications],
    );
  }

  void toggleClub(int id) {
    final List<ClubItem> updated = state.clubs
        .map(
          (ClubItem item) =>
              item.id == id ? item.copyWith(joined: !item.joined) : item,
        )
        .toList(growable: false);
    state = state.copyWith(clubs: updated);
  }

  void clearNotifications() {
    state = state.copyWith(notifications: const <String>[]);
  }

  void refreshLeaderboard() {
    final List<LeaderboardEntry> shuffled =
        List<LeaderboardEntry>.from(state.leaderboard)
          ..sort(
            (LeaderboardEntry a, LeaderboardEntry b) =>
                (b.weekKm + _random.nextDouble())
                    .compareTo(a.weekKm + _random.nextDouble()),
          );

    final List<LeaderboardEntry> updated = shuffled
        .asMap()
        .entries
        .map(
          (MapEntry<int, LeaderboardEntry> entry) => LeaderboardEntry(
            rank: entry.key + 1,
            name: entry.value.name,
            weekKm: double.parse(
              (entry.value.weekKm + _random.nextDouble()).toStringAsFixed(1),
            ),
          ),
        )
        .toList(growable: false);

    state = state.copyWith(leaderboard: updated);
  }
}

final StateNotifierProvider<AppStateNotifier, AppState> appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>(
  (StateNotifierProviderRef<AppStateNotifier, AppState> ref) {
    return AppStateNotifier();
  },
);

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool loggedIn = ref.watch(
      appStateProvider.select((AppState s) => s.loggedIn),
    );
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
    _nameController.text = 'Rithvik Kumar';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  colors.primary,
                  const Color(0xFFA4164B),
                  const Color(0xFFF4F6F9),
                ],
                stops: const <double>[0, 0.45, 1],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue your streak and events.',
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(appStateProvider.notifier)
                                .signIn(_nameController.text);
                          },
                          child: const Text('Enter MoveTrack'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(appStateProvider.notifier).syncPublicData());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const HomeTab(),
      const GiftsTab(),
      const RecordTab(),
      const EventsTab(),
      const ClubTab(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.03, 0), end: Offset.zero)
                  .animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.09),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int value) {
              setState(() => _currentIndex = value);
            },
            indicatorColor: const Color(0xFFEFEFF3),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const <NavigationDestination>[
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.card_giftcard_rounded), label: 'Gifts'),
              NavigationDestination(icon: Icon(Icons.radio_button_checked), label: 'Record'),
              NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Event'),
              NavigationDestination(icon: Icon(Icons.groups_2_outlined), label: 'Club'),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);
    final ChallengeItem fallbackChallenge = const ChallengeItem(
      id: 0,
      title: 'No Active Challenge Yet',
      targetKm: 1,
      progressKm: 0,
      dateText: 'Upcoming',
      category: 'Stay tuned',
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: <Widget>[
            _HomeHeader(name: state.profile.name),
            const SizedBox(height: 14),
            const _PromoBanner(),
            const SizedBox(height: 14),
            _QuickLinksRow(
              onTapProfile: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Hot Deals, Hot Savings',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1),
            ),
            const SizedBox(height: 3),
            const Text(
              'Curated offers for your next ride',
              style: TextStyle(color: Color(0xFF707582), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const _DealsScroller(),
            const SizedBox(height: 16),
            _ActivitySnippet(state: state),
            const SizedBox(height: 16),
            _ChallengeSpotlight(
              challenge: state.challenges.isEmpty
                  ? fallbackChallenge
                  : state.challenges.first,
            ),
          ],
        ),
      ),
    );
  }
}

class GiftsTab extends ConsumerWidget {
  const GiftsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CrewShop')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: <Widget>[
          const _GiftWalletCard(),
          const SizedBox(height: 14),
          const Text(
            'Reward Drops',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _RewardCard(title: '10% Off Shoes', cost: 230),
              _RewardCard(title: 'Energy Gel Pack', cost: 120),
              _RewardCard(title: 'Cycling Gloves', cost: 180),
              _RewardCard(title: 'Water Bottle', cost: 95),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Recent Rewards Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          ...state.activities.take(3).map(
                (ActivityRecord activity) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.redeem_rounded),
                    title: Text(activity.title),
                    subtitle: Text(
                      '${activity.distanceKm.toStringAsFixed(1)} km completed',
                    ),
                    trailing: Text('+${(activity.distanceKm * 8).toInt()} pts'),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class RecordTab extends ConsumerStatefulWidget {
  const RecordTab({super.key});

  @override
  ConsumerState<RecordTab> createState() => _RecordTabState();
}

class _RecordTabState extends ConsumerState<RecordTab> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      ref.read(appStateProvider.notifier).tickSession();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = ref.watch(appStateProvider);
    final AppStateNotifier notifier = ref.read(appStateProvider.notifier);
    final Duration duration = Duration(seconds: state.sessionSeconds);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Record',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 36),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFFE4E8EE), Color(0xFFD7DCE6)],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.map_outlined,
                        size: 120,
                        color: Color(0xFFBAC2CF),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 22,
                    right: 26,
                    child: _ActivityTypeChip(
                      selected: state.activeActivity,
                      onChange: notifier.setActivityType,
                    ),
                  ),
                  Positioned(
                    left: 22,
                    bottom: 22,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFFD9DCE3)),
                      ),
                      child: const Icon(Icons.my_location_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    '${state.todayDistanceKm.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      color: Color(0xFFC41C4D),
                      fontWeight: FontWeight.w900,
                      fontSize: 44,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _StatBlock(
                        title: 'Duration',
                        value: _hms(duration),
                        align: CrossAxisAlignment.start,
                      ),
                      InkWell(
                        onTap: state.runningSession
                            ? notifier.stopSession
                            : notifier.startSession,
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFC41C4D),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFFC41C4D)
                                    .withValues(alpha: 0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            state.runningSession
                                ? Icons.stop_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      _StatBlock(
                        title: 'Speed',
                        value:
                            '${(state.todayDistanceKm / max(1, duration.inMinutes) * 60).toStringAsFixed(1)}',
                        suffix: 'km/h',
                        align: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);
    final AppStateNotifier notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.perm_contact_calendar_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.syncPublicData,
        child: state.challenges.isEmpty
            ? ListView(
                children: const <Widget>[
                  SizedBox(height: 140),
                  Center(child: Text('No live events right now. Pull to refresh.')),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                itemBuilder: (BuildContext context, int index) {
                  final ChallengeItem challenge = state.challenges[index];
                  final bool joined = state.joinedChallenges.contains(challenge.id);

                  return _EventCard(
                    challenge: challenge,
                    joined: joined,
                    onPressed: () => notifier.joinChallenge(challenge.id),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemCount: state.challenges.length,
              ),
      ),
    );
  }
}

class ClubTab extends ConsumerWidget {
  const ClubTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppState state = ref.watch(appStateProvider);
    final AppStateNotifier notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Club'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Color(0xFFF2F3F7),
              child: Icon(Icons.groups_rounded, color: Color(0xFFC41C4D)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
            itemCount: state.clubs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (BuildContext context, int index) {
              final ClubItem club = state.clubs[index];
              return _ClubCard(
                club: club,
                onTap: () => notifier.toggleClub(club.id),
              );
            },
          ),
          Positioned(
            left: 26,
            right: 26,
            bottom: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create Club flow coming soon')),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Club'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC41C4D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _goalController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final UserProfile profile = ref.read(appStateProvider).profile;
    _nameController = TextEditingController(text: profile.name);
    _goalController = TextEditingController(text: profile.goalKm.toStringAsFixed(1));
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
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 54, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFFC41C4D), Color(0xFF4D0A83)],
              ),
            ),
            child: Row(
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  label: const Text('Home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                  child: const Icon(Icons.more_vert_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const CircleAvatar(
                                radius: 32,
                                child: Icon(Icons.person_rounded, size: 32),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      state.profile.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${state.profile.followers} Followers   ${state.profile.following} Following   ${state.profile.posts} Posts',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF707582),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const <Widget>[
                              Expanded(child: _MiniAction(icon: Icons.history_rounded, label: 'History')),
                              SizedBox(width: 8),
                              Expanded(child: _MiniAction(icon: Icons.confirmation_num_outlined, label: 'Ticket')),
                              SizedBox(width: 8),
                              Expanded(child: _MiniAction(icon: Icons.account_balance_wallet_outlined, label: 'Wallet')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Your Stats',
                            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 10),
                          _Segment(
                            options: const <String>['Walking', 'Running', 'Cycling'],
                            selected: state.activeActivity,
                            onSelect: notifier.setActivityType,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE6E8ED)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _BigStat(
                                        label: 'Distance',
                                        value: '${state.todayDistanceKm.toStringAsFixed(2)} km',
                                      ),
                                    ),
                                    Expanded(
                                      child: _BigStat(
                                        label: 'Time',
                                        value: _hms(Duration(seconds: state.sessionSeconds)),
                                      ),
                                    ),
                                    Expanded(
                                      child: _BigStat(
                                        label: 'Speed',
                                        value:
                                            '${(state.todayDistanceKm / max(1, state.activeMinutes) * 60).toStringAsFixed(1)} /km',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: _BigStat(
                                        label: 'Steps',
                                        value: '${state.stepCount}',
                                      ),
                                    ),
                                    Expanded(
                                      child: _BigStat(
                                        label: 'Elevation',
                                        value: '${(state.todayDistanceKm * 9.3).toStringAsFixed(1)} m',
                                      ),
                                    ),
                                    Expanded(
                                      child: _BigStat(
                                        label: 'Calories',
                                        value: '${state.calories} k',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _Segment(
                            options: const <String>['Weekly', 'Monthly', 'Yearly'],
                            selected: 'Monthly',
                            onSelect: (_) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Profile Settings',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Daily Goal (km)',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Height (cm)',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (kg)',
                                  ),
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
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    notifier.updateProfile(
                                      name: _nameController.text.trim().isEmpty
                                          ? state.profile.name
                                          : _nameController.text.trim(),
                                      goalKm: double.tryParse(
                                            _goalController.text.trim(),
                                          ) ??
                                          state.profile.goalKm,
                                      heightCm: int.tryParse(
                                            _heightController.text.trim(),
                                          ) ??
                                          state.profile.heightCm,
                                      weightKg: int.tryParse(
                                            _weightController.text.trim(),
                                          ) ??
                                          state.profile.weightKg,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Profile updated')),
                                    );
                                  },
                                  icon: const Icon(Icons.save_outlined),
                                  label: const Text('Save'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: notifier.signOut,
                                  icon: const Icon(Icons.logout_rounded),
                                  label: const Text('Sign out'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F7),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFDADDE4),
                  child: Icon(Icons.person_outline_rounded, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hi, ${name.split(' ').first}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _HeaderIcon(icon: Icons.search_rounded),
        const SizedBox(width: 8),
        _HeaderIcon(icon: Icons.notifications_none_rounded),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF12151D), Color(0xFF041F43), Color(0xFF352A0A)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/id/180/1200/500',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0x96000000),
            ),
          ),
          Positioned(
            left: 14,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2DC5FF)),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Color(0xFF2DC5FF),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 16,
            bottom: 18,
            child: Text(
              'ENDURANCE\nSERIES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                height: 0.92,
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 58,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4EC2F3),
                foregroundColor: const Color(0xFF101821),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              child: const Text(
                'Join the Series',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLinksRow extends StatelessWidget {
  const _QuickLinksRow({required this.onTapProfile});

  final VoidCallback onTapProfile;

  @override
  Widget build(BuildContext context) {
    final List<_QuickLink> items = <_QuickLink>[
      const _QuickLink(icon: Icons.storefront_rounded, title: 'CrewShop'),
      const _QuickLink(icon: Icons.fitness_center_rounded, title: 'CrewFit'),
      const _QuickLink(icon: Icons.flag_rounded, title: 'Challenges'),
      _QuickLink(icon: Icons.person_rounded, title: 'Profile', onTap: onTapProfile),
    ];

    return Row(
      children: items
          .map(
            (_QuickLink item) => Expanded(
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: <Widget>[
                      Icon(item.icon, color: const Color(0xFFC41C4D), size: 30),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF474C58),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _QuickLink {
  const _QuickLink({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
}

class _DealsScroller extends StatelessWidget {
  const _DealsScroller();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> deals = <Map<String, String>>[
      <String, String>{
        'name': 'Arix Chevron Tee',
        'price': '800',
        'image': 'https://picsum.photos/id/26/420/320',
      },
      <String, String>{
        'name': 'Arix Urban Edge',
        'price': '800',
        'image': 'https://picsum.photos/id/21/420/320',
      },
      <String, String>{
        'name': 'Performance Shorts',
        'price': '650',
        'image': 'https://picsum.photos/id/64/420/320',
      },
    ];

    return SizedBox(
      height: 246,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: deals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> deal = deals[index];
          return Container(
            width: 194,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD9DCE3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFC41C4D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: const Text(
                      'Upto 300 Off',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.network(
                            deal['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE5E8EF),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: <Color>[Color(0x3D000000), Colors.transparent],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deal['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Text(
                        'Rs ${deal['price']}',
                        style: const TextStyle(
                          color: Color(0xFFC41C4D),
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFC41C4D),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text('Explore'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActivitySnippet extends StatelessWidget {
  const _ActivitySnippet({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final ActivityRecord activity = state.activities.first;
    return Row(
      children: <Widget>[
        const CircleAvatar(
          radius: 24,
          child: Icon(Icons.landscape_rounded),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                state.profile.name,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Text(
                '${activity.date.day}/${activity.date.month}/${activity.date.year} ${activity.date.hour.toString().padLeft(2, '0')}:${activity.date.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Color(0xFF707582), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChallengeSpotlight extends StatelessWidget {
  const _ChallengeSpotlight({required this.challenge});

  final ChallengeItem challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF285E85), Color(0xFF6DA4C8)],
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Challenge',
            style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900),
          ),
          Text(
            challenge.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: challenge.progressRatio,
            minHeight: 10,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF90EE90)),
          ),
          const SizedBox(height: 6),
          Text(
            '${challenge.progressKm.toStringAsFixed(0)} / ${challenge.targetKm.toStringAsFixed(0)} km',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _GiftWalletCard extends StatelessWidget {
  const _GiftWalletCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF191B21), Color(0xFF3B1022)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your Rewards Wallet',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            '2,490 points available',
            style: TextStyle(color: Color(0xFFD6DAE2), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.title, required this.cost});

  final String title;
  final int cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 42) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E6ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.workspace_premium_rounded, color: Color(0xFFC41C4D)),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            '$cost pts',
            style: const TextStyle(
              color: Color(0xFFC41C4D),
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTypeChip extends StatelessWidget {
  const _ActivityTypeChip({required this.selected, required this.onChange});

  final String selected;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: selected,
      onSelected: onChange,
      itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: 'Walking', child: Text('Walking')),
        PopupMenuItem<String>(value: 'Running', child: Text('Running')),
        PopupMenuItem<String>(value: 'Cycling', child: Text('Cycling')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFC41C4D),
          borderRadius: BorderRadius.circular(28),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFFC41C4D).withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.directions_walk_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              selected,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.title,
    required this.value,
    this.suffix,
    required this.align,
  });

  final String title;
  final String value;
  final String? suffix;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        if (suffix != null)
          Text(
            suffix!,
            style: const TextStyle(
              color: Color(0xFF707582),
              fontWeight: FontWeight.w600,
            ),
          ),
        Text(
          title,
          style: const TextStyle(color: Color(0xFF707582), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.challenge,
    required this.joined,
    required this.onPressed,
  });

  final ChallengeItem challenge;
  final bool joined;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final List<String> eventImages = <String>[
      'https://picsum.photos/id/29/1200/680',
      'https://picsum.photos/id/1039/1200/680',
      'https://picsum.photos/id/1024/1200/680',
      'https://picsum.photos/id/1044/1200/680',
    ];
    final String imageUrl = eventImages[challenge.id % eventImages.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E5EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 206,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: joined
                    ? const <Color>[Color(0xFF175A2A), Color(0xFF4D9E6F)]
                    : const <Color>[Color(0xFF173566), Color(0xFF5C86CC)],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
                Container(color: const Color(0x80000000)),
                Center(
                  child: Text(
                    challenge.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        challenge.title,
                        style: const TextStyle(
                          color: Color(0xFFC41C4D),
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${challenge.dateText} | ${challenge.category}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6A6F7D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: joined ? null : onPressed,
                  child: Text(joined ? 'Joined' : 'Participate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.club, required this.onTap});

  final ClubItem club;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final List<String> clubImages = <String>[
      'https://picsum.photos/id/1003/300/300',
      'https://picsum.photos/id/1011/300/300',
      'https://picsum.photos/id/1027/300/300',
      'https://picsum.photos/id/1040/300/300',
    ];
    final String imageUrl = clubImages[club.id % clubImages.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 26,
              backgroundColor: club.accent.withValues(alpha: 0.15),
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 10),
            Text(
              club.name,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30, height: 1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              '${club.memberCount} members',
              style: const TextStyle(
                color: Color(0xFF707582),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: club.joined ? const Color(0xFF28303D) : const Color(0xFFC41C4D),
                ),
                child: Text(club.joined ? 'Joined' : 'Join'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: const Color(0xFFC41C4D)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF6A6F7D))),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, height: 1),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: options
            .map(
              (String option) => Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: selected == option
                          ? const Color(0xFFC41C4D)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected == option
                            ? Colors.white
                            : const Color(0xFF2D3442),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

String _hms(Duration duration) {
  final int h = duration.inHours;
  final int m = duration.inMinutes % 60;
  final int s = duration.inSeconds % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90D9),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const WeatherHomePage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Home Page
// ─────────────────────────────────────────────────────────────
class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with TickerProviderStateMixin {
  final WeatherService _service = WeatherService();
  final TextEditingController _searchController = TextEditingController();

  WeatherModel? _weather;
  List<WeatherModel> _forecast = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCity = 'Karachi';

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadWeather(_currentCity);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _fadeController.reset();

    try {
      final results = await Future.wait([
        _service.fetchWeatherByCity(city),
        _service.fetchForecastByCity(city),
      ]);

      setState(() {
        _weather = results[0] as WeatherModel;
        _forecast = results[1] as List<WeatherModel>;
        _isLoading = false;
        _currentCity = city;
      });

      _fadeController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      _loadWeather(city);
      FocusScope.of(context).unfocus();
    }
  }

  // Determine background gradient based on weather condition
  List<Color> _getBackgroundColors(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear':
        return [const Color(0xFF1a1a2e), const Color(0xFF16213e), const Color(0xFF0f3460)];
      case 'clouds':
        return [const Color(0xFF1c1c2e), const Color(0xFF2d3561), const Color(0xFF1a1a2e)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF0d1b2a), const Color(0xFF1b2838), const Color(0xFF243b55)];
      case 'snow':
        return [const Color(0xFF1a2a4a), const Color(0xFF2d4a7a), const Color(0xFF1a2a4a)];
      case 'thunderstorm':
        return [const Color(0xFF0a0a0a), const Color(0xFF1a0a2a), const Color(0xFF0a0a1a)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFF1a1a1a), const Color(0xFF2d2d3d), const Color(0xFF1a1a2a)];
      default:
        return [const Color(0xFF1a1a2e), const Color(0xFF16213e), const Color(0xFF0f3460)];
    }
  }

  String _getWeatherEmoji(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear': return '☀️';
      case 'clouds': return '☁️';
      case 'rain': return '🌧️';
      case 'drizzle': return '🌦️';
      case 'thunderstorm': return '⛈️';
      case 'snow': return '❄️';
      case 'mist':
      case 'fog':
      case 'haze': return '🌫️';
      default: return '🌤️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getBackgroundColors(_weather?.mainCondition);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _errorMessage != null
                        ? _buildErrorState()
                        : _buildWeatherContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search Bar ──────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                onSubmitted: (_) => _onSearch(),
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _onSearch,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90D9), Color(0xFF7B4FD9)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90D9).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading State ───────────────────────────────────────────
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: const Text('🌤️', style: TextStyle(fontSize: 80)),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            color: Color(0xFF4A90D9),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Fetching weather data...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error State ─────────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _loadWeather(_currentCity),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main Weather Content ────────────────────────────────────
  Widget _buildWeatherContent() {
    if (_weather == null) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            _buildHeroCard(),
            const SizedBox(height: 20),
            _buildDetailsGrid(),
            const SizedBox(height: 20),
            _buildSunriseSunset(),
            const SizedBox(height: 20),
            _buildForecastSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Hero Card ───────────────────────────────────────────────
  Widget _buildHeroCard() {
    final w = _weather!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // City name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Color(0xFF4A90D9), size: 20),
              const SizedBox(width: 6),
              Text(
                '${w.cityName}, ${w.country}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Weather emoji + temperature
          ScaleTransition(
            scale: _pulseAnimation,
            child: Text(
              _getWeatherEmoji(w.mainCondition),
              style: const TextStyle(fontSize: 90),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            w.tempString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w200,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            w.description.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Min / Max / Feels Like
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _miniStat('↓ Min', w.tempMinString),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                _miniStat('Feels', w.feelsLikeString),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                _miniStat('↑ Max', w.tempMaxString),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
      ],
    );
  }

  // ── Details Grid ────────────────────────────────────────────
  Widget _buildDetailsGrid() {
    final w = _weather!;
    final items = [
      _GridItem(Icons.water_drop_outlined, 'Humidity', '${w.humidity}%',
          const Color(0xFF4A90D9)),
      _GridItem(Icons.air, 'Wind', w.windSpeedString,
          const Color(0xFF50C878)),
      _GridItem(Icons.compress, 'Pressure', '${w.pressure} hPa',
          const Color(0xFFFFB347)),
      _GridItem(Icons.visibility_outlined, 'Visibility', w.visibilityString,
          const Color(0xFFFF6B9D)),
      _GridItem(Icons.cloud_outlined, 'Cloudiness', '${w.cloudiness}%',
          const Color(0xFFB19CD9)),
      _GridItem(Icons.navigation, 'Wind Dir',
          _degreesToDirection(w.windDegree), const Color(0xFF87CEEB)),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: items.map((item) => _buildGridCard(item)).toList(),
    );
  }

  Widget _buildGridCard(_GridItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: item.color, size: 26),
          const SizedBox(height: 8),
          Text(
            item.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Sunrise / Sunset ────────────────────────────────────────
  Widget _buildSunriseSunset() {
    final w = _weather!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('🌅', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  w.sunriseString,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sunrise',
                  style:
                      TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
                ),
              ],
            ),
          ),
          // Day length arc visual
          CustomPaint(
            size: const Size(80, 50),
            painter: _SunArcPainter(
              sunrise: w.sunrise,
              sunset: w.sunset,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('🌇', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  w.sunsetString,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sunset',
                  style:
                      TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Forecast Section ────────────────────────────────────────
  Widget _buildForecastSection() {
    if (_forecast.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5-Period Forecast',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _forecast.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _buildForecastCard(_forecast[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(WeatherModel f, int index) {
    final time = DateTime.now().add(Duration(hours: (index + 1) * 3));
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: index == 0
            ? const Color(0xFF4A90D9).withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: index == 0
              ? const Color(0xFF4A90D9).withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            timeStr,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
          ),
          Text(
            _getWeatherEmoji(f.mainCondition),
            style: const TextStyle(fontSize: 26),
          ),
          Text(
            f.tempString,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _degreesToDirection(int degrees) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((degrees + 22.5) / 45).floor() % 8];
  }
}

// ─────────────────────────────────────────────────────────────
//  Helper Data Class
// ─────────────────────────────────────────────────────────────
class _GridItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _GridItem(this.icon, this.label, this.value, this.color);
}

// ─────────────────────────────────────────────────────────────
//  Sun Arc Painter
// ─────────────────────────────────────────────────────────────
class _SunArcPainter extends CustomPainter {
  final DateTime sunrise;
  final DateTime sunset;

  const _SunArcPainter({required this.sunrise, required this.sunset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.addArc(
      Rect.fromLTWH(0, 0, size.width, size.height * 2),
      math.pi,
      math.pi,
    );

    canvas.drawPath(path, paint);

    // Sun position
    final now = DateTime.now();
    final totalMs =
        sunset.millisecondsSinceEpoch - sunrise.millisecondsSinceEpoch;
    final elapsedMs =
        now.millisecondsSinceEpoch - sunrise.millisecondsSinceEpoch;
    final progress = (elapsedMs / totalMs).clamp(0.0, 1.0);

    final angle = math.pi + progress * math.pi;
    final cx = size.width / 2 + (size.width / 2) * math.cos(angle);
    final cy = size.height + (size.height) * math.sin(angle);

    canvas.drawCircle(
      Offset(cx, cy),
      5,
      Paint()..color = const Color(0xFFFFD700),
    );

    // Partial arc glow
    final glowPath = Path();
    glowPath.addArc(
      Rect.fromLTWH(0, 0, size.width, size.height * 2),
      math.pi,
      progress * math.pi,
    );
    canvas.drawPath(glowPath, glowPaint);
  }

  @override
  bool shouldRepaint(_SunArcPainter old) =>
      old.sunrise != sunrise || old.sunset != sunset;
}
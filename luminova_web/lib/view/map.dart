import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: MapPage()));

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();

  // JSON distant + fallback local
  static const String kRemoteJsonPath = '/data/json/adress.json';
  static const String kLocalFallbackAsset = 'assets/adress.json';

  // Données
  final List<_Place> _places = [];
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  String _toAbsoluteUrl(String urlOrPath) {
    if (urlOrPath.isEmpty) return '';
    if (urlOrPath.startsWith('http')) return urlOrPath;
    final origin = Uri.base.origin; // ex: https://luminova-energy.ch
    final normalized = urlOrPath.startsWith('/') ? urlOrPath : '/$urlOrPath';
    return '$origin$normalized';
  }

  Future<List<dynamic>> _fetchJsonList() async {
    try {
      final uri = Uri.parse(
        '$kRemoteJsonPath?t=${DateTime.now().millisecondsSinceEpoch}',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        return json.decode(res.body) as List<dynamic>;
      }
      throw Exception('HTTP ${res.statusCode}');
    } catch (_) {
      final raw = await rootBundle.loadString(kLocalFallbackAsset);
      return json.decode(raw) as List<dynamic>;
    }
  }

  Future<void> _loadMarkers() async {
    final list = await _fetchJsonList();

    _places.clear();
    _markers.clear();

    for (var i = 0; i < list.length; i++) {
      final e = list[i] as Map<String, dynamic>;

      final lat = (e['lat'] as num).toDouble();
      final lng = (e['lng'] as num).toDouble();
      final image = (e['image'] as String?)?.trim() ?? '';
      final rawCom = (e['com'] as String?) ?? '';
      final com =
          rawCom
              .replaceAll('\r\n', ' ')
              .replaceAll('\n', ' ')
              .replaceAll('\r', ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();

      final place = _Place(
        point: LatLng(lat, lng),
        imageUrl: _toAbsoluteUrl(image),
        comment: com,
      );
      _places.add(place);

      // On doit capturer la même instance de Marker pour showPopupsOnlyFor
      late final Marker m;
      m = Marker(
        key: ValueKey(i),
        point: place.point,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _popupController.showPopupsOnlyFor([m]),
          child: MouseRegion(
            onEnter: (_) => _popupController.showPopupsOnlyFor([m]),
            onExit: (_) => _popupController.hideAllPopups(),
            child: const Icon(
              Icons.location_on,
              color: Colors.redAccent,
              size: 36,
            ),
          ),
        ),
      );

      _markers.add(m);
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_markers.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bounds = LatLngBounds.fromPoints(
      _places.map((p) => p.point).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos implantations en Suisse'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth * 1;
          final h = constraints.maxHeight * 1;

          return Center(
            child: SizedBox(
              width: w,
              height: h,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCameraFit: CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(20),
                  ),
                  onTap: (_, __) => _popupController.hideAllPopups(),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: _markers,
                      popupController: _popupController,
                      // On affiche le popup au-dessus du marker
                      popupDisplayOptions: PopupDisplayOptions(
                        builder: (context, marker) {
                          // Récupère l'index via la key du Marker
                          final key = marker.key;
                          int idx = 0;
                          if (key is ValueKey) {
                            final v = key.value;
                            if (v is int) idx = v;
                          }
                          final place = _places[idx];

                          return _PlacePopup(place: place);
                        },
                      ),
                    ),
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

class _Place {
  final LatLng point;
  final String imageUrl;
  final String comment;

  _Place({required this.point, required this.imageUrl, required this.comment});
}
class _PlacePopup extends StatelessWidget {
  final _Place place;
  const _PlacePopup({required this.place});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (place.comment.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  place.comment,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  softWrap: true,           // (true par défaut, mais explicite)
                ),
              ),
            if (place.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100,
                    maxHeight: 100,
                  ),
                  child: Image.network(
                    place.imageUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) => Container(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

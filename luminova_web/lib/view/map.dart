import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const MaterialApp(home: MapPage()));

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();

  double _currentZoom = 8.0;

  final List<LatLng> coordinates = [
    LatLng(46.78301752506598, 7.15563468433039),
    LatLng(46.751038239413354, 6.727014211313741),
    LatLng(46.52951584205687, 6.3013753751193216),
    LatLng(46.69917195961989, 6.570371611311952),
    LatLng(46.4723116183315, 6.820766128499531),
    LatLng(46.69849924467213, 6.571371413163429),
    LatLng(46.26691582371807, 6.147601313148969),
    LatLng(46.26648007386001, 6.156720341984859),
    LatLng(46.2233405031321, 6.131258413147484),
    LatLng(46.20190768122931, 6.14636005547497),
    LatLng(47.00004656325616, 6.940248042009598),
  ];

  late final List<Marker> markers;

  @override
  void initState() {
    super.initState();

    markers =
        coordinates.map((coord) {
          return Marker(
            point: coord,
            width: 40,
            height: 40,
            key: ValueKey(coord),
            child: MouseRegion(
              onEnter: (_) {
                _popupController.showPopupsOnlyFor([
                  Marker(
                    point: coord,
                    width: 40,
                    height: 40,
                    key: ValueKey(coord),
                    child: const SizedBox(),
                  ),
                ]);
              },
              onExit: (_) => _popupController.hideAllPopups(),
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bounds = LatLngBounds.fromPoints(coordinates);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos implantations en Suisse'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final width =
              screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9;

          return Center(
            child: SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.8,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCameraFit: CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(20),
                  ),
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onTap: (_, __) => _popupController.hideAllPopups(),
                  onPositionChanged: (pos, _) {
                    _currentZoom = pos.zoom ?? _currentZoom;
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: markers,
                      popupController: _popupController,
                      popupDisplayOptions: PopupDisplayOptions(
                        builder: (context, marker) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Latitude: ${marker.point.latitude.toStringAsFixed(4)}\n'
                                'Longitude: ${marker.point.longitude.toStringAsFixed(4)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
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

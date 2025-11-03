import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/app_entity.dart';
import '../../core/constants/app_colors.dart';

/// Map screen
/// Displays a map with Istanbul location marker
class MapScreen extends StatefulWidget {
  final AppEntity app;

  const MapScreen({
    super.key,
    required this.app,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Istanbul coordinates (şu anki konum) - yuvarlatılmış, daha az hassas
  static const double istanbulLat = 41.0;
  static const double istanbulLng = 29.0;
  static const LatLng istanbulLocation = LatLng(istanbulLat, istanbulLng);

  // Eskişehir coordinates (üniversite)
  static const double eskisehirLat = 39.753118;
  static const double eskisehirLng = 30.493420;
  static const LatLng eskisehirLocation = LatLng(eskisehirLat, eskisehirLng);

  // Samsun coordinates (memleket) - yuvarlatılmış, daha az hassas
  static const double samsunLat = 41.3;
  static const double samsunLng = 36.3;
  static const LatLng samsunLocation = LatLng(samsunLat, samsunLng);

  // Ortalama konum (haritayı başlatmak için)
  static final LatLng centerLocation = LatLng(
    (istanbulLat + eskisehirLat + samsunLat) / 3,
    (istanbulLng + eskisehirLng + samsunLng) / 3,
  );

  final MapController _mapController = MapController();

  void _animateToCenter() {
    _mapController.move(centerLocation, 5.5);
  }

  @override
  void initState() {
    super.initState();
    // Map açıldığında ortalama konuma animate et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateToCenter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: centerLocation,
            initialZoom: 5.5,
            minZoom: 5.0,
            maxZoom: 18.0,
          ),
          children: [
            // Tile layer (Standard OpenStreetMap)
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'portfolio',
            ),
            // Marker layer
            MarkerLayer(
              markers: [
                // Şu anki konum - İstanbul
                Marker(
                  point: istanbulLocation,
                  width: 100,
                  height: 100,
                  alignment: const Alignment(0, -0.25), // Pinin ortası koordinatı gösterir
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'map.currentLocation'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Üniversite - Eskişehir
                Marker(
                  point: eskisehirLocation,
                  width: 140,
                  height: 100,
                  alignment: const Alignment(0, -0.25), // Pinin ortası koordinatı gösterir
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'map.universityLocation'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Memleket - Samsun
                Marker(
                  point: samsunLocation,
                  width: 140,
                  height: 100,
                  alignment: const Alignment(0, -0.25), // Pinin ortası koordinatı gösterir
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'map.hometownLocation'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Bilgilendirme kutusu - sağ üst
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xB3000000), // Colors.black.withOpacity(0.7) yerine
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0x4DFFFFFF), // Colors.white.withOpacity(0.3) yerine
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'map.locationInfo'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // My Location button
        Positioned(
          bottom: 30,
          right: 20,
          child: FloatingActionButton(
            onPressed: _animateToCenter,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


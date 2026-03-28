import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GlobalAdBanner extends StatefulWidget {
  const GlobalAdBanner({super.key});

  @override
  State<GlobalAdBanner> createState() => _GlobalAdBannerState();
}

class _GlobalAdBannerState extends State<GlobalAdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadAd();
    }
  }

  void _loadAd() {
    final adUnitId = 'ca-app-pub-4731326583797023/6504031533';

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container(
        width: double.infinity,
        height: 50,
        color: Colors.grey.withValues(alpha: 0.2),
        alignment: Alignment.center,
        child: const Text(
          'AdMob Banner Placeholder (Web)',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    if (_isLoaded && _bannerAd != null) {
      return Container(
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

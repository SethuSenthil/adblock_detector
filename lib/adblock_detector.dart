library adblock_detector;

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

enum AdNetworks {
  googleAdMob,
  mediaNet,
  appSumari,
  startApp,
  adColony,
}

/// A class that detects the presence of ad blockers.
class AdBlockDetector {
  String testHost;

  AdBlockDetector({this.testHost = 'example.com'});

  /// Checks if AdGuard DNS is being used.
  ///
  /// Returns `true` if AdGuard DNS is being used, `false` otherwise.
  Future<bool> isAdguardDNS() async {
    if (await isInternetConnected()) {
      bool adGuardDNS = false;

      try {
        // Send a GET request to the AdGuard DNS check URL
        Response res = await http.get(Uri.parse(
            'https://g3-axkdouaxsfrp3ocfud-dnscheck.adguard-dns.com/dnscheck/test'));

        // If the response status code is not 200, AdGuard DNS is being used
        if (res.statusCode != 200) {
          adGuardDNS = true;
        }
      } catch (e) {
        // An exception occurred, AdGuard DNS is NOT being used
      }

      return adGuardDNS;
    }
    return false;
  }

  /// Checks if the device is connected to the internet.
  ///
  /// Returns `true` if the device is connected to the internet, `false` otherwise.
  Future<bool> isInternetConnected() async {
    try {
      Response res = await http.get(Uri.parse('http://$testHost'));
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Checks if ad blocking is enabled.
  ///
  /// The [testAdNetworks] parameter is a list of predefined ad networks to test.
  /// The [customAdNetworks] parameter is an optional list of custom ad network URLs to test.
  ///
  /// Returns `true` if ad blocking is enabled, `false` otherwise.
  Future<bool> isAdBlockEnabled(
      {required List<AdNetworks> testAdNetworks,
      List<Uri>? customAdNetworks}) async {
    if (await isInternetConnected()) {
      Map<AdNetworks, String> urlMap = {
        AdNetworks.googleAdMob: 'ad.doubleclick.net',
        AdNetworks.mediaNet: 'media.net',
        AdNetworks.appSumari: 'api.appsamurai.com',
        AdNetworks.startApp: 'api.fo.startappservice.com',
        AdNetworks.adColony: 'clients-api.adcolony.com',
      };

      bool adBlockEnabled = false;

      for (var testURL in testAdNetworks) {
        try {
          String url = urlMap[testURL]!;
          // Send a GET request to the test URL
          Response res = await http.get(Uri.parse("https://$url"));

          // If the response status code is not 200, adblock is enabled
          if (res.statusCode != 200) {
            adBlockEnabled = true;
          }
        } catch (e) {
          // An exception occurred, adblock is enabled
          adBlockEnabled = true;
          break;
        }
      }

      if (customAdNetworks != null) {
        for (var testURL in customAdNetworks) {
          try {
            // Send a GET request to the test URL
            Response res = await http.get(testURL);

            // If the response status code is not 200, adblock is enabled
            if (res.statusCode != 200) {
              adBlockEnabled = true;
            }
          } catch (e) {
            // An exception occurred, adblock is enabled
            adBlockEnabled = true;
            break;
          }
        }
      }

      return adBlockEnabled;
    }
    return false;
  }
}

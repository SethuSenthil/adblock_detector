library adblock_detector;

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AdBlockDetector {
  // Check if adblock is enabled
  Future<bool> isAdBlockEnabled() async {
    // Define test URLs to check for adblock
    Map<String, String> testURLs = {"Google AdMob": 'ad.doubleclick.net'};

    bool adBlockEnabled = false;

    for (var entry in testURLs.entries) {
      try {
        // Send a GET request to the test URL
        Response res = await http.get(Uri.parse("https://${entry.value}"));

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

    return adBlockEnabled;
  }

  // Check if AdGuard DNS is being used
  Future<bool> isAdguardDNS() async {
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
}

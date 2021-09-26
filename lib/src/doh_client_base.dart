import 'dart:convert';
import 'package:universal_io/io.dart';

import '../doh_client.dart';

/// DNS-over-HTTPS class
class DoH {
  // interface attributes
  final Uri provider;

  DoH(this.provider);

  Future<DoHResponse?> lookup(String domain, RecordType type,
      {bool? dnssec, Duration? timeout, bool? verbose}) async {
    if (verbose == null) verbose = true; //print full GET error by default
    try {
      // Init HttpClient
      var client = HttpClient();
      // Set HttpClient timeout
      client.connectionTimeout = timeout;
      // Init request query parameters and send request
      var request = await client.getUrl(provider.replace(queryParameters: {
        'name': domain,
        'type': type.toString().replaceFirst('RecordType.', ''),
        'dnssec': dnssec != null && dnssec ? '1' : '0'
      }));
      // Set request http header (need for 'cloudflare' provider)
      request.headers.add('Accept', 'application/dns-json');
      // Close & retrive response
      var response = await request.close();
      //Dart analyzer says response cannot be null, so I removed the if(){}
      // Convert response to <String>
      var json =
          await response.cast<List<int>>().transform(Utf8Decoder()).join();
      if (json.isNotEmpty) {
        // Init <Map> for jsonDecode
        Map<String, dynamic>? data;
        try {
          // Decode response <String> to <Map>
          data = jsonDecode(json);
        } catch (e) {
          data = null;
        }
        if (data != null && data.isNotEmpty) {
          // Return from status&data
          return DoHResponse.fromMap(response.statusCode, data);
        }
      }
      return DoHResponse.fromMap(response.statusCode, null);
    } catch (e) {
      verbose ? print(e) : print("GET Error");
    }
    return null;
  }
}

/// Providers
class DoHProvider {
  static final Uri google = Uri.parse('https://dns.google.com/resolve');
  static final Uri cloudflare =
      Uri.parse('https://cloudflare-dns.com/dns-query');
  static final Uri quad9 = Uri.parse('https://dns.quad9.net:5053/dns-query');
}

enum RecordType {
  A,
  AAAA,
  CAA,
  CNAME,
  DNSKEY,
  DS,
  IPSECKEY,
  MX,
  NAPTR,
  NS,
  PTR,
  SPF,
  SRV,
  SSHFP,
  TLSA,
  TXT
}

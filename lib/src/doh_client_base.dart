import 'dart:convert';
import 'dart:io';

import '../doh_client.dart';


class DoH {
  final Uri provider;

  DoH(this.provider);

  Future<DoHResponse> lookup(String domain, RecordType type,
      {bool dnssec, Duration timeout}) async {
    try {
      var client = HttpClient();
      client.connectionTimeout = timeout;
      var request = await client.getUrl(provider.replace(queryParameters: {
        'name': domain,
        'type': type.toString().replaceFirst('RecordType.', ''),
        'dnssec': dnssec != null && dnssec ? '1' : '0'
      }));
      request.headers.add('Accept', 'application/dns-json');
      var response = await request.close();
      if (response != null && response.statusCode != null) {
        var json =
            await response.cast<List<int>>().transform(Utf8Decoder()).join();
        if (json != null && json.isNotEmpty) {
          Map<String, dynamic> data;
          try {
            data = jsonDecode(json);
          } catch (e) {
            data = null;
          }
          if (data != null && data.isNotEmpty) {
            return DoHResponse.fromMap(response.statusCode, data);
          }
          return DoHResponse.fromMap(response.statusCode, null);
        }
        return DoHResponse.fromMap(response.statusCode, null);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

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

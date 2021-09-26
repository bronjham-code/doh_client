import 'package:doh_client/doh_client.dart';

main() async {
  // Request to DNS-over-HTTPS service
  var dohResponse = await DoH(DoHProvider.google)
      .lookup('google.com', RecordType.A, dnssec: true);
  // Handle if response not null
  if (dohResponse != null) {
    dohResponse.answer!.forEach((answer) {
      print(answer.data);
    });
  }
}

class DoHResponse {
  // interface attributes
  final int httpStatus;
  final int? status;
  final bool? tc;
  final bool? rd;
  final bool? ra;
  final bool? ad;
  final bool? cd;

  final List<DoHQuestion>? question;
  final List<DoHAnswer>? answer;

  DoHResponse(this.httpStatus, this.status, this.tc, this.rd, this.ra, this.ad,
      this.cd, this.question, this.answer);

  //Constructor from http status & http data
  factory DoHResponse.fromMap(int httpStatus, Map<String, dynamic>? map) {
    if (map != null) {
      // Init DoH querstions
      var _question = <DoHQuestion>[];
      // Init DoH aswers
      var _answer = <DoHAnswer>[];
      if (map.containsKey('Question')) {
        (map['Question'].cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .forEach((Map<String, dynamic> question) =>
                _question.add(DoHQuestion.fromMap(question)));
      }
      if (map.containsKey('Answer')) {
        (map['Answer'].cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .forEach((Map<String, dynamic> answer) =>
                _answer.add(DoHAnswer.fromMap(answer)));
      }
      return DoHResponse(
          httpStatus,
          map.containsKey('Status') ? map['Status'] : null,
          map.containsKey('TC') ? map['TC'] : null,
          map.containsKey('RD') ? map['RD'] : null,
          map.containsKey('RA') ? map['RA'] : null,
          map.containsKey('AD') ? map['AD'] : null,
          map.containsKey('CD') ? map['CD'] : null,
          _question.isNotEmpty ? _question : null,
          _answer.isNotEmpty ? _answer : null);
    }
    return DoHResponse(
        httpStatus, null, null, null, null, null, null, null, null);
  }
}

class DoHQuestion {
  // interface attributes
  final String name;
  final int type;

  DoHQuestion(this.name, this.type);
//Constructor from map
  factory DoHQuestion.fromMap(Map<String, dynamic> map) =>
      DoHQuestion(map['name'], map['type']);
}

class DoHAnswer {
  // interface attributes
  final String name;
  final int type;
  final int ttl;
  final String data;

  DoHAnswer(this.name, this.type, this.ttl, this.data);
  //Constructor from map
  factory DoHAnswer.fromMap(Map<String, dynamic> map) =>
      DoHAnswer(map['name'], map['type'], map['TTL'], map['data']);
}

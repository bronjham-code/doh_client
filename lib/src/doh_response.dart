class DoHResponse {
  final int httpStatus;
  final int status;
  final bool tc;
  final bool rd;
  final bool ra;
  final bool ad;
  final bool cd;

  final List<DoHQuestion> question;
  final List<DoHAnswer> answer;

  DoHResponse(this.httpStatus, this.status, this.tc, this.rd, this.ra, this.ad,
      this.cd, this.question, this.answer);

  factory DoHResponse.fromMap(int httpStatus, Map<String, dynamic> map) {
    if (map != null) {
      var _question = <DoHQuestion>[];
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
    return httpStatus != null && httpStatus > 0
        ? DoHResponse(
            httpStatus, null, null, null, null, null, null, null, null)
        : null;
  }
}

class DoHQuestion {
  final String name;
  final int type;

  DoHQuestion(this.name, this.type);

  factory DoHQuestion.fromMap(Map<String, dynamic> map) =>
      DoHQuestion(map['name'], map['type']);
}

class DoHAnswer {
  final String name;
  final int type;
  final int ttl;
  final String data;

  DoHAnswer(this.name, this.type, this.ttl, this.data);

  factory DoHAnswer.fromMap(Map<String, dynamic> map) =>
      DoHAnswer(map['name'], map['type'], map['TTL'], map['data']);
}
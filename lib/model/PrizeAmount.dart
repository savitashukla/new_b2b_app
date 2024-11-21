
class PrizeAmount{
  var value;
  var type;
  PrizeAmount.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'] ;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;

  }

}
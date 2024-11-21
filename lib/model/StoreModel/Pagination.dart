class Pagination {
  int offset;
  int total;
  int count;
  int limit;

  Pagination({this.offset, this.total, this.count, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    total = json['total'];
    count = json['count'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['count'] = this.count;
    data['limit'] = this.limit;
    return data;
  }
}
class Meta {
  int? page;
  int? size;
  int? count;

  Meta({
    this.page,
    this.size,
    this.count,
  });

  factory Meta.fromJson(Map json) {
    return Meta(
      page: json['page'],
      size: json['size'],
      count: json['count'],
    );
  }
}

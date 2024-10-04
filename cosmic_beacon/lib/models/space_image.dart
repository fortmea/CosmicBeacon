class SpaceImage {
  String? copyright;
  String? date;
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? serviceVersion;
  String? title;
  String? url;

  SpaceImage(
      {this.copyright,
      this.date,
      this.explanation,
      this.hdurl,
      this.mediaType,
      this.serviceVersion,
      this.title,
      this.url});

  SpaceImage.fromJson(Map<String, dynamic> json) {
    copyright = json['copyright'];
    date = json['date'];
    explanation = json['explanation'];
    hdurl = json['hdurl'];
    mediaType = json['media_type'];
    serviceVersion = json['service_version'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['copyright'] = copyright;
    data['date'] = date;
    data['explanation'] = explanation;
    data['hdurl'] = hdurl;
    data['media_type'] = mediaType;
    data['service_version'] = serviceVersion;
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}

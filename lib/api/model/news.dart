import 'Source.dart';

/// source : {"id":null,"name":"Gizmodo.com"}
/// author : "Mike Pearl"
/// title : "Fidelity: Actually, Homes Are Getting Cheaper (as Long as You Price Them in Bitcoin)"
/// description : "There's no affordability crisis. There's just a fiat currency crisis, man."
/// url : "https://gizmodo.com/fidelity-actually-homes-are-getting-cheaper-as-long-as-you-price-them-in-bitcoin-2000785675"
/// urlToImage : "https://gizmodo.com/app/uploads/2026/07/house-sold-1200x675.jpg"
/// publishedAt : "2026-07-15T09:00:02Z"
/// content : "Are you priced out of the housing market? No youre not, you idiot. You just arent using the right kind of money.\r\nThats the argument of an article from July 6 on the Fidelity Digital Assets sitein ot… [+1038 chars]"

class News {
  News({
      this.source, 
      this.author, 
      this.title, 
      this.description, 
      this.url, 
      this.urlToImage, 
      this.publishedAt, 
      this.content,});

  News.fromJson(dynamic json) {
    source = json['source'] != null ? Sources.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }
  Sources? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (source != null) {
      map['source'] = source?.toJson();
    }
    map['author'] = author;
    map['title'] = title;
    map['description'] = description;
    map['url'] = url;
    map['urlToImage'] = urlToImage;
    map['publishedAt'] = publishedAt;
    map['content'] = content;
    return map;
  }

}
class MapResponse {
  final Map<String, dynamic> data;

  MapResponse(this.data);

  factory MapResponse.fromJson(dynamic json) {
    if (json == null) return MapResponse({});
    if (json is Map<String, dynamic>) {
      return MapResponse(json);
    }
    return MapResponse({'raw': json});
  }
}

class ListMapResponse {
  final List<Map<String, dynamic>> items;

  ListMapResponse(this.items);

  factory ListMapResponse.fromJson(dynamic json) {
    if (json == null) return ListMapResponse([]);
    if (json is List) {
      return ListMapResponse(
        json.map((e) => e is Map<String, dynamic> ? e : {'raw': e}).toList(),
      );
    }
    return ListMapResponse([]);
  }
}

class EmptyResponse {
  EmptyResponse();
  factory EmptyResponse.fromJson(dynamic json) => EmptyResponse();
}

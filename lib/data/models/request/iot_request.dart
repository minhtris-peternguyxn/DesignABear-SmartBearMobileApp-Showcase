class CallDeviceRequest {
  final String deviceId;
  final String message;

  CallDeviceRequest({required this.deviceId, this.message = 'Hello from Mobile!'});

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'message': message,
    };
  }
}

class LedControlRequest {
  final String deviceId;
  final int r;
  final int g;
  final int b;
  final int brightness;
  final String effect;
  final int interval;

  LedControlRequest({
    required this.deviceId,
    this.r = 255,
    this.g = 255,
    this.b = 255,
    this.brightness = 200,
    this.effect = 'static',
    this.interval = 500,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'r': r,
      'g': g,
      'b': b,
      'brightness': brightness,
      'effect': effect,
      'interval': interval,
    };
  }
}

import '../../core/network/base_api_client.dart';
import '../../core/network/api_response.dart';
import '../models/response/common_response.dart';
import '../models/response/payment_response.dart';

class PaymentApi extends BaseApiClient {
  Future<ApiResponse<List<SubscriptionPlanModel>>> getSubscriptionPlans() async {
    return get(
      '/api/payment/plans',
      timeout: const Duration(seconds: 10),
      fromJson: (json) {
        if (json is List) {
          return json.map((i) => SubscriptionPlanModel.fromJson(i)).toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<SubscriptionStatusModel>> getSubscriptionStatus() async {
    return get(
      '/api/payment/status',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => SubscriptionStatusModel.fromJson(json),
    );
  }

  Future<ApiResponse<PaymentQRResponse>> createPaymentQR({
    String? voucherCode,
    int planType = 2,
  }) async {
    return post(
      '/api/payment/create-qr',
      timeout: const Duration(seconds: 15),
      body: {
        'planType': planType,
        if (voucherCode != null && voucherCode.trim().isNotEmpty)
          'voucherCode': voucherCode.trim().toUpperCase(),
      },
      fromJson: (json) => PaymentQRResponse.fromJson(json),
    );
  }

  Future<ApiResponse<PaymentQRResponse>> createCandyPaymentQR({
    required int candyPackId,
    String? voucherCode,
  }) async {
    return post(
      '/api/payment/create-candy-qr',
      timeout: const Duration(seconds: 15),
      body: {
        'candyPackId': candyPackId,
        if (voucherCode != null && voucherCode.trim().isNotEmpty)
          'voucherCode': voucherCode.trim().toUpperCase(),
      },
      fromJson: (json) => PaymentQRResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> validateVoucher(String code, int originalAmount) async {
    return get(
      '/api/payment/validate-voucher?code=$code&originalAmount=$originalAmount',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }

  Future<ApiResponse<MapResponse>> cancelPro() async {
    return post(
      '/api/payment/cancel-pro',
      timeout: const Duration(seconds: 10),
      fromJson: (json) => MapResponse.fromJson(json),
    );
  }
}

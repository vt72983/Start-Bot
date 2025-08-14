import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class BotRepository {
  BotRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<bool> fetchStatus() async {
    // По требованию: /status вызывается через POST
    final Response response = await _apiClient.client.post('/status');
    final data = response.data as Map<String, dynamic>;
    final running = data['running'] as bool?;
    if (running == null) {
      throw DioException(requestOptions: response.requestOptions, response: response, error: 'Invalid /status payload');
    }
    return running;
  }

  Future<void> start() async {
    final Response response = await _apiClient.client.post('/start');
    final data = response.data as Map<String, dynamic>;
    if (data['status'] != 'started') {
      throw DioException(requestOptions: response.requestOptions, response: response, error: 'Unexpected /start result');
    }
  }

  Future<void> stop() async {
    final Response response = await _apiClient.client.post('/stop');
    final data = response.data as Map<String, dynamic>;
    if (data['status'] != 'stopped') {
      throw DioException(requestOptions: response.requestOptions, response: response, error: 'Unexpected /stop result');
    }
  }
}



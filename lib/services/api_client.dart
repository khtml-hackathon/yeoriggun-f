import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/analyze_result.dart';
import '../models/stt_result.dart';
import '../config/api_config.dart';

class ApiClient {
  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.currentBaseUrl;

  final String baseUrl;

  // 이미지 분석 API
  Future<AnalyzeResult> analyzeImage(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConfig.analyzeEndpoint}');
      
      // multipart 요청 생성
      final request = http.MultipartRequest('POST', uri);
      
      // 이미지 파일 추가
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      
      // 요청 전송
      final streamedResponse = await request.send().timeout(
        ApiConfig.connectionTimeout,
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return AnalyzeResult.fromJson(data);
      } else {
        throw ApiException(
          '이미지 분석 실패: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } on SocketException {
      throw ApiException('서버에 연결할 수 없습니다. 서버가 실행 중인지 확인해주세요.');
    } on FormatException {
      throw ApiException('서버 응답을 파싱할 수 없습니다.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  // 음성 인식 + 요약 API
  Future<SttResult> sttSummarize(File wavFile) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConfig.sttSummarizeEndpoint}');
      
      // WAV 파일을 바이트로 읽기
      final bytes = await wavFile.readAsBytes();
      
      // 요청 전송
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'audio/wav'},
        body: bytes,
      ).timeout(ApiConfig.connectionTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return SttResult.fromJson(data);
      } else {
        throw ApiException(
          '음성 인식 실패: ${response.statusCode}',
          response.statusCode,
          response.body,
        );
      }
    } on SocketException {
      throw ApiException('서버에 연결할 수 없습니다. 서버가 실행 중인지 확인해주세요.');
    } on FormatException {
      throw ApiException('서버 응답을 파싱할 수 없습니다.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  // 서버 연결 테스트
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse('$baseUrl/health');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// API 예외 클래스
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? responseBody;

  ApiException(this.message, [this.statusCode, this.responseBody]);

  @override
  String toString() => message;
}



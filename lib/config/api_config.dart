class ApiConfig {
  // 개발 환경 (로컬)
  static const String localBaseUrl = 'http://localhost:3000';
  
  // Android 에뮬레이터에서 로컬 서버 접근
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:3000';
  
  // 실제 디바이스에서 로컬 서버 접근 (같은 WiFi)
  static const String deviceLocalBaseUrl = 'http://192.168.1.100:3000'; // 본인의 로컬 IP로 변경
  
  // 프로덕션 서버 (배포 후)
  static const String productionBaseUrl = 'https://your-production-server.com';
  
  // 현재 사용할 API 주소
  static String get currentBaseUrl {
    // TODO: 환경에 따라 동적으로 변경
    return localBaseUrl;
  }
  
  // API 엔드포인트
  static const String analyzeEndpoint = '/analyze';
  static const String sttSummarizeEndpoint = '/stt-summarize';
  
  // 타임아웃 설정
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
}

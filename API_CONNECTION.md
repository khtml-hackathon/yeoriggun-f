# 🔗 백엔드와 Flutter 앱 연결 가이드

## 📋 연결 순서

### 1단계: 백엔드 서버 실행
```bash
# yeoriggun-ai 폴더에서
cd /Users/ireneminhee/Documents/GitHub/yeoriggun-ai

# 의존성 설치 (처음 한 번만)
npm install

# 서버 실행
npm start
# 또는
node index.js
```

**성공 시 출력:**
```
🚀 Server is running on port 3000
📱 Health: http://localhost:3000/health
```

### 2단계: Flutter 앱 실행
```bash
# yeoriggun-mobile 폴더에서
cd /Users/ireneminhee/Documents/GitHub/yeoriggun-mobile

# Flutter 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

## 🌐 API 엔드포인트

### 이미지 분석 API
- **URL**: `POST http://localhost:3000/analyze`
- **입력**: `image` (multipart/form-data)
- **출력**: `{ "baskets": {...}, "prices": {...} }`

### 음성 인식 + 요약 API
- **URL**: `POST http://localhost:3000/stt-summarize`
- **입력**: `audio/wav` 바이너리 데이터
- **출력**: `{ "text": "...", "summary": "..." }`

### 헬스 체크 API
- **URL**: `GET http://localhost:3000/health`
- **출력**: `{ "ok": true }`

## 🔧 환경별 설정

### 로컬 개발 (같은 컴퓨터)
```dart
// lib/config/api_config.dart
static const String localBaseUrl = 'http://localhost:3000';
```

### Android 에뮬레이터
```dart
// Android 에뮬레이터에서 로컬 서버 접근
static const String androidEmulatorBaseUrl = 'http://10.0.2.2:3000';
```

### 실제 디바이스 (같은 WiFi)
```dart
// 본인의 로컬 IP 주소로 변경
static const String deviceLocalBaseUrl = 'http://192.168.1.100:3000';
```

**로컬 IP 확인 방법:**
```bash
# macOS
ifconfig | grep "inet " | grep -v 127.0.0.1

# Windows
ipconfig | findstr "IPv4"
```

## 🚨 문제 해결

### 1. "서버에 연결할 수 없습니다" 오류
- 백엔드 서버가 실행 중인지 확인
- `http://localhost:3000/health` 접속 테스트
- 방화벽 설정 확인

### 2. CORS 오류
- 백엔드의 CORS 설정 확인
- `index.js`에서 `app.use(cors())` 확인

### 3. 이미지 업로드 실패
- 이미지 파일 크기 확인 (20MB 이하)
- 이미지 형식 확인 (JPG, PNG 등)

### 4. 음성 인식 실패
- WAV 파일 형식 확인
- 파일 크기 확인

## 📱 테스트 방법

### 1. 서버 연결 테스트
Flutter 앱 실행 후 상단 우측의 연결 상태 아이콘 확인:
- 🟢 초록색 체크: 연결 성공
- 🔴 빨간색 X: 연결 실패

### 2. 이미지 분석 테스트
1. 앱에서 "이미지 선택 및 분석" 버튼 클릭
2. 과일 사진 선택
3. 분석 결과 확인

### 3. 음성 인식 테스트
1. 이미지 분석 완료 후 음성 녹음 화면으로 이동
2. "녹음 시작" 버튼으로 음성 녹음
3. "인식 및 요약" 버튼으로 API 호출 테스트

## 🔄 개발 워크플로우

1. **백엔드 개발**: `yeoriggun-ai` 폴더에서 API 수정
2. **모바일 개발**: `yeoriggun-mobile` 폴더에서 UI 수정
3. **연결 테스트**: 두 앱 모두 실행하여 API 통신 확인
4. **배포**: 각각 별도로 배포

## 📞 지원

문제가 발생하면:
1. 백엔드 서버 로그 확인
2. Flutter 앱 콘솔 로그 확인
3. 브라우저에서 `http://localhost:3000/health` 접속 테스트
4. GitHub Issues에 문제 보고

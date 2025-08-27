# yeoriggun

Flutter 앱 개발을 위한 공동 작업 프로젝트입니다. Cursor와 Figma MCP를 활용하여 효율적으로 UI를 구현할 수 있는 구조로 설계되었습니다.

## 📱 프로젝트 개요

이 프로젝트는 Flutter를 사용한 모바일 애플리케이션으로, 깔끔한 아키텍처와 재사용 가능한 컴포넌트 구조를 제공합니다.

### 주요 기능
- 홈 화면 구현
- 재사용 가능한 위젯 시스템
- 일관된 테마 및 디자인 시스템
- 네임드 라우팅 시스템

## 🏗️ 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── routes/
│   └── app_routes.dart         # 네임드 라우트 설정
└── ui/
    ├── screens/                # 화면별 위젯
    │   ├── home_screen.dart
    │   ├── login_screen.dart
    │   └── cart_screen.dart
    ├── widgets/                # 재사용 위젯
    │   ├── app_button.dart
    │   ├── category_icons.dart
    │   ├── local_svg_icon.dart
    │   └── store_card.dart
    └── theme/
        └── app_theme.dart      # 앱 테마 설정

assets/
└── icons/                      # SVG 아이콘 파일들
    ├── alarm.svg
    ├── chat.svg
    ├── cooked.svg
    └── ... (기타 아이콘들)
```

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.8.1 이상
- Dart SDK
- Android Studio 또는 VS Code
- iOS 개발 시 Xcode (macOS)

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone <repository-url>
   cd yeoriggun
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **앱 실행**
   ```bash
   flutter run
   ```

### 주요 의존성
- `flutter_svg: ^2.0.9` - SVG 아이콘 렌더링
- `cupertino_icons: ^1.0.8` - iOS 스타일 아이콘

## 🎨 개발 가이드

### 화면(Screen) 추가
1. `lib/ui/screens/` 폴더에 새 파일 생성
2. `StatelessWidget` 또는 `StatefulWidget` 상속
3. `app_routes.dart`에 라우트 추가

```dart
// 예시: new_screen.dart
class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 화면')),
      body: const Center(child: Text('새로운 화면입니다')),
    );
  }
}
```

### 재사용 위젯 추가
1. `lib/ui/widgets/` 폴더에 새 파일 생성
2. 재사용 가능한 위젯으로 구현
3. 필요한 화면에서 import하여 사용

### 테마 커스터마이징
`lib/ui/theme/app_theme.dart`에서 색상, 폰트, 스타일을 수정할 수 있습니다.

```dart
colorScheme: base.colorScheme.copyWith(
  primary: Colors.blue,        // 주 색상
  secondary: Colors.blueGrey,  // 보조 색상
),
```

## 🔧 Figma to Flutter 워크플로우

### Cursor + Figma MCP 설정
1. Figma 데스크톱 앱에서 Dev Mode MCP Server 활성화
2. Cursor에서 MCP 서버 설정
3. Figma 프레임 선택 후 `#get_code` 명령 실행

### 코드 변환 템플릿
```
선택한 Figma 프레임을 Flutter 코드로 변환해줘.

요구사항:
- StatelessWidget 기준으로 작성
- 파일명: <FrameName>Screen.dart
- Scaffold 구조 사용
- Theme 우선 사용 (하드코딩 지양)
- 재사용 위젯은 lib/ui/widgets에 분리
- AppRoutes의 네임드 라우트 사용
```

## 📝 코딩 컨벤션

### 파일 명명 규칙
- 화면: `snake_case_screen.dart` (예: `home_screen.dart`)
- 위젯: `snake_case.dart` (예: `store_card.dart`)
- 클래스: `PascalCase` (예: `HomeScreen`, `StoreCard`)

### 폴더 구조 규칙
- 화면별 위젯: `lib/ui/screens/`
- 재사용 위젯: `lib/ui/widgets/`
- 테마/스타일: `lib/ui/theme/`
- 라우팅: `lib/routes/`

### 코드 스타일
- 모든 위젯에 `const` 생성자 사용
- `super.key` 매개변수 전달
- 16dp 기본 패딩, 12dp 섹션 간격 사용

## 🤝 기여하기

### 브랜치 전략
- `main`: 프로덕션 코드
- `develop`: 개발 브랜치
- `feature/<기능명>`: 기능 개발 브랜치

### Pull Request 가이드
1. 기능 브랜치에서 작업
2. 코드 리뷰 요청
3. 테스트 통과 확인
4. develop 브랜치로 병합

### 이슈 리포팅
- 버그 리포트: 재현 단계와 예상 결과 포함
- 기능 요청: 사용 사례와 구체적인 요구사항 포함

## 📱 지원 플랫폼

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

---

## 🔗 유용한 링크

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Dart 언어 가이드](https://dart.dev/guides)
- [Material Design](https://material.io/design)
- [Flutter 위젯 카탈로그](https://flutter.dev/docs/development/ui/widgets)


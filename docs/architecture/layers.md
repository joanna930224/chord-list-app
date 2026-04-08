# Architecture Layers 🎯

각 레이어별 역할과 상세 규칙을 설명합니다.

## 1. Core Layer (`lib/core/`)

앱의 핵심 설정과 전역 상수를 관리합니다.

**포함 요소:**

- `app.dart`: 앱 초기화 및 설정
- `app_colors.dart`: 전역 컬러 팔레트
- `routes.dart`: 전체 라우팅 정의
- `theme.dart`: 앱 테마 설정
- `initialization.dart`: 앱 초기화 로직

**규칙:**

- 모든 라우트는 `ROUTES` 리스트에 집중 관리
- Firebase 설정은 환경별로 분리

## 2. Feature Layer (`lib/features/`)

### Application Layer

비즈니스 로직과 상태 관리를 담당합니다.

**State 파일 규칙:**

```dart
// [feature]_state.dart
@CopyWith()
class HomeState {
  const HomeState({required this.property});
  final PropertyType property;
}
```

**ViewModel Provider 규칙:**

```dart
// [feature]_view_model_provider.dart
final featureViewModelProvider =
    AsyncNotifierProvider.autoDispose<FeatureViewModelNotifier, FeatureState>(() {
      return FeatureViewModelNotifier();
    });

class FeatureViewModelNotifier extends AutoDisposeAsyncNotifier<FeatureState> {
  @override
  Future<FeatureState> build() async {
    // 초기 상태 로딩
  }
}
```

### Domain Layer

비즈니스 로직과 데이터 모델, 그리고 외부 의존성에 대한 추상화를 관리합니다.

**Model 규칙:**

- 파일명: `[model_name]_model.dart`
- 필요시 `json_annotation`을 사용하여 직렬화 지원
- 불변 클래스로 구현

**Use Cases 규칙:**

- 파일명: `[action]_use_case.dart`
- 단일 비즈니스 로직을 캡슐화
- Repository와 Provider들을 조합하여 복잡한 로직 처리

**Repository 규칙:**

- API 호출과 데이터 처리를 담당
- Retrofit을 사용한 API 클라이언트 구현
- Provider로 등록하여 의존성 주입

**Provider 규칙:**

- 파일명: `[service_name]_provider.dart`
- 서비스 클래스는 `[Service]` suffix 사용
- 순수한 기능만 담당 (상태 관리는 Application Layer에서)

### Presentation Layer

UI 컴포넌트를 관리합니다.

**Screen 규칙:**

- 파일명: `[screen_name]_screen.dart`
- 필요에 따라 명확하게 `StatelessWidget`, `HookConsumerWidget` `HookWidget` 을 구분하여 사용
- ViewModel이 필요할시 해당하는 ViewModel을 연결하여 상태 관리

**Widget 규칙:**

- 재사용 가능한 컴포넌트는 `widgets/` 폴더에 배치
- 특정 feature에서만 사용되는 위젯은 해당 feature 내부에 배치

## 3. Shared Layer (`lib/shared/`)

### 디렉토리 구조

```
shared/
├── exports.dart              # 공통 export 관리
├── constant.dart             # 전역 상수
├── data/                     # 공통 데이터 모델
│   ├── base_use_case.dart    # UseCase 베이스 클래스
│   ├── result.dart           # Result 타입
│   ├── response_model.dart   # API 응답 모델
│   ├── paging_model.dart     # 페이징 모델
│   └── api_error_codes.dart  # API 에러 코드
├── extensions/               # 확장 메서드
│   ├── build_context_extension.dart
│   ├── color_extension.dart
│   ├── color_theme_extension.dart
│   ├── date_time_extension.dart
│   ├── text_theme_extension.dart
│   └── widget_extension.dart
├── hooks/                    # 커스텀 훅
│   ├── use_mount_effect.dart
│   └── use_image_picker_controller.dart
├── providers/                # 전역 Provider
│   ├── dio_provider.dart
│   ├── go_router_provider.dart
│   ├── haptic_provider.dart
│   ├── package_info_provider.dart
│   ├── preference_provider.dart
│   ├── secure_storage_provider.dart
│   └── theme_provider.dart
├── template/                 # 공통 UI 컴포넌트 (C-prefix)
│   ├── c_scaffold.dart
│   ├── c_elevated_button.dart
│   ├── c_outline_button.dart
│   ├── c_scale_button.dart
│   ├── c_bottom_sheet.dart
│   ├── c_dialog.dart
│   ├── c_snack_bar.dart
│   ├── c_loading_widget.dart
│   ├── c_error_widget.dart
│   ├── c_paged_list_view.dart
│   └── ... (기타 컴포넌트)
├── utils/                    # 유틸리티 함수
│   ├── link.dart             # URL/링크 처리
│   ├── logger.dart           # 로깅
│   ├── regex.dart            # 정규표현식
│   └── validation.dart       # 유효성 검증
└── widgets/                  # 공통 위젯
    ├── loading_button.dart
    ├── section_card.dart
    ├── user_profile_image.dart
    └── user_nickname.dart
```

### Data Layer

공통으로 사용되는 데이터 구조와 베이스 클래스를 제공합니다.

**BaseUseCase:**

```dart
// shared/data/base_use_case.dart
abstract class BaseUseCase<T, P> {
  Future<Result<T>> call(P params);
}
```

**Result 타입:**

```dart
// shared/data/result.dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
```

### Extensions

Flutter/Dart의 기본 타입을 확장하여 편의 기능을 제공합니다.

**BuildContext Extension:**

```dart
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(/*...*/);
  }
}
```

**DateTime Extension:**

```dart
extension DateTimeExtension on DateTime {
  String toFormattedString() => /*...*/;
  bool isToday() => /*...*/;
}
```

### Hooks

`flutter_hooks`를 사용한 커스텀 훅을 제공합니다.

**useMountEffect:**

```dart
// 컴포넌트 마운트 시 한 번만 실행
void useMountEffect(VoidCallback effect) {
  useEffect(() {
    effect();
    return null;
  }, const []);
}
```

### Providers

앱 전역에서 사용되는 Provider들을 관리합니다.

**Dio Provider:**

```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: Config.API_V1));
  // 인터셉터 설정
  return dio;
});
```

**SecureStorage Provider:**

```dart
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});
```

### Template 컴포넌트

앱 전체에서 일관된 디자인을 제공하는 공통 UI 컴포넌트입니다.

**규칙:**

- **네이밍**: `C` prefix 사용 (예: `CScaffold`, `CElevatedButton`)
- **목적**: 앱 전체에서 일관된 디자인 시스템 제공
- **사용법**: 기본 Flutter 위젯을 래핑하여 커스텀 스타일 적용

**예시:**

```dart
// CScaffold
class CScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? bottomNavigationBar;

  const CScaffold({
    required this.body,
    this.title,
    this.bottomNavigationBar,
  });
}

// CElevatedButton
class CElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CElevatedButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });
}
```

### Utils

공통 유틸리티 함수와 헬퍼 클래스를 제공합니다.

**Link Utility:**

```dart
// shared/utils/link.dart
class Link {
  // 범용 링크 열기 (전화, 문자, 웹, 내부 라우팅)
  static Future<void> open(String url) async {/*...*/}

  // 웹 URL 전용 (보안 중요)
  static Future<void> openWeb(String url) async {/*...*/}
}
```

**Logger:**

```dart
// shared/utils/logger.dart
final logger = Logger();

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

**Validation:**

```dart
// shared/utils/validation.dart
class Validation {
  static bool isEmail(String value) => /*...*/;
  static bool isPhoneNumber(String value) => /*...*/;
  static bool isPassword(String value) => /*...*/;
}
```

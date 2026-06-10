# Architecture Overview 🏗️

Life App의 전체 아키텍처 개요와 기본 설계 원칙을 설명합니다.

## 📋 기본 원칙

- **YAGNI 원칙**: 불필요하게 당장 사용하지 않는 코드는 구현하지 않습니다.
- **디렉토리 구조 준수**: 프로젝트의 아키텍처를 명확하게 파악하여 준수합니다.
- **역할 분리**: View / State / ViewModel의 역할을 명확하게 인지하여 코드를 구현합니다.
- **캡슐화**: 하나의 파일 내부에서만 사용되는 class, method는 private하게 구현합니다.
  (단, 코드가 너무 길어질시에는 파일을 분리하여 관리합니다.)
- **일관성**: 기존에 작성된 코드들의 규칙을 최대한 따릅니다.
- **재사용**: 새로 생성하는 파일에서는 shared 파일 내 공통 파일들을 최대한 활용합니다.

## 🏗️ 프로젝트 아키텍처

### 전체 구조

```
lib/
├── core/                     # 앱 핵심 설정
├── features/                 # 기능별 모듈
├── shared/                   # 공통 리소스
└── main.dart                # 앱 진입점
```

### Feature-based Architecture

각 기능(feature)은 독립적인 모듈로 구성되며, Clean Architecture 패턴을 따릅니다.

```
features/
└── [feature_name]/
    ├── domain/               # 비즈니스 로직 & 데이터 모델
    │   ├── models/           # 데이터 모델
    │   ├── use_cases/        # 비즈니스 로직
    │   └── [service]_provider.dart # 외부 의존성
    ├── application/          # 상태 관리
    │   ├── [feature]_state.dart
    │   ├── [feature]_state.g.dart
    │   └── [feature]_view_model_provider.dart
    ├── presentation/         # UI 레이어
    │   ├── screens/
    │   └── widgets/
    └── [feature]_routes.dart # 라우팅 정의
```

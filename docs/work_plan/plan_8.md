# Issue #8 - 설정 화면 (My 탭)

## 이슈 요약

> My 탭의 설정 화면에서 앱 테마·햅틱 설정, 공지사항·문의하기(웹뷰), 앱 버전 및 법적 고지를 관리할 수 있다.

---

## 전체 플로우

```
My 탭 진입
  └─ MyScreen (섹션별 설정 목록)
      ├─ [설정] 섹션
      │    ├─ "화면 테마" 탭 → ThemeModeSettingScreen (기존)
      │    └─ "햅틱(진동)" 토글 → 즉시 on/off (별도 화면 없음)
      ├─ [정보] 섹션
      │    ├─ "앱 버전" → 텍스트 표시만 (탭 없음)
      │    ├─ "공지사항" 탭 → WebView 화면 (공지 URL)
      │    └─ "문의하기" 탭 → WebView 화면 (구글 폼 URL)
      └─ [법적 고지] 섹션
           ├─ "이용약관" 탭 → WebView 화면
           ├─ "개인정보처리방침" 탭 → WebView 화면
           └─ "오픈소스 라이선스" 탭 → Flutter 내장 LicensePage
```

---

## UI 상세 명세

### MyScreen

**레이아웃**
- `CScaffold` 없이 탭 화면으로 직접 구성 (현재 방식 유지)
- 섹션 헤더 텍스트 + `CListTile` 목록으로 구성
- 섹션 간 간격으로 시각적 구분

**[설정] 섹션**
- "화면 테마" — `CListTile.arrow()`, 탭 시 ThemeModeSettingScreen으로 push
- "햅틱(진동)" — `CListTile.switchToggle()`, 현재 햅틱 상태 반영 / 즉시 저장

**[정보] 섹션**
- "공지사항" — `CListTile.arrow()`, 탭 시 WebView 화면 push (공지 URL)
- "문의하기" — `CListTile.arrow()`, 탭 시 WebView 화면 push (구글 폼 URL)
- "앱 버전" — `CListTile.custom()`, trailing에 버전 문자열 텍스트 (예: `v1.0.0`)

**[법적 고지] 섹션**
- "이용약관" — `CListTile.arrow()`, WebView 화면 push
- "개인정보처리방침" — `CListTile.arrow()`, WebView 화면 push
- "오픈소스 라이선스" — `CListTile.arrow()`, Flutter 내장 `LicensePage` push

### CWebViewScreen (신규 공통 컴포넌트)

- `CScaffold` 기반, title은 파라미터로 전달
- body에 `WebViewWidget` (webview_flutter 패키지)
- 로딩 중 `CLoadingWidget` 오버레이
- URL은 라우트 파라미터로 전달

---

## 관련 파일

**기존 파일 (수정)**
- `lib/features/my/presentation/screens/my_screen.dart` — 섹션 구조 개편, 햅틱 토글·정보·법적 고지 섹션 추가
- `lib/shared/providers/haptic_provider.dart` — 햅틱 on/off 상태를 watch 가능한 AsyncNotifier 추가
- `lib/core/routes.dart` — WebView 라우트, LicensePage 라우트 추가

**신규 파일 (생성)**
- `lib/shared/template/c_web_view_screen.dart` — 공통 WebView 화면
- `lib/shared/providers/package_info_provider.dart` — 앱 버전 Provider

**패키지 추가 필요 (사용자 승인 필요)**
- `webview_flutter` — WebView 구현
- `package_info_plus` — 앱 버전 조회

---

## Phase 구성 원칙

각 Phase는 반드시 독립적으로 커밋 가능한 상태여야 한다.

- Phase 완료 시점에 `flutter analyze` 오류 0개
- 미래 Phase에서 구현할 함수·클래스를 참조하는 코드는 해당 Phase에 포함 금지

---

## 작업 단계

### Phase 1: MyScreen 섹션 구조 개편 + 햅틱 설정 토글

**목표:** MyScreen을 섹션 구조로 개편하고 햅틱 on/off 토글을 추가한다. 패키지 추가 없이 기존 인프라만 사용.

**사전 작업:**
- `hapticProvider`는 현재 `Provider<HapticService>`로 write 전용. 햅틱 설정값을 `watch`하려면 상태 감시용 `AsyncNotifierProvider`가 필요.
- `themeProvider` 패턴 참고하여 `hapticStateProvider` 추가.

**작업 파일:**

- `lib/shared/providers/haptic_provider.dart` — `hapticStateProvider` (AsyncNotifier, bool) 추가
- `lib/features/my/presentation/screens/my_screen.dart` — 섹션 구조로 개편, 햅틱 토글 추가

**완료 조건:**

- [ ] MyScreen에 [설정] 섹션 헤더 + "화면 테마" + "햅틱(진동)" 타일 표시
- [ ] 햅틱 토글이 현재 저장값 반영
- [ ] 햅틱 토글 변경 시 shared_preferences에 즉시 저장
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: My 탭 설정 섹션 구조 개편 및 햅틱 토글 추가 (#8)`

---

### Phase 2: 앱 버전 표시

**목표:** 앱 버전을 [정보] 섹션에 표시한다.

**사전 작업:**
- `package_info_plus` 패키지 추가 (사용자 승인 후 진행)

**작업 파일:**

- `lib/shared/providers/package_info_provider.dart` — `packageInfoProvider` (FutureProvider) 생성
- `lib/features/my/presentation/screens/my_screen.dart` — [정보] 섹션 + 앱 버전 타일 추가

**완료 조건:**

- [ ] [정보] 섹션 헤더 표시
- [ ] "앱 버전" 타일 trailing에 `v{버전명}` 텍스트 표시
- [ ] 버전 로딩 중 `-` 또는 빈 문자열 표시
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 앱 버전 표시 추가 (#8)`

---

### Phase 3: WebView 공통 화면 + 공지사항·문의하기·약관·개인정보 연결

**목표:** 공통 WebView 화면을 만들고 공지사항·문의하기·이용약관·개인정보처리방침 항목을 연결한다.

**사전 작업:**
- `webview_flutter` 패키지 추가 (사용자 승인 후 진행)
- 각 URL(공지사항, 구글 폼, 이용약관, 개인정보처리방침) 확정 필요

**작업 파일:**

- `lib/shared/template/c_web_view_screen.dart` — 공통 WebView 화면 (title, url 파라미터)
- `lib/core/routes.dart` — `/webview` 라우트 추가 (title, url 쿼리 파라미터)
- `lib/features/my/presentation/screens/my_screen.dart` — 공지사항·문의하기·이용약관·개인정보처리방침 타일 추가 및 WebView 라우트 연결

**완료 조건:**

- [ ] CWebViewScreen이 title, url 파라미터를 받아 WebView 렌더링
- [ ] 로딩 중 로딩 인디케이터 표시
- [ ] 공지사항·문의하기·이용약관·개인정보처리방침 타일 탭 시 WebView 화면으로 이동
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: WebView 공통 화면 및 정보·법적 고지 항목 연결 (#8)`

---

### Phase 4: 오픈소스 라이선스 표기

**목표:** Flutter 내장 LicensePage를 활용해 오픈소스 라이선스 항목을 추가한다. 별도 패키지 불필요.

**작업 파일:**

- `lib/core/routes.dart` — `/licenses` 라우트 추가 (LicensePage 연결)
- `lib/features/my/presentation/screens/my_screen.dart` — "오픈소스 라이선스" 타일 추가

**완료 조건:**

- [ ] "오픈소스 라이선스" 타일 탭 시 LicensePage로 이동
- [ ] 패키지별 라이선스 목록 정상 표시
- [ ] flutter analyze 오류 없음

**커밋 메시지 제안:** `feat: 오픈소스 라이선스 페이지 추가 (#8)`

---

## 주의사항

- **패키지 추가 전 반드시 사용자 승인**: `webview_flutter`, `package_info_plus` 두 패키지 모두 작업 전 승인 필요
- **URL 확정 필요**: Phase 3 시작 전 공지사항·구글 폼·이용약관·개인정보처리방침 URL을 사전에 확정해야 함. 개인정보처리방침은 정적 웹페이지(별도 준비)가 필요하므로 앱 심사 전에 미리 준비 권장.
- **햅틱 Provider 수정 시 기존 HapticService 인터페이스 유지**: `hapticStateProvider`를 추가할 뿐, 기존 `hapticProvider` (HapticService)는 변경하지 않음
- **MyScreen은 탭 화면이므로 CScaffold 미사용**: AppBar 없이 Column 기반으로 구성

## 작업 시작 전 체크리스트

- [ ] docs/architecture/ 문서 숙지 완료
- [ ] 관련 기존 코드 파악 완료 (my_screen, theme_provider, haptic_provider, preference_provider)
- [ ] Phase 3 시작 전 URL 목록 사용자에게 확인
- [ ] 패키지 추가 전 사용자 승인 완료

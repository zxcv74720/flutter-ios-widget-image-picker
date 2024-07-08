# Image iOS Widget

이 프로젝트는 Flutter를 사용하여 개발된 iOS 앱으로, 사용자가 갤러리에서 이미지를 선택하고 이를 iOS 위젯의 배경으로 설정할 수 있게 해줍니다.

## 주요 기능

- 갤러리에서 여러 이미지 선택
- 선택한 이미지를 그리드 뷰로 표시
- 선택한 이미지를 iOS 위젯의 배경으로 설정
- 현재 위젯 이미지 표시

| ![image1](/readme_asset/clip_1.gif) | ![image2](/readme_asset/clip_2.gif) | ![image3](/readme_asset/clip_3.gif) |
| --- | --- | --- |


## 사용 라이브러리 (Flutter)

- `flutter_widgetkit: ^1.0.3`
- `image_picker: ^1.1.2`
- `path_provider: ^2.1.3`

## 참고 자료

- [YouTube Tutorial](https://www.youtube.com/watch?v=NoTc1D26HAo)

## 오류 해결: Xcode의 빌드 순환 의존성 오류 해결하기

### 오류 내용

```dart
Error (Xcode): Cycle inside Runner; building could produce unreliable results.
Cycle details:
→ Target 'Runner' has copy command from '[경로]/build/ios/Debug-iphonesimulator/ImageWidgetExtension.appex' to '[경로]/build/ios/Debug-iphonesimulator/Runner.app/PlugIns/ImageWidgetExtension.appex'
○ That command depends on command in Target 'Runner': script phase “Thin Binary”
○ Target 'Runner' has process command with output '[경로]/build/ios/Debug-iphonesimulator/Runner.app/Info.plist'
○ Target 'Runner' has copy command from '[경로]/build/ios/Debug-iphonesimulator/ImageWidgetExtension.appex' to '[경로]/build/ios/Debug-iphonesimulator/Runner.app/PlugIns/ImageWidgetExtension.appex'

```

- 해결 방법: Flutter 프로젝트의 iOS 폴더에서 Xcode를 실행하여 `Runner > Build Phases` 로 넘어가 Embed Foundation Extensions의 순서를 Embed Frameworks 위로 옮겨주면 해결된다.

![image4](/readme_asset/error_resolution_1.png)
![image5](/readme_asset/error_resolution_2.png)
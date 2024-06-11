# 📨 WaveEcho(파도메아리)

<picture>![lslpapplogo_125](https://github.com/jieun0330/WaveEcho/assets/42729069/b0cd7fc4-f4d4-42e9-a57e-7a2368125cef)</picture>

### 소중한 메시지를 담은 쪽지를 바다 위로 띄워 다른 사람들과 쪽지를 전달하며 소통할 수 있는 앱
* `유저 관리` 회원가입 / 로그인 / 로그아웃 / 회원탈퇴
* `게시글 및 댓글` 게시글 작성 및 삭제 / 댓글 생성 및 삭제
* `거래 기능` 게시글 작성 횟수 결제 / 결제 내역 조회

<br/>

## ⚒️ 스크린샷
![Group 517167395](https://github.com/jieun0330/WaveEcho/assets/42729069/56c5b6ab-b59f-439e-bffc-8fe018705ac6)


<br/>

## 🪚 시연 영상

#### 유저 관리
| 회원가입 | 로그인 | 로그아웃 | 회원탈퇴 |
|:---:|:---:|:---:|:---:|
|<picture>![회원가입](https://github.com/jieun0330/WaveEcho/assets/42729069/7d1b2a84-5311-40b7-b451-86cf12daf8e0)</picture>|<picture>![로그인](https://github.com/jieun0330/WaveEcho/assets/42729069/9a0760cb-1a3f-4f03-a72f-304266104736)</picture>|<picture>![로그아웃](https://github.com/jieun0330/WaveEcho/assets/42729069/dc65cdfb-9901-41a5-b3aa-4f05009ca4ef)</picture>|<picture>![회원탈퇴](https://github.com/jieun0330/WaveEcho/assets/42729069/36797a87-652a-4ff0-a168-c8552610eeb7)</picture>



#### 게시글 및 댓글 관리
| 게시글 작성 | 게시글 조회 | 게시글 삭제 | 댓글 작성 |
|:---:|:---:|:---:|:---:|
|<picture>![포스트작성](https://github.com/jieun0330/WaveEcho/assets/42729069/0550ed94-8b07-47ed-bc9f-58406e30c642)</picture>|<picture>![포스트조회](https://github.com/jieun0330/WaveEcho/assets/42729069/e6f6d92d-7c79-47b7-bc71-467558d2634d)</picture>|<picture>![게시글 삭제](https://github.com/jieun0330/WaveEcho/assets/42729069/2422abfc-5a92-46ef-b336-c3159aaf7961)</picture>|<picture>![댓글 작성](https://github.com/jieun0330/WaveEcho/assets/42729069/d48527d3-2b40-41cb-aeb0-17e1ea38944c)</picture>

#### 결제 관리
| 결제 버튼 클릭 | 결제 | 결제 완료 | 결제 내역 조회 |
|:---:|:---:|:---:|:---:|
|<picture>![결제 버튼 클릭](https://github.com/jieun0330/WaveEcho/assets/42729069/d70a879f-1190-4a33-939d-4ddc43f3a4db)</picture>|<picture>![결제](https://github.com/jieun0330/WaveEcho/assets/42729069/52089dc7-fb23-4d31-9b57-781aad4fc246)</picture>|<picture>![결제완료](https://github.com/jieun0330/WaveEcho/assets/42729069/7a892873-933c-4826-b508-3e8f215c685b)</picture>|<picture>![결제 내역](https://github.com/jieun0330/WaveEcho/assets/42729069/2598ef4d-be06-46b0-ad82-fbdf3469ba2e)</picture>



<br/>

## 🔨 개발기간
2024년 4월 10일 ~ 5월 5일 (약 3주, 업데이트 진행중)

<br/>

## ⚙️ 앱 개발 환경
- 최소 버전: iOS 17.4
- iPhone SE ~ iPhone 15 Pro Max 기기 대응

<br/>

## 🛠️ 사용기술 및 라이브러리
`UIKit(Code Base)` `MVVM` `RxSwift` `SnapKit` `Kingfisher` `Alamofire` `Toast`

<br/>

## 🔧 구현 고려사항
- `RxSwift`를 활용하여 비동기 데이터 스트림 관리
- `RxSwift Single`및 `TargetType` 프로토콜을 사용하여 네트워크 요청 로직 구성
- `Alamofire interceptor`를 사용하여 JWT 토큰 기반 회원 인증 기능 구현
- UI 업데이트를 위해 `Driver`를 활용하여 메인 스레드에서 안전하게 작업이 이루어지도록 보장
- PG 결제 시스템 연동 및 영수증 검증 처리
- `Multipart Form Data` 형식으로 이미지를 서버에 업로드
- `deinit`을 통해 `ViewController`가 제대로 해제되는지 확인하여 메모리 누수 방지
- 입력`Input`과 출력`Output` 구조체를 사용하여 코드의 모듈화와 가독성 향상
- 새로운 API 호출 유형이나 에러 케이스가 추가될 경우, `APIError`와 `CallType`에 대한 처리 로직을 쉽게 확장할 수 있도록 설계
- 공통 기능을 `BaseViewController`에 정의하여, 중복 코드를 줄이고 코드의 재사용성을 높임


<br/>



## ⛏️ Trouble Shooting

**❌ 문제 상황**
<br/>

댓글 작성 후 화면 전환시 댓글 업데이트 문제

**⭕️ 해결 방법**
- `protocol`을 사용하여 댓글 데이터 전달
- 댓글 작성이 완료되었을 때 `delegate`를 통해 데이터 업데이트


```swift
// ReplyViewController
protocol fetchComment: AnyObject {
    func fetchDone(data: CommentData)
}

final class ReplyViewController: BaseViewController {
    
    weak var delegate: fetchComment?
```

```swift
// PopupViewController
extension PopupViewController: fetchComment {
    func fetchDone(data: CommentData) {
        var value = behaviorModel.value
        value.comments.insert(data, at: 0)
        behaviorModel.accept(value)
    }
}
```
<br/>


**❌ 문제 상황**
<br/>

이미지 용량 압축 작업을 하지 않아 이미지 업로드 실패

**⭕️ 해결 방법**
- UIImage에는 jpeg Data로 바꾸어주는 메소드가 있어서 한 줄의 코드로 변경 가능
- compressionQuality에는 압축률을 전달




```swift
extension WritePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    let realImage = image as? UIImage
                    let imagePng = realImage?.jpegData(compressionQuality: 0.3)
                    self.imageData.accept(imagePng!)
                    self.mainView.presentPhotoView.image = image as? UIImage
                }
            }
        }
    }
}
```
<br/>

**❌ 문제 상황: 에러 응답 코드 흐름 이해**
<br/>
서버로부터 받는 응답코드 419와 418의 처리 방식을 이해하는 것이 어려웠다.
<br/>
419 상태 코드를 만났을 때, 418 상태 코드를 만나지 않고는 접할 수 없다는 점이었다.

**⭕️ 해결 방법**
- 먼저, 419와 418 응답 코드의 처리방법을 명확히 이해
- APIManager에 리프레시 토큰 만료(418) 상태를 처리할 수 있는  `RefreshToken interceptor` 로직 구현
- 로그아웃 과정을 사용자에게 알리기 위해 `MyPostViewController`에서 로그아웃 알림과 함께 화면 전환 로직 구현

```swift
// MyPostViewController
private lazy var logout = UIAction(title: "로그아웃",
                                       image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                       handler: { [weak self] _ in
        guard let self else { return }
        makeAlert(alertTitle: "로그아웃 하시겠습니까?", alertMessage: nil) { [weak self] completeAction in
            guard let self else { return }
            view.makeToast("로그아웃되었습니다", duration: 1, position: .center) { [weak self] didTap in
                guard let self else { return }
                UserDefaultsManager.shared.accessToken.removeAll()
                setVC(vc: LoginViewController())
            }
        }
    })
```


<br/>

## 🔧 추후 업데이트 사항

- [ ] UserDefaults enum 활용 리팩토링
- [ ] cell 속성 리팩토링
- [ ] 메모리 누수 확인

<br/>

## 👏🏻 회고
프로젝트를 시작하기 전까지, 응답 코드에 대한 처리, Router enum 활용, HTTP 메서드 뿐 아니라 리프레시 토큰의 만료와 갱신 관리까지 이렇게 많은 부분을 한 번에 다루어야 하는 경험은 전무했다. 이 모든 부분을 어디서 어떻게 시작해야 할지 막막했다. 하지만 이 프로젝트를 통해 실제로 서버 요청을 보내고 받아보며 서비스를 확장해 나가는 과정은 좋은 경험이었다.
서버 통신을 구현하며, 각 HTTP 메서드(GET, POST 등)의 사용법을 익혔고, REST API 설계 원칙에 대해 이해할 수 있었다.
특히 이번 프로젝트에서 처음으로 리프레시 토큰 개념에 대해 깨달았다. 액세스 토큰이 만료되었을 때 어떻게 토큰을 갱신할 수 있을지에 대한 고민은 프로젝트를 통해 해결해 나가는 큰 도전이었다. 이 과정에서, 토큰 갱신 로직을 구현하고, 이를 프로젝트의 다른 부분과 통합하는 방법을 배웠다.

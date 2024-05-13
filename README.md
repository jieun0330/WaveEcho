# 📨 WaveEcho

<picture>![lslpapplogo_125](https://github.com/jieun0330/WaveEcho/assets/42729069/b0cd7fc4-f4d4-42e9-a57e-7a2368125cef)</picture>

### 소중한 메시지를 담은 쪽지를 바다 위로 띄워 다른 사람들과 쪽지를 전달하며 소통할 수 있는 앱
* `유저 관리` 회원가입 / 로그인 / 로그아웃 / 회원탈퇴
* `게시글 및 댓글` 게시글 작성 및 삭제 / 댓글 생성 및 삭제
* `거래 기능` 게시글 작성 횟수 결제

<br/>

#### 유저 관리
| 회원가입 | 로그인 | 로그아웃 | 회원탈퇴 |
|:---:|:---:|:---:|:---:|
|<picture>![회원가입](https://github.com/jieun0330/WaveEcho/assets/42729069/7d1b2a84-5311-40b7-b451-86cf12daf8e0)</picture>|<picture>![로그인](https://github.com/jieun0330/WaveEcho/assets/42729069/9a0760cb-1a3f-4f03-a72f-304266104736)</picture>|<picture>![로그아웃](https://github.com/jieun0330/WaveEcho/assets/42729069/dc65cdfb-9901-41a5-b3aa-4f05009ca4ef)</picture>|<picture>![회원탈퇴](https://github.com/jieun0330/WaveEcho/assets/42729069/e2b45c27-3655-4141-94f7-e8c828c69c82)</picture>



#### 게시글 및 댓글 관리
| 게시글 작성 | 게시글 조회 | 게시글 삭제 | 댓글 작성 |
|:---:|:---:|:---:|:---:|
|<picture>![포스트작성](https://github.com/jieun0330/WaveEcho/assets/42729069/0550ed94-8b07-47ed-bc9f-58406e30c642)</picture>|<picture>![포스트조회](https://github.com/jieun0330/WaveEcho/assets/42729069/e6f6d92d-7c79-47b7-bc71-467558d2634d)</picture>|<picture>![게시글 삭제](https://github.com/jieun0330/WaveEcho/assets/42729069/2422abfc-5a92-46ef-b336-c3159aaf7961)</picture>|<picture>![댓글 작성](https://github.com/jieun0330/WaveEcho/assets/42729069/d48527d3-2b40-41cb-aeb0-17e1ea38944c)</picture>

#### 결제 관리
| 결제 | 결제 완료 | ? | ? |
|:---:|:---:|:---:|:---:|
|<picture>![결제](https://github.com/jieun0330/WaveEcho/assets/42729069/04c42818-5946-4a83-b9ab-de1e698c2880)</picture>|<picture>![결제완료](https://github.com/jieun0330/WaveEcho/assets/42729069/7a892873-933c-4826-b508-3e8f215c685b)</picture>|<picture>![결제](https://github.com/jieun0330/WaveEcho/assets/42729069/04c42818-5946-4a83-b9ab-de1e698c2880)</picture>|<picture>![결제완료](https://github.com/jieun0330/WaveEcho/assets/42729069/7a892873-933c-4826-b508-3e8f215c685b)</picture>


<br/>

## 🔨 개발기간
2024년 4월 10일 ~ 5월 5일 (약 3주, 업데이트 진행중)

<br/>

## 🛠️ 사용기술 및 라이브러리
* `UIKit(Code Base)` `MVVM` `RxSwift` `SnapKit` `Kingfisher` 
* `Alamofire` `Toast`

<br/>

## ⛏️ Trouble Shooting

**❌ 문제 상황**: 이미지 용량 압축 작업을 하지 않아 이미지 업로드 실패

**⭕️ 해결 방법**
1. UIImage에는 jpeg Data로 바로 바꾸어주는 메소드가 있어서 한 줄의 코드로 변경 가능
2. compressionQuality에는 압축률을 전달

<details>
<summary>Code</summary>

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

//
//  BaseViewController.swift
//  WaveEcho
//
//  Created by 박지은 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    func configureView() { }
    func bind() { }
    
    func errorHandler(apiError: APIError, calltype: APIError.CallType) {
        switch calltype {
            
        case .signup:
            switch apiError {
            case .code400:
                makeAlert(message: "필수값을 채워주세요")
//                makeAlert(message: "필수값을 채워주세요", completionHandler: { _ in
//                     
//                })
            case .code409:
                makeAlert(message: "이미 가입한 유저입니다")
//                makeAlert(message: "이미 가입한 유저입니다", completionHandler: { _ in
//                    
//                })
            default:
                return
            }
            
        case .validEmail:
            switch apiError {
            case .code400:
                makeAlert(message: "이메일을 입력해주세요")
//                makeAlert(message: "이메일을 입력해주세요", completionHandler: { _ in
//                    
//                })
            case .code409:
                makeAlert(message: "사용이 불가한 이메일입니다")
//                makeAlert(message: "사용이 불가한 이메일입니다", completionHandler: { _ in
//                    
//                })
            default:
                return
            }

        case .login:
            switch apiError {
            case .code400:
                makeAlert(message: "이메일 혹은 비밀번호를 올바르게 입력해주세요")
//                makeAlert(message: "이메일 혹은 비밀번호를 올바르게 입력해주세요", completionHandler: { _ in
//                    
//                })
            case .code401:
                makeAlert(message: "가입되지 않았거나 비밀번호가 틀렸습니다")
//                makeAlert(message: "가입되지 않았거나 비밀번호가 틀렸습니다", completionHandler: { _ in
//                    
//                })
            default:
                return
            }
            
        case .createPosts:
            switch apiError {
            case .code401:
                makeAlert(message: "인증할 수 없는 액세스 토큰입니다")
//                makeAlert(message: "인증할 수 없는 액세스 토큰입니다", completionHandler: { _ in
//                    
//                })
            case .code403:
                makeAlert(message: "접근권한이 없습니다")
//                makeAlert(message: "접근권한이 없습니다", completionHandler: { _ in
//                    
//                })
            case .code410:
                makeAlert(message: "게시글이 저장되지 않았습니다")
//                makeAlert(message: "게시글이 저장되지 않았습니다", completionHandler: { _ in
//                    
//                })
            case .code419:
                makeAlert(message: "액세스 토큰이 만료되었습니다")
//                makeAlert(message: "액세스 토큰이 만료되었습니다", completionHandler: { _ in
//                    
//                })
            default:
                return
            }
            
        case .fetchPost:
            switch apiError {
            case .code400:
                makeAlert(message: "잘못된 요청")
//                makeAlert(message: "잘못된 요청", completionHandler: { _ in
//                    
//                })
            case .code401:
                makeAlert(message: "인증할 수 없는 액세스 토큰")
//                makeAlert(message: "인증할 수 없는 액세스 토큰", completionHandler: { _ in
//                    
//                })
            case .code403:
                makeAlert(message: "접근권한이 없습니다")
//                makeAlert(message: "접근권한이 없습니다", completionHandler: { _ in
//                    
//                })
            case .code419:
                makeAlert(message: "액세스 토큰이 만료되었습니다")
//                makeAlert(message: "액세스 토큰이 만료되었습니다", completionHandler: { _ in
//                    
//                })
            default:
                return
            }
        case .refreshToken:
            switch apiError {
            case .code401:
                makeAlert(message: "인증할 수 없는 토큰입니다")
//                makeAlert(message: "인증할 수 없는 토큰입니다", completionHandler: { _ in
//                    
//                })
            case .code403:
                makeAlert(message: "접근권한이 없습니다")
//                makeAlert(message: "접근권한이 없습니다", completionHandler: { _ in
//                    
//                })
            case .code418:
                makeAlert(message: "리프레시 토큰이 만료되었습니다")
//                makeAlert(message: "리프레시 토큰이 만료되었습니다", completionHandler: { _ in
//                    print("여기도 안들어오나 😀")
//                })
            default:
                return
            }
        }
    }

//    func makeAlert(message: String, completionHandler: @escaping ((UIAlertAction) -> Void)) {
//        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
//        let ok = UIAlertAction(title: "OK", style: .cancel)
//        alert.addAction(ok)
//        present(alert, animated: true)
//    }
    
    func makeAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }

}

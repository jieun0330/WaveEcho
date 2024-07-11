//
//  ErrorHandler.swift
//  WaveEcho
//
//  Created by 박지은 on 7/11/24.
//

import Foundation

struct ErrorHandler {
    
    func errorHandler(apiError: APIError, calltype: APIError.CallType) -> String {
        switch calltype {
            
        case .signup:
            switch apiError {
            case .code400:
                return "필수값을 채워주세요"
            case .code409:
                return "이미 가입한 유저입니다"
            default:
                return ""
            }
            
        case .validEmail:
            switch apiError {
            case .code400:
                return "이메일을 입력해주세요"
            case .code409:
                return "사용이 불가한 이메일입니다"
            default:
                return ""
            }

        case .login:
            switch apiError {
            case .code400:
                return "이메일 혹은 비밀번호를 올바르게 입력해주세요"
            case .code401:
                return "가입되지 않았거나 비밀번호가 틀렸습니다"
            default:
                return ""
            }
            
        case .withdraw:
            switch apiError {
            case .code401:
                return "인증할 수 없는 액세스 토큰입니다"
            case .code403:
                return "Forbidden"
            case .code419:
                return "액세스 토큰이 만료되었습니다"
            default:
                return ""
            }
            
        case .createPosts:
            switch apiError {
            case .code401:
                return "인증할 수 없는 액세스 토큰입니다"
            case .code403:
                return "접근권한이 없습니다"
            case .code410:
                return "게시글이 저장되지 않았습니다"
            case .code419:
                return "로그아웃 되었습니다"
            default:
                return ""
            }
            
        case .fetchPost:
            switch apiError {
            case .code400:
                return "잘못된 요청"
            case .code401:
                return "인증할 수 없는 액세스 토큰"
            case .code403:
                return "접근권한이 없습니다"
            case .code419:
                return "액세스 토큰이 만료되었습니다"
            default:
                return ""
            }
            
        case .refreshToken:
            switch apiError {
            case .code401:
                return "인증할 수 없는 토큰입니다"
            case .code403:
                return "접근권한이 없습니다"
            case .code418:
                return "리프레시 토큰이 만료되었습니다"
            default:
                return ""
            }
            
        case .editMyProfile:
            switch apiError {
            case .code400:
                return "잘못된 요청입니다"
            case .code401:
                return "인증할 수 없는 액세스 토큰입니다"
            case .code403:
                return "접근권한이 없습니다"
            case .code419:
                return "액세스 토큰이 만료되었습니다"
            default:
                return ""
            }
            
        case .writeComment:
            switch apiError {
            case .code400:
                return "필수값이 누락되었습니다"
            case .code401:
                return "인증할 수 없는 액세스 토큰입니다"
            case .code403:
                return "Forbidden"
            case .code410:
                return "댓글을 생성할 게시글을 찾을 수 없습니다"
            case .code419:
                return "액세스 토큰이 만료되었습니다"
            default:
                return ""
            }
        case .paymentValidation:
            switch apiError {
            case .code400:
                return "유효하지 않은 결제건입니다"
            case .code401:
                return "인증할 수 없는 액세스 토큰입니다"
            case .code403:
                return "Forbidden"
            case .code409:
                return "검증처리가 완료된 결제건입니다"
            case .code410:
                return "게시글을 찾을 수 없습니다"
            case .code419:
                return "액세스 토큰이 만료되었습니다"
            default:
                return ""
            }
        }
    }
}

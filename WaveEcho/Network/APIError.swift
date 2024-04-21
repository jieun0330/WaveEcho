//
//  APIError.swift
//  WaveEcho
//
//  Created by 박지은 on 4/20/24.
//

import Foundation

enum APIError: Int, Error {
    
    // 성공
    case success = 200
    
    // 공통 응답코드
    case code420 = 420 // 새싹key가 없거나 틀렸을 경우
    case code429 = 429 // 서버 과호출 시
    case code444 = 444 // 비정상 URL
    case code500 = 500 // 비정상 요청
    
    // 개별 응답코드
    case code400 = 400 // 필수 값 누락
    case code401 = 401 // 계정 재확인 필요 (미가입이거나 비밀번호 불일치)
    case code403 = 403 // Forbidden, 접근권한❌
    case code409 = 409 // 사용 불가 이메일
    case code410 = 410 // DB서버 장애로 게시글이 저장❌
    case code418 = 418 // 리프레시 토큰 만료
    case code419 = 419 // 액세스 토큰 만료 -> 토큰 갱신 필요
    case code445 = 445 // 게시글 수정 권한, 본인만 수정 가능
    
    enum CallType {
        case login
    }
}

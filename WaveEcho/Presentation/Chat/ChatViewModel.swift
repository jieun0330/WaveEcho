//
//  ChatViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
//        input.viewDidLoad
//            .flatMap { _ in
//                return APIManager.shared.create(type: ChatModel.self, router: ChatRouter.makeChatRoom(query: <#T##ChatRequest#>))
//            }
        
        return Output()
    }
}

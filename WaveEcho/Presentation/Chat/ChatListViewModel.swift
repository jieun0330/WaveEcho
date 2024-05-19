//
//  ChatListViewModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatListViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let chatListSuccess: Driver<[ChatData]>
        let chatListError: Driver<APIError>
    }
    
    func transform(input: Input) -> Output {
        
        let chatListSuccess = PublishRelay<[ChatData]>()
        let chatListError = PublishRelay<APIError>()
        
        input.viewDidLoad
            .flatMap { _ in
                return APIManager.shared.create(type: ChatModel.self, router: ChatRouter.myChatList)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    chatListSuccess.accept(success.data)
                case .failure(let error):
                    chatListError.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(chatListSuccess: chatListSuccess.asDriver(onErrorJustReturn: [ChatData(room_id: "", createdAt: "", updatedAt: "", participants: [Participants(user_id: "", nick: "", profileImage: "")], lastChat: LastChat(chat_id: "", room_id: "", content: "", createdAt: "", sender: Participants(user_id: "", nick: "", profileImage: ""), files: [""]))]),
                      chatListError: chatListError.asDriver(onErrorJustReturn: .code500))
    }
}

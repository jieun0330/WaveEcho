//
//  ViewModelType.swift
//  WaveEcho
//
//  Created by 박지은 on 4/11/24
//

import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

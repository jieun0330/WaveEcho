//
//  UIImage.swift
//  WaveEcho
//
//  Created by 박지은 on 7/11/24.
//

import UIKit

// 용량: 5MB 제한
extension UIImage {
    
    func imageZipLimit(zipRate: Double) -> Data? {
        // 1MB
        let limitBytes = zipRate * 1024 * 1024
        var currentQuality: CGFloat = 0.7
        // jpeg 포맷으로 이미지 압축
        var imageData = self.jpegData(compressionQuality: currentQuality)
        
        while let data = imageData,
            Double(imageData!.count) > limitBytes && currentQuality > 0{
            print("현재 이미지 크기 :\(data.count)")
            currentQuality -= 0.1
            imageData = self.jpegData(compressionQuality: currentQuality)
            print("현재 압축중인 이미지 크기 :\(imageData?.count ?? 0)")
        }
        
        if let data = imageData,
            Double(data.count) <= limitBytes {
            print("압축 \(data.count) bytes, 압축률: \(currentQuality)")
            return data
            
        } else {
            print("초과")
            return nil
        }
    }
}

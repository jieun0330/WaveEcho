//
//  FileManager.swift
//  WaveEcho
//
//  Created by 박지은 on 7/11/24.
//

import Foundation

struct ImageFileManager {
    
    static let shared = ImageFileManager()
    
    let fileManager = FileManager.default
    
    func fileSave(_ file: Data) -> URL? {
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("프로필 이미지")
        
        // 파일이 이미 존재하는지 확인
        if fileManager.fileExists(atPath: fileURL.path) {
            // 파일이 존재하면 해당 URL 반환 ->
            return fileURL
        }
    
        do {
            try file.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }
    
}

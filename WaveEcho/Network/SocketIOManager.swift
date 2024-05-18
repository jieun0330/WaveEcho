//
//  SocketIOManager.swift
//  WaveEcho
//
//  Created by 박지은 on 5/19/24.
//

import Foundation
import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    var roomID: String!

    private init() {
        manager = SocketManager(socketURL: URL(string: APIKey.baseURL.rawValue + "/v1")!,
                                config: [.log(true), .compress])
        
        socket = manager.socket(forNamespace: roomID)
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected", data, ack)
        }
        
        socket.on("chat") { dataArray, ack in
            print("chat received", dataArray)
            
            do {
                if let data = dataArray.first {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    let decodedData = try JSONDecoder().decode(ChatModel.self, from: result)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func leaveConnection() {
        socket.disconnect()
    }
}

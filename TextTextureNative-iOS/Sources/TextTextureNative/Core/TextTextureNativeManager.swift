//
//  TextTextureNativeManager.swift
//  
//  
//  Created by fuziki on 2023/03/29
//  
//

import Foundation
import Metal
import MetalKit

struct MakeTextureConfig: Codable {
    let uuid: String
    let width: Int
    let height: Int
}

struct RenderConfig: Codable {
    let uuid: String
    let text: String
    let size: Float
    let color: String
    let scale: Float
}

public class TextTextureNativeManager {
    public static let shared = TextTextureNativeManager()
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    private var renderers: [String: TextTextureNativeRenderer] = [:]
    
    public func makeTexture(uuid: String, width: Int, height: Int) -> MTLTexture {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        descriptor.usage = .unknown
        let texture = device.makeTexture(descriptor: descriptor)!

        let renderer = TextTextureNativeRenderer(texture: texture)
        renderers[uuid] = renderer

        return texture
    }
    
    public func render(uuid: String, text: String, size: CGFloat, color: T2NColor, scale: CGFloat) {
        renderers[uuid]?.render(text: text, size: size, color: color, scale: scale)
    }
    
    public func makeTexture(config: String) -> MTLTexture {
        let config = try! JSONDecoder().decode(MakeTextureConfig.self, from: config.data(using: .utf8)!)
        return makeTexture(uuid: config.uuid, width: config.width, height: config.height)
    }
    
    public func render(config: String) {
        guard let data = config.data(using: .utf8),
              let config = try? JSONDecoder().decode(RenderConfig.self, from: data),
              let hex = Int(config.color, radix: 16) else {
            return
        }
        let r = CGFloat((hex & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((hex & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((hex & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(hex & 0x000000FF) / 255.0
        let color = T2NColor(red: r, green: g, blue: b, alpha: a)
        render(uuid: config.uuid, text: config.text, size: CGFloat(config.size), color: color, scale: CGFloat(config.scale))
    }
}

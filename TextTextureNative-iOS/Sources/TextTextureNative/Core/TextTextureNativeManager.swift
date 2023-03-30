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
    let scale: Int
}

struct RenderConfig: Codable {
    let uuid: String
    let text: String
    let size: Float
    let color: String
}

public class TextTextureNativeManager {
    public static let shared = TextTextureNativeManager()
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    private var renderers: [String: TextTextureNativeRenderer] = [:]
    
    public func makeTexture(uuid: String, width: Int, height: Int, scale: Int) -> MTLTexture {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm_srgb,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        descriptor.usage = .unknown
        let texture = device.makeTexture(descriptor: descriptor)!

        let renderer = TextTextureNativeRenderer(texture: texture, scale: CGFloat(scale))
        renderers[uuid] = renderer

        return texture
    }
    
    public func render(uuid: String, text: String, size: CGFloat, color: UIColor) {
        renderers[uuid]?.render(text: text, size: size, color: color)
    }
    
    public func makeTexture(config: String) -> MTLTexture {
        let config = try! JSONDecoder().decode(MakeTextureConfig.self, from: config.data(using: .utf8)!)
        return makeTexture(uuid: config.uuid, width: config.width, height: config.height, scale: config.scale)
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
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        render(uuid: config.uuid, text: config.text, size: CGFloat(config.size), color: color)
    }
}
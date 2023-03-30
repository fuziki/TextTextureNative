//
//  UnityInterface.swift
//  
//  
//  Created by fuziki on 2023/03/30
//  
//

import Foundation
import Metal
import MetalKit

@_cdecl("TextTextureNativeManager_addTwo")
public func TextTextureNativeManager_addTwo(_ src: Int64) -> Int64 {
    return src + 2
}

@_cdecl("TextTextureNativeManager_makeTexture")
public func TextTextureNativeManager_makeTexture(_ config: UnsafePointer<CChar>?) -> UnsafeMutableRawPointer {
    let texture = TextTextureNativeManager.shared.makeTexture(config: String(cString: config!))
    let ptr = Unmanaged.passUnretained(texture).toOpaque()
    return ptr
}

@_cdecl("TextTextureNativeManager_render")
public func TextTextureNativeManager_render(_ config: UnsafePointer<CChar>?) {
    guard let config else { return }
    TextTextureNativeManager.shared.render(config: String(cString: config))
}

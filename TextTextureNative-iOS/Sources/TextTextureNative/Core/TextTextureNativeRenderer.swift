//
//  TextTextureNativeRenderer.swift
//  
//  
//  Created by fuziki on 2023/03/30
//  
//

import Foundation
import Metal
import MetalKit

class TextTextureNativeRenderer {
    private let queue = DispatchQueue.main

    private let texture: MTLTexture
    private let scale: CGFloat
    private let label: UILabel

    init(texture: MTLTexture, scale: CGFloat) {
        self.texture = texture
        self.scale = scale
        label = UILabel(frame: .zero)
        label.layer.contentsScale = scale
        label.backgroundColor = .green
    }

    func render(text: String, size: CGFloat, color: UIColor) {
        label.text = text
        label.font = .systemFont(ofSize: size)
        label.textColor = color
        let frameSize = CGSize(width: CGFloat(texture.width) / scale, height: CGFloat(texture.height) / scale)
        let fitSize = label.sizeThatFits(frameSize)
        label.frame.size = fitSize
        let drawWidth = Int(fitSize.width * scale)
        let drawHeight = Int(fitSize.height * scale)

        queue.async { [weak self] in
            guard let self else { return }

            let start = Date()
            let cgc = CGContext(data: nil,
                                width: drawWidth, height: drawHeight,
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            cgc.scaleBy(x: self.scale, y: self.scale)
            self.label.layer.render(in: cgc)

            self.texture.replace(region: MTLRegionMake2D(0, 0, drawWidth, drawHeight),
                                 mipmapLevel: 0,
                                 withBytes: cgc.data!,
                                 bytesPerRow: cgc.bytesPerRow)

            print("render time: \(Date().timeIntervalSince(start) * 1000)ms")
        }
    }
}

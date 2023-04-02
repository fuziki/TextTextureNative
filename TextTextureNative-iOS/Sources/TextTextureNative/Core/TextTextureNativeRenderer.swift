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
    private let texture: MTLTexture
    private var previousFrameSize: CGSize?

    init(texture: MTLTexture) {
        self.texture = texture
    }

    func render(text: String, size: CGFloat, color: T2NColor, scale: CGFloat) {
        let maxFrameWidth = texture.width / Int(scale)
        let maxFrameHeight = texture.height / Int(scale)

        let attr: [NSAttributedString.Key : Any] = [
            .font: T2NFont.systemFont(ofSize: size),
            .foregroundColor: color
        ]
        let attributedString = NSAttributedString(string: text, attributes: attr)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let fitFrameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                        CFRange(),
                                                                        nil,
                                                                        CGSize(width: maxFrameWidth, height: maxFrameHeight),
                                                                        nil)

        let fixFrameSize: CGSize
        if let previousFrameSize {
            fixFrameSize = CGSize(width: max(fitFrameSize.width, previousFrameSize.width),
                                  height: max(fitFrameSize.height, previousFrameSize.height))
        } else {
            fixFrameSize = fitFrameSize
        }
        let drawWidth = min(Int(fixFrameSize.width * scale), texture.width)
        let drawHeight = min(Int(fixFrameSize.height * scale), texture.height)
        previousFrameSize = fitFrameSize

        let context = CGContext(data: nil,
                                width: drawWidth, height: drawHeight,
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        let mat = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: CGFloat(drawHeight))
        context.concatenate(mat)
        context.scaleBy(x: scale, y: scale)

        let bounds = CGRect(origin: .zero, size: fixFrameSize)
        let path = CGPath(rect: bounds, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), path, nil)
        CTFrameDraw(frame, context)

        texture.replace(region: MTLRegionMake2D(0, texture.height - drawHeight, drawWidth, drawHeight),
                        mipmapLevel: 0,
                        withBytes: context.data!,
                        bytesPerRow: context.bytesPerRow)
    }
}

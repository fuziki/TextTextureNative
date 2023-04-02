//
//  Compatible.swift
//  
//  
//  Created by fuziki on 2023/04/02
//  
//

#if os(iOS)
import UIKit
public typealias T2NColor = UIColor
public typealias T2NFont = UIFont
#else
import AppKit
public typealias T2NColor = NSColor
public typealias T2NFont = NSFont
#endif

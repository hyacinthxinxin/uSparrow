//
//  SparrowFileManager.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/1.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

class SparrowFileManager: NSObject {
    var wifiIsOn = false
    
    static let shared = SparrowFileManager()
    let reachability = Reachability()

    fileprivate var sparrowSystemDirectories = [String]()
    let rootDocumentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    override init() {
        super.init()
        let sparrowSystemLibraryPathUrl = rootDocumentsUrl.appendingPathComponent(Constants.DocumentName.SparrowLibrarySystem, isDirectory: true)
        sparrowSystemDirectories = [sparrowSystemLibraryPathUrl.lastPathComponent]
        createSparrowSystemDirectory(with: sparrowSystemLibraryPathUrl)
        if let reachability = self.reachability {
            do {
                try reachability.startNotifier()
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    fileprivate func createSparrowSystemDirectory(with url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            print("sparrow system directory do not exist")
            createSparrowLibrarySystemDirectory(with: url)
        } else {
            if !url.hasDirectoryPath {
                print("sparrow system is not a directory and it is exist")
                createSparrowLibrarySystemDirectory(with: url)
            } else {
                print("sparrow system is a directory and it is exist")
            }
        }
    }
    
    fileprivate func createSparrowLibrarySystemDirectory(with url: URL) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
            print("Create sparrow system directory success")
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    //
    func loadDocumentsData(with documentsUrl: URL) -> [Sparrow] {
        var sparrows = [Sparrow]()
        let fileManager = FileManager.default
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            sparrows = directoryContents.map {
                let sparrow = Sparrow(documentsUrl: $0)
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: $0.path, isDirectory:&isDir) {
                    if isDir.boolValue {
                        if sparrowSystemDirectories.contains($0.lastPathComponent) {
                            sparrow.type = SparrowType.uSystem
                        } else {
                            sparrow.type = SparrowType.uFold
                        }
                    } else {
                        sparrow.type = Sparrow.getSparrowType(with: $0.pathExtension)
                    }
                    sparrow.setTumbnailPhoto()
                }
                return sparrow
            }
        } catch let err {
            print(err.localizedDescription)
        }
        return sparrows
    }
    
    fileprivate var timestamp: String {
        return String(format:"%.0f", NSDate().timeIntervalSinceReferenceDate * 100000)
    }

    func saveFileToSparrowSystem(image: UIImage) {
        let sparrowSystemLibraryPathUrl = rootDocumentsUrl.appendingPathComponent(Constants.DocumentName.SparrowLibrarySystem, isDirectory: true)
        let timestampUrl = sparrowSystemLibraryPathUrl.appendingPathComponent("sparrow"+timestamp+".png")
        if FileManager.default.fileExists(atPath: sparrowSystemLibraryPathUrl.path) {
            if let data = UIImagePNGRepresentation(image) {
                FileManager.default.createFile(atPath: timestampUrl.path, contents: data, attributes: nil)
            }
        }
    }
    
}

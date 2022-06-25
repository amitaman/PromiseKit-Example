//
//  FileUtility.swift
//  LloydsAssignment
//
//  Created by Amit Aman on 23/05/22.
//

import Foundation
import UIKit

class FileManagerUtil {
    
    /// Save file to cache directory.
    /// - Parameters:
    ///   - named: String
    ///   - data: Data
    ///   - completion: (Error?) -> Void
     func saveFile(named: String, data: Data, completion: @escaping (Error?) -> Void) {
      guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(named+".png") else { return }

      DispatchQueue.global(qos: .background).async {
        do {
          try data.write(to: path)
          print("Saved image to: " + path.absoluteString)
          completion(nil)
        } catch {
          completion(error)
        }
      }
    }
    
    /// Get file from caches Directory.
    /// - Parameters:
    ///   - named: String
    ///   - completion: (UIImage?, Error?) -> Void
     func getFile(named: String, completion: @escaping (UIImage?, Error?) -> Void) {
      DispatchQueue.global(qos: .background).async {
        if let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(named+".png"),
          let data = try? Data(contentsOf: path),
          let image = UIImage(data: data) {
          DispatchQueue.main.async { completion(image, nil) }
        } else {
          let error = NSError(domain: "LloydsAssignment",
                              code: 0,
                              userInfo: [NSLocalizedDescriptionKey: "Image file '\(named)' not found."])
          DispatchQueue.main.async { completion(nil, error) }
        }
      }
    }
}

//
//  ImageCompressor.swift
//  TheMoment
//
//  Created by jyrnan on 2023/3/2.
//

import Foundation

import UIKit

struct ImageCompressor {
  static let maxByte: Int = 400000
  static func compress(image: UIImage, maxByte: Int,
                       completion: @escaping (UIImage?) -> ())
  {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
        return completion(nil)
      }
        
      var iterationImage: UIImage? = image
      var iterationImageSize = currentImageSize
      var iterationCompression: CGFloat = 1.0
        
      while iterationImageSize > maxByte, iterationCompression > 0.01 {
        let percentageDecrease = getPercentageToDecreaseTo(forDataCount: iterationImageSize)
            
        let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                height: image.size.height * iterationCompression)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: canvasSize))
        iterationImage = UIGraphicsGetImageFromCurrentImageContext()
            
        guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
          return completion(nil)
        }
        iterationImageSize = newImageSize
        iterationCompression -= percentageDecrease
      }
      completion(iterationImage)
    }
  }

  private static func getPercentageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
    switch dataCount {
    case 0..<5000000: return 0.03
    case 5000000..<10000000: return 0.1
    default: return 0.2
    }
  }
  
  static func getCompress(data: Data) async -> Data {
    let task = Task {
      guard data.count > maxByte else { return data }
        
      let image = UIImage(data: data)!
      let currentImageSize = data.count
          
      var iterationImage: UIImage? = image
      var iterationImageSize = currentImageSize
      var iterationCompression: CGFloat = 1.0
          
      while iterationImageSize > maxByte, iterationCompression > 0.01 {
        let percentageDecrease = getPercentageToDecreaseTo(forDataCount: iterationImageSize)
        
        let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                height: image.size.height * iterationCompression)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: canvasSize))
        iterationImage = UIGraphicsGetImageFromCurrentImageContext()
        
        guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
          return data
        }
        iterationImageSize = newImageSize
        iterationCompression -= percentageDecrease
      }
      return (iterationImage?.jpegData(compressionQuality: 1.0))!
    }
    return await task.value
  }
  
  static func getCompressBySize(data: Data) async -> Data {
    let task = Task {
        
      let image = UIImage(data: data)!
      guard image.size.height > 240 * 3  else { return data }
      
      let zoomRatio = 240 * 3 / image.size.height
          
      var iterationImage: UIImage? = image
          
        
        let canvasSize = CGSize(width: image.size.width * zoomRatio,
                                height: image.size.height * zoomRatio)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: canvasSize))
        iterationImage = UIGraphicsGetImageFromCurrentImageContext()
        
      return (iterationImage?.jpegData(compressionQuality: 1.0))!
    }
    return await task.value
  }
}

//
//  ExtensionManager.swift
//  GalleryDemoApp
//
//  Created by Aniket Patil on 24/01/23.
//

import Foundation
import UIKit

extension UIView{
    func setupShadowView() {
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 4.0
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
    }
}
extension UIImageView {
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
    
    func loadFrom(_ url: String) {
       guard let url = URL(string: url) else {
           return
       }
       
       DispatchQueue.main.async {
           [weak self] in
           if let imageData = try? Data(contentsOf: url) {
               if let loadedImage = UIImage(data: imageData) {
                   self?.image = loadedImage
               }
           }
       }
   }
}
extension Array {
    func removeDuplicate<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
    func split(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

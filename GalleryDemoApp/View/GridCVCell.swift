//
//  GridCVCell.swift
//  GalleryDemoApp
//
//  Created by Aniket Patil on 24/01/23.
//

import UIKit

class GridCVCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var GridView: UIView!
    @IBOutlet weak var ListView: UIView!
    @IBOutlet weak var gridStack: UIStackView!
    @IBOutlet weak var gridImg: UIImageView!
    @IBOutlet weak var gridUserName: UILabel!
    @IBOutlet weak var gridDesc: UILabel!
    @IBOutlet weak var listImg: UIImageView!
    @IBOutlet weak var listUserName: UILabel!
    @IBOutlet weak var listDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gridImg.layer.cornerRadius = 10
        gridStack.layer.cornerRadius = 10
        gridStack.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        mainView.setupShadowView()
    }

}

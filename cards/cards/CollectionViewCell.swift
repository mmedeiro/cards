//
//  CollectionViewCell.swift
//  cards
//
//  Created by Mariana Medeiro on 21/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var title = String()
    var color = UIColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var image = UIImage (named: "imagemAleatoria")
        image?.resizableImageWithCapInsets(UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0))
        
        self.layer.cornerRadius = self.frame.width

        
        self.nameLabel.text = self.title
        
    }
    
    func setTitle(){
        
        self.nameLabel.text = self.title
    }
    
    func setColor(){
        self.imageView.tintColor = self.color
    }
    
    
}

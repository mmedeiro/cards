//
//  ExposedLayout.swift
//  CardsCollection
//
//  Created by Felipe Marques Ramos on 21/05/15.
//  Copyright (c) 2015 Felipe Marques Ramos. All rights reserved.
//

import UIKit

class ExposedLayout: UICollectionViewLayout {
    
    var layoutMargin = UIEdgeInsetsMake(40.0, 0.0, 0.0, 0.0)
    var itemSize = CGSizeZero
    var TopOverLap:CGFloat = 20.0
    var BottomOverLap:CGFloat = 20.0
    var BottomLapCount = 1
    var exposedItemIndex = Int()
    var layoutAttributes = Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>()
    
    
    override func collectionViewContentSize() -> CGSize {
        var contentSize = self.collectionView!.bounds.size
        
        contentSize.height = contentSize.height - self.collectionView!.contentInset.top + self.collectionView!.contentInset.bottom
        
        return contentSize
    }
    
    override func prepareLayout() {
        var itemSize = self.itemSize
        
        if CGSizeEqualToSize(itemSize, CGSizeZero){
            let width = CGRectGetWidth(self.collectionView!.bounds) - self.layoutMargin.left - self.layoutMargin.right
            let height = CGRectGetHeight(self.collectionView!.bounds) - self.layoutMargin.top - self.layoutMargin.bottom - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
            
            itemSize = CGSizeMake(width, height)
        }
        
        var layoutAttributes = Dictionary<NSIndexPath,UICollectionViewLayoutAttributes>()
        var itemCount = self.collectionView?.numberOfItemsInSection(0)
        var bottomOverlapCount = self.BottomLapCount
        
        for var item = 0; item < itemCount; item=item+1{
            var index = NSIndexPath(forItem: item, inSection: 0)
            var att = UICollectionViewLayoutAttributes(forCellWithIndexPath: index)
            
            if item < self.exposedItemIndex{
                att.frame = CGRectMake(self.layoutMargin.left, self.layoutMargin.top - self.TopOverLap, itemSize.width, itemSize.height)
                if item < self.exposedItemIndex - 1 {
                    att.hidden = true
                }
            }
            else if item == self.exposedItemIndex{
                att.frame = CGRectMake(self.layoutMargin.left, self.layoutMargin.top, itemSize.width, itemSize.height)
            }
            else if item > self.exposedItemIndex + BottomLapCount{
                att.frame = CGRectMake(self.layoutMargin.left, self.collectionViewContentSize().height, itemSize.width, itemSize.height)
                att.hidden = true
            }
            else{
                var count = min(self.BottomLapCount + 1, itemCount! - self.exposedItemIndex) - (item - self.exposedItemIndex)
                
                
                var tops = self.layoutMargin.top + itemSize.height
                var bottons = CGFloat(count) * self.BottomOverLap
                
                att.frame = CGRectMake(self.layoutMargin.left, tops - bottons, itemSize.width, itemSize.height)
                
                if item == self.exposedItemIndex + bottomOverlapCount && att.frame.origin.y < self.collectionView!.bounds.size.height - self.layoutMargin.bottom{
                    
                    bottomOverlapCount = bottomOverlapCount + 1
                }
            }
            
            att.zIndex = item
            
            layoutAttributes[index] = att
        }
        
        self.layoutAttributes = layoutAttributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttributes = NSMutableArray()
        
        for item in self.layoutAttributes{
            var att = item.1
            if CGRectIntersectsRect(rect, att.frame){
                layoutAttributes.addObject(att)
            }
        }
        
        return layoutAttributes as [AnyObject]
        
    }
    
    override func  layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutAttributes[indexPath]
        
    }
}

//
//  StackedLayout.swift
//  cards
//
//  Created by Mariana Medeiro on 20/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import UIKit

class StackedLayout: UICollectionViewLayout {
    
    var layoutMargin = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    var itemSize = CGSizeZero
    var topReveal: CGFloat = 120.0
    var bounceFactor: CGFloat = 0.2
    var fillHeight = false
    var alwaysBounce = false
    var overwriteContentOffset = false
    var filling = false
    var contentOffset = CGPoint()
    var movingIndexPath = NSIndexPath()
    var layoutAttributes = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        
        if self.overwriteContentOffset {
            return self.contentOffset
        }
        return proposedContentOffset
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        var tops = self.topReveal * CGFloat(self.collectionView!.numberOfItemsInSection(0))
        
        var contentSize = CGSizeMake(CGRectGetWidth(self.collectionView!.bounds), self.layoutMargin.top + tops + self.layoutMargin.bottom - self.collectionView!.contentInset.bottom)
        
        
        return contentSize
    }
    
    override func prepareLayout() {
        self.collectionViewContentSize()
        
        var itemReveal: CGFloat = self.topReveal
        
        if self.filling {
            
            var size = CGRectGetHeight(self.collectionView!.bounds) - self.layoutMargin.top - self.layoutMargin.bottom - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
            itemReveal = floor(size / CGFloat(self.collectionView!.numberOfItemsInSection(0)))
        }
            if CGSizeEqualToSize(itemSize, CGSizeZero) {
                
                itemSize = CGSizeMake(CGRectGetWidth(self.collectionView!.bounds) - self.layoutMargin.left - self.layoutMargin.right, CGRectGetHeight(self.collectionView!.bounds) - self.layoutMargin.top - self.layoutMargin.bottom - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom)
                
            }
            
            var contentOffset = CGPoint()
            
            if overwriteContentOffset {
                contentOffset = self.contentOffset
            }
            else {
                contentOffset = self.collectionView!.contentOffset
            }
            
            
            var layoutAttributes = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
            var previousTopOverlappingAttributes = Array<UICollectionViewLayoutAttributes>()
            var itemCount = self.collectionView!.numberOfItemsInSection(0)
            
            
            var firstCompressingItem = -1
            
            for var item = 0; item < itemCount; item = item+1 {
                
                var indexPath = NSIndexPath(forItem: item, inSection: 0)
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                attributes.zIndex = item
                
                var loc = itemReveal * CGFloat(item)
                attributes.frame = CGRectMake(self.layoutMargin.left, self.layoutMargin.top + loc, itemSize.width, itemSize.height)
                
                if contentOffset.y + self.collectionView!.contentInset.top < 0.0 {
                    var frame: CGRect = attributes.frame
                    var offseto = contentOffset.y + self.collectionView!.contentInset.top
                    
                    frame.origin.y = frame.origin.y - (self.bounceFactor * offseto * CGFloat(item))
                    attributes.frame = frame
                    
                }
 //                   else if (CGRectGetMinY(attributes.frame) < contentOffset.y + self.layoutMargin.top) {
//                    var frame: CGRect = attributes.frame
//                    
//                    frame.origin.y = contentOffset.y + self.layoutMargin.top
//                    attributes.frame = frame
//                    
//                    previousTopOverlappingAttributes[1].hidden = true
//                    previousTopOverlappingAttributes[1] = previousTopOverlappingAttributes[0]
//                    previousTopOverlappingAttributes[0] = attributes
//                }
                    
                else if self.collectionViewContentSize().height > CGRectGetHeight(self.collectionView!.bounds) && contentOffset.y > self.collectionViewContentSize().height - CGRectGetHeight(self.collectionView!.bounds) {
                    if (firstCompressingItem < 0) {
                        firstCompressingItem = item
                    } else {
                        var frame: CGRect = attributes.frame
                        var delta: CGFloat = contentOffset.y + CGRectGetHeight(self.collectionView!.bounds) - self.collectionViewContentSize().height
                        frame.origin.y = frame.origin.y + self.bounceFactor * delta * CGFloat (firstCompressingItem - (item))
                        frame.origin.y = max(frame.origin.y, contentOffset.y + self.layoutMargin.top)
                        
                        attributes.frame = frame
                        
                    }
                    
                } else {
                   
                    firstCompressingItem = -1
                }
                
                layoutAttributes[indexPath] = attributes
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
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutAttributes[indexPath]
    }
}






//
//  ViewController.swift
//  cards
//
//  Created by Mariana Medeiro on 20/05/15.
//  Copyright (c) 2015 Mariana Medeiro. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var cards = Array<String>()
    var exposedLayoutMargin = UIEdgeInsetsMake(40.0, 0.0, 0.0, 0.0)
    var exposedItemSize = CGSizeZero
    var exposedTopOverlap:CGFloat = 20.0
    var exposedBottonOverlap:CGFloat = 20.0
    var exposedBottonOverlapCount = 1
    

    var auxIndex: NSIndexPath?
    var unexposedItemsAreSelectable = false
    
    var stackedLayout = StackedLayout()
    var stackedContentOffSet = CGPoint()
    
    var exposedIndexPath: NSIndexPath? {
        get {
            return auxIndex
        }
        set(newVal) {
            self.setExposedItemIndexPath(newVal)
        }
    }

    
    func setExposedItemIndexPath(exposedItemIndexPath: NSIndexPath?){
    
        if (exposedIndexPath == nil) {
            
            self.collectionView?.selectItemAtIndexPath(exposedIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.None)
            
            if self.collectionView?.collectionViewLayout == self.stackedLayout {
                self.stackedContentOffSet = self.collectionView!.contentOffset
                
            }
            
            var exposedLayout = ExposedLayout()
            exposedLayout.exposedItemIndex = exposedItemIndexPath!.item
            
            exposedLayout.layoutMargin = self.exposedLayoutMargin
            exposedLayout.itemSize = self.exposedItemSize
            exposedLayout.TopOverLap = self.exposedTopOverlap
            exposedLayout.BottomOverLap = self.exposedBottonOverlap
            exposedLayout.BottomLapCount = self.exposedBottonOverlapCount
            
            self.collectionView!.setCollectionViewLayout(exposedLayout, animated: true)
            
        }
            
        else {
            self.collectionView?.deselectItemAtIndexPath(self.exposedIndexPath, animated: true)
            
            self.stackedLayout.overwriteContentOffset = true
           // self.stackedLayout.contentOffset = self.stackedContentOffSet
            
            self.collectionView?.setCollectionViewLayout(stackedLayout, animated: true)
            self.stackedLayout.overwriteContentOffset = false
        }
        self.auxIndex = exposedItemIndexPath
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards = ["card1", "card2", "card3", "card4",  "card5", "card6", "card7", "card8", "card9"]
        self.collectionView?.collectionViewLayout = self.stackedLayout
       
    }
    
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("cardcell", forIndexPath: indexPath) as! UICollectionViewCell
        var color = [UIColor.redColor(), UIColor.purpleColor(), UIColor.yellowColor(), UIColor.blueColor()]
        
        cell.backgroundColor = color[Int(arc4random_uniform(4))]
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.isEqual(self.exposedIndexPath) {
            self.exposedIndexPath = nil
        } else if self.exposedIndexPath == nil{
            self.exposedIndexPath = indexPath
        }
        
    }
}


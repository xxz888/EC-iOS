//
//  MCWalletLayout.m
//  MCOEM
//
//  Created by wza on 2020/6/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCWalletLayout.h"
#import "MCWalletCollectionViewCell.h"

@interface MCWalletLayout ()

@property(nonatomic, assign) CGFloat itemHeight;
@property(nonatomic, assign) CGFloat hideFactor;
@property(nonatomic, assign) CGFloat springFactor;
@property(nonatomic, assign) UIEdgeInsets sectionInsets;
@property(nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *> *layoutAttrs;
@property(nonatomic, assign) int expandIndexItem;

@end




@implementation MCWalletLayout



- (NSMutableArray<UICollectionViewLayoutAttributes *> *)computeLayoutAttrs {
    NSIndexPath *indexPath = [NSIndexPath new];
    NSMutableArray<UICollectionViewLayoutAttributes *> *attrs = [NSMutableArray new];
    int itemsCount = (int)[self.collectionView numberOfItemsInSection:0];
    
    for (int currentIndex = 0; currentIndex < itemsCount; currentIndex++) {
        self.expandIndexItem = -1;
        MCWalletCollectionViewCell *cell = (MCWalletCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
        if (cell && cell.isExpand) {
            self.expandIndexItem = currentIndex;
            break;
        }
    }
    
    for (int currentIndex = 0; currentIndex < itemsCount; currentIndex++) {
        self.collectionView.scrollEnabled = YES;
        indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        CGFloat y = self.itemHeight * currentIndex * (1 - self.hideFactor);
        CGFloat offsetY = self.collectionView.contentOffset.y + self.sectionInsets.top;
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(0, MAX(offsetY, y), self.collectionView.bounds.size.width - self.sectionInsets.left - self.sectionInsets.right, self.itemHeight);
        
        if (self.expandIndexItem != -1) {// 展开
            self.collectionView.scrollEnabled = NO;
            if (currentIndex > self.expandIndexItem) {
                int shrinkItemsCount = itemsCount - self.expandIndexItem - 1;
                CGFloat space = 0;
                if (shrinkItemsCount >= 5) {
                    space = self.itemHeight * (1 - self.hideFactor) / 5.0;
                } else {
                    space = self.itemHeight * (1 - self.hideFactor) / shrinkItemsCount;
                }
                int shrinkIndex = currentIndex - self.expandIndexItem - 1;
                
                CGFloat tmpY = offsetY - self.sectionInsets.top + self.collectionView.bounds.size.height - self.itemHeight * (1 - self.hideFactor) + space * shrinkIndex;
                attr.frame = CGRectMake(attr.frame.origin.x, tmpY, attr.frame.size.width, attr.frame.size.height);
            } else {
                attr.frame = CGRectMake(attr.frame.origin.x, offsetY, attr.frame.size.width, attr.frame.size.height);
                MCLog(@"%d要展开",currentIndex);
            }
        } else {// 收拢
            self.collectionView.scrollEnabled = YES;
            if (offsetY < 0) {
                CGFloat tmpY = y - fabs(offsetY) + fabs(offsetY) * self.springFactor * attr.indexPath.item;
                attr.frame = CGRectMake(attr.frame.origin.x, tmpY, attr.frame.size.width, attr.frame.size.height);
            }
        }
        
        attr.zIndex = currentIndex;
        [attrs addObject:attr];
    }
    return attrs;
}

#pragma mark - override
- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemHeight = 332;
    self.hideFactor = 0.75;
    self.springFactor = 0.2;
    self.sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView.contentInset = self.sectionInsets;
    self.layoutAttrs = [self computeLayoutAttrs];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttrs[indexPath.row];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttrs;
}

- (CGSize)collectionViewContentSize {
    int itemsCount = (int)[self.collectionView numberOfItemsInSection:0];
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width - self.sectionInsets.left - self.sectionInsets.right, self.itemHeight * (itemsCount - 1) * (1 - self.hideFactor) + self.itemHeight);
    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}


@end

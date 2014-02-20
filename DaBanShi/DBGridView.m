//
//  DBGridView.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBGridView.h"
#import "DBGridViewCell.h"
#import "DBGridCellModel.h"

const static float marginBig        = 5.f;
const static float marginSmall      = 2.5f;
const static float cellWidth        = 155.f;
const static float cellHeightBig    = 155.f;
const static float cellHeightSmall  = 75.f;
const static float leftOrign        = 2.5f;
const static float rightOrign       = 162.5f;

@interface DBGridView () <UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray *cells;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic) float leftHeight;
@property (nonatomic) float rightHeight;

@end

@implementation DBGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithContents:(NSArray *)contents
{
    CGRect bounds = [[[[UIApplication sharedApplication] delegate] window] bounds];
    self = [self initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 49)];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        CGRect adRect = CGRectMake(marginSmall, marginBig, cellWidth * 2 + marginBig, cellHeightBig);
        UIView *adView = [[UIView alloc] initWithFrame:adRect];
        adRect.origin.x = 0;
        adRect.origin.y = 0;
        UIScrollView *adScrollView = [[UIScrollView alloc] initWithFrame:adRect];
        adScrollView.backgroundColor = [UIColor lightGrayColor];
        adScrollView.pagingEnabled = YES;
        adScrollView.showsHorizontalScrollIndicator = NO;
        adScrollView.delegate = self;
        
        UIView *ad1 = [[UIView alloc] initWithFrame:adRect];
        UILabel *label1 = [[UILabel alloc] initWithFrame:adRect];
        label1.textAlignment = DBTextAlignCenter;
        label1.text = @"广告位1";
        [ad1 addSubview:label1];
        
        adRect.origin.x += adRect.size.width;
        UIView *ad2 = [[UIView alloc] initWithFrame:adRect];
        UILabel *label2 = [[UILabel alloc] initWithFrame:ad1.frame];
        label2.textAlignment = DBTextAlignCenter;
        label2.text = @"广告位2";
        [ad2 addSubview:label2];
        
        adRect.origin.x += adRect.size.width;
        UIView *ad3 = [[UIView alloc] initWithFrame:adRect];
        UILabel *label3 = [[UILabel alloc] initWithFrame:ad1.frame];
        label3.textAlignment = DBTextAlignCenter;
        label3.text = @"广告位3";
        [ad3 addSubview:label3];
        
        UIPageControl *pc = [[UIPageControl alloc] init];
        pc.numberOfPages = 3;
        pc.center = CGPointMake(adScrollView.center.x, adView.frame.size.height - 15);
        self.pageControl = pc;
        
        [adScrollView addSubview:ad1];
        [adScrollView addSubview:ad2];
        [adScrollView addSubview:ad3];
        adScrollView.contentSize = CGSizeMake(ad3.frame.origin.x + ad3.frame.size.width, ad3.frame.size.height);
        [adView addSubview:adScrollView];
        [adView addSubview:pc];
        [self addSubview:adView];
        
        _cells = [NSMutableArray array];
        if (contents != nil) {
            int count = contents.count;
            int i;
            for (i = 0; i < count; i++) {
                DBGridCellModel *model = [contents objectAtIndex:i];
                DBGridViewCell *cell = [[DBGridViewCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth,  model.cellType == DBGridCellTypeSamll ? cellHeightSmall : cellHeightBig)];
                cell.titleLabel.text = model.cellTitle;
                cell.detailLabel.text = model.cellDetail;
                cell.imageView.image = [UIImage imageNamed:model.imageName];
                cell.backgroundColor = [UIColor lightGrayColor];
                [self.cells addObject:cell];
                [self addSubview:cell];
            }
        }
        
        self.leftHeight = adView.frame.origin.y + adView.frame.size.height;
        self.rightHeight = self.leftHeight;
        
        for (DBGridViewCell *cell in self.cells) {
            CGRect rect = cell.frame;
            rect.origin.x = self.leftHeight <= self.rightHeight ? leftOrign : rightOrign;
            if (self.leftHeight > self.rightHeight) {
                rect.origin.y = self.rightHeight + marginBig;
                self.rightHeight = rect.origin.y + rect.size.height;
            } else {
                rect.origin.y = self.leftHeight + marginBig;
                self.leftHeight = rect.origin.y + rect.size.height;
            }
            cell.frame = rect;
        }
        self.contentSize = CGSizeMake(self.frame.size.width, MAX(self.leftHeight, self.rightHeight) + 1);
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = lroundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.pageControl.currentPage = currentPage;
}

@end

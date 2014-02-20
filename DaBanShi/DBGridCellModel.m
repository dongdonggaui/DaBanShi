//
//  DBGridCellModel.m
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import "DBGridCellModel.h"

@implementation DBGridCellModel

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail imageName:(NSString *)imageName highlightedImangeName:(NSString *)highlightedImageName
{
    self = [super init];
    if (self) {
        self.cellTitle = title;
        self.cellDetail = detail;
        self.imageName = imageName;
        self.highlightedImageName = highlightedImageName;
    }
    
    return self;
}

@end

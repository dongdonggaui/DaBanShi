//
//  DBGridCellModel.h
//  DaBanShi
//
//  Created by huangluyang on 14-2-20.
//  Copyright (c) 2014年 huangluyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DBGridCellTypeSamll,
    DBGridCellTypeBig
} DBGridCellType;

@interface DBGridCellModel : NSObject

@property (nonatomic) DBGridCellType cellType;
@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic, strong) NSString *cellDetail;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *highlightedImageName;

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail imageName:(NSString *)imageName highlightedImangeName:(NSString *)highlightedImageName;

@end

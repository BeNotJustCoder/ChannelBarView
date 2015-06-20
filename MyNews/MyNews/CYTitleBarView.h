//
//  CYTitleBarView.h
//  20150613_01_Test
//
//  Created by lincy on 15/6/19.
//  Copyright (c) 2015年 lincy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYTitleBarView : UIView

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UIColor *normalColor; //被选中的标题的颜色
@property (nonatomic, strong) UIColor *selectedColor; //被选中的标题的颜色

+ (instancetype)titleBarViewWithTitles:(NSArray *)titles selected:(void (^)(NSString *item))selectedBlock;
- (instancetype)initWithTitles:(NSArray *)titles selected:(void (^)(NSString *item))selectedBlock;
@end

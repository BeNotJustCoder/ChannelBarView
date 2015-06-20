//
//  CYTitleBarView.m
//  20150613_01_Test
//
//  Created by lincy on 15/6/19.
//  Copyright (c) 2015年 lincy. All rights reserved.
//

#import "CYTitleBarView.h"

@interface CYTitleBarView () <UIScrollViewDelegate>

@property (copy, nonatomic) void (^selectedBlock)(NSString *);

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *indicatorView;

@property (nonatomic, weak) UIButton *curItem;
@property (nonatomic, copy) NSArray *items;

@property (assign, nonatomic) CGFloat itemMargin;
@property (assign, nonatomic) CGFloat indicatorX;
@property (assign, nonatomic) CGFloat indicatorH;
@property (assign, nonatomic) CGFloat indicatorW;

@end

@implementation CYTitleBarView

#pragma mark - 对外方法
+ (instancetype)titleBarViewWithTitles:(NSArray *)titles selected:(void (^)(NSString *))selectedBlock {
    return [[self alloc]initWithTitles:titles selected:selectedBlock];
}

- (instancetype)initWithTitles:(NSArray *)titles selected:(void (^)(NSString *))selectedBlock {
    if (self = [super init]) {
        //默认外观设置
        self.itemMargin = 8;
        self.indicatorH = 2;
        self.selectedColor = [UIColor orangeColor];
        self.normalColor = [UIColor whiteColor];
        self.titles = titles;
        self.selectedBlock = selectedBlock;
        [self setupScrollView];
    }
    return self;
}


#pragma mark - 内部设置
- (void)setupScrollView {
    
    //设置scrollView
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints  = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:0 views:@{@"scrollView":self.scrollView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:0 views:@{@"scrollView":self.scrollView}]];
    
    [self layoutIfNeeded];
    self.scrollView.delegate = self;
    
}

- (void)setTitles:(NSArray *)titles {
    NSMutableArray *btns = [NSMutableArray array];
    UIButton *preBtn = nil;
    for (NSString *title in titles) {
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateSelected];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:btn];
        [btns addObject:btn];
        
        //为每个btn添加约束
        if (preBtn) {
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preBtn attribute:NSLayoutAttributeRight multiplier:1 constant:self.itemMargin]];
        }
        else {
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.itemMargin]];
        }
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        preBtn = btn;
    }
    
    _items = btns.copy;
    
}

- (void)itemSelected:(UIButton *)item {
    self.curItem.selected = NO;
    item.selected = YES;
    self.curItem = item;
    
    [self setNeedsLayout];
    
    if (self.selectedBlock) {
        self.selectedBlock(item.titleLabel.text);
    }
}

- (void)didMoveToSuperview {
    
    [self itemSelected:self.items.firstObject];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.items.lastObject frame]) + self.itemMargin, 0);
    NSLog(@"didMoveToSuperview");
}

- (void)layoutSubviews {
    
    CGFloat x = self.curItem.frame.origin.x - self.scrollView.contentOffset.x;
    self.indicatorW = self.curItem.frame.size.width;
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.frame = CGRectMake(x, self.frame.size.height - self.indicatorH, self.indicatorW, self.indicatorH);
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = self.curItem.frame.origin.x - self.scrollView.contentOffset.x;
    self.indicatorView.frame = CGRectMake(x, self.frame.size.height - self.indicatorH, self.indicatorW, self.indicatorH);
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor grayColor];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc]init];
        _indicatorView.backgroundColor = self.selectedColor;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

@end

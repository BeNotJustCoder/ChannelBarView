//
//  ViewController.m
//  MyNews
//
//  Created by lincy on 15/6/20.
//  Copyright (c) 2015年 lincy. All rights reserved.
//

#import "ViewController.h"
#import "CYTitleBarView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //因为ios7后如果带navigationBar的Controller添加scrollView的话，scrollView的inset的y值会自动+64为了实现穿透效果，所以用下面的设置取消自动调整scroll的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *titles = @[@"要闻",@"财经",@"社会",@"体育",@"军事",@"娱乐圈",@"互联网",@"科技",@"美女",@"搞笑",@"世界地理",@"我的爱好设置"];
    CYTitleBarView *tView = [CYTitleBarView titleBarViewWithTitles:titles selected:^(NSString *item) {
        self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        self.titleLabel.text = item;
    }];
    tView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 44);
    tView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:tView];
}



@end

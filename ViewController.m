//
//  ViewController.m
//  ZHLabelView
//
//  Created by zzh_iPhone on 16/4/12.
//  Copyright © 2016年 zzh_iPhone. All rights reserved.
//

#import "ViewController.h"
#import "ZHLbView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //方便实现ZHLbView的展示
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor redColor];
    button.frame=CGRectMake(0, 0, 600, 20);
    [self.view addSubview:button];
    NSArray *tagAryCount=@[@"10",@"8",@"7",@"9",@"2",@"4",@"5",@"3",@"4"];
    NSArray* tagAryName = @[@"黑色玫瑰",@"比尔沃吉特",@"钢铁烈阳",@"德玛西亚",@"祖安",@"巨神峰",@"雷瑟守备祖安",@"诺克萨斯暗影岛",@"弗雷尔卓德"];
    
    
    
    //计算出全部展示的高度,让maxHeight等于计算出的高度即可,初始化不需要设置高度
    ZHLbView * tagsView = [[ZHLbView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 0)];
    [tagsView setTagAryName:tagAryName aryCount:tagAryCount delegate:self];
    [self.view addSubview:tagsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

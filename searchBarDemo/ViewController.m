//
//  ViewController.m
//  searchBarDemo
//
//  Created by zhuchenglong on 16/7/5.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"
#import "BViewController.h"


@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"多线程+for循环遍历" style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"数据库" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

-(void)leftClick{
    
    AViewController *avc = [AViewController new];
    [self.navigationController pushViewController:avc animated:YES];
}
-(void)rightClick{
    
    BViewController *avc = [BViewController new];
    [self.navigationController pushViewController:avc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  GWPickerView
//
//  Created by 魏郭文 on 16/7/25.
//  Copyright © 2016年 魏郭文. All rights reserved.
//

#import "ViewController.h"
#import "GWPickerView.h"

@interface ViewController ()<GWPickerViewDelegate>
{
    GWPickerView * picker;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];
    NSArray * arr = @[@"sanmao",@"ermao",@"ergou"];
    picker = [[GWPickerView alloc] initWithData:nil title:@"3344" type:(GWPickerViewTypeAddress)] ;
    picker.delegate = self;
}

- (void)pickViewSureBtnSelectData:(NSString *)data
{
    NSLog(@"%@",data);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [picker show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

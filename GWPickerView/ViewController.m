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
@property (nonatomic,strong) UILabel * label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 200, 50)];
    [self.view addSubview:_label];

    picker = [[GWPickerView alloc] initWithData:@[@"jjj",@"lll",@"iii"] title:@"3344" type:(GWPickerViewTypeAddress) color:nil] ;
    picker.delegate = self;
    
    __weak typeof (self) weakSelf = self;
    picker.dateBlock = ^(NSString * data){
        weakSelf.label.text = data;
    };
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

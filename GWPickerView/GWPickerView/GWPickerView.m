//
//  PickerView.m
//  PickerView
//
//  Created by 魏郭文 on 16/7/23.
//  Copyright © 2016年 魏郭文. All rights reserved.
//

#import "GWPickerView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
/**
 *  pickerView的宽的
 */
#define kViewWidth (ScreenWidth * 0.8)
/**
 *  pickerView的高度
 */
#define kViewHeight (ScreenHeight * 0.3)
/**
 *  pickview的颜色
 */
#define kPickViewColor [UIColor blackColor]

@interface GWPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray * _temData;
    NSString * _tempTitle;
    UIView * _backView;
}
@property (nonatomic,strong) UIPickerView * pView;
@property (nonatomic,strong) UIWindow * window;

@end

@implementation GWPickerView

- (instancetype)initWithData:(NSArray *)data title:(NSString *)title
{
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _temData = data;
        _tempTitle = title;
        [self addView];
    }
    return self;
}

- (void)addView
{
    //底视图
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
    _backView.center = self.center;
    _backView.layer.cornerRadius = 10;
    _backView.layer.masksToBounds = YES;
    _backView.alpha = 0;
    _backView.backgroundColor = kPickViewColor;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self addSubview:_backView];
    
    //标题
    UILabel * titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight / 5)];
    titleLbl.text = _tempTitle;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.layer.borderColor = [[UIColor whiteColor] CGColor];
    titleLbl.layer.borderWidth = 1.f;
    titleLbl.textAlignment = UITextAlignmentCenter;
    [_backView addSubview:titleLbl];
    
    //pickerView
    self.pView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kViewHeight / 5, kViewWidth, kViewHeight/5 * 3)];
    self.pView.backgroundColor = [UIColor whiteColor];
    self.pView.delegate = self;
    self.pView.dataSource = self;
    [_backView addSubview:self.pView];
    
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,kViewHeight / 5 * 4, kViewWidth/2 - 0.1, kViewHeight/5)];
    [sureBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_backView addSubview:sureBtn];
    
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kViewWidth/2, kViewHeight / 5 * 4, kViewWidth/2, kViewHeight/5)];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_backView addSubview:cancelBtn];
}

/**
 *  出现，消失的事件
 */
- (void)show
{
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        _backView.alpha = 0.8;
    }];
}

- (void)dissmiss
{
    [UIView animateWithDuration:0.5 animations:^{
        _backView.alpha = 0;
        [self removeFromSuperview];
    }];
}

#pragma mark -- GWPickerViewDelegate
- (void)sureBtnAction:(UIButton *)sender
{
    [self dissmiss];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pickViewSureBtnSelectData:)])
    {
        NSInteger num = [self.pView selectedRowInComponent:0];
        [self.delegate pickViewSureBtnSelectData:_temData[num]];
    }
}

- (void)cancelBtnAction:(UIButton *)sender
{
    [self dissmiss];
}

#pragma mark -- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _temData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _temData[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kViewHeight/5;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dissmiss];
}

@end

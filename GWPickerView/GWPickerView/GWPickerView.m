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
/**
 *  UIDatePickerModeDate类型模式：视觉上可见格式
 *  UIDatePickerModeDateAndTime
 */
#define kDatePickerMode UIDatePickerModeDate
/**
 *  DateFormat:输出格式
 *  "YYYY-MM-dd HH:mm:ss"
 */
#define kDateFormat @"YYYY-MM-dd"

@interface GWPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray * _temData;//如果GWPickerViewType＝＝simple就传
    NSString * _tempTitle;//选择器的标题
    UIView * _backView;//底部视图
    NSInteger _tempType;
    UIColor * _tempColor;
    /**
     *  TypeAddress
     */
    NSMutableArray * _cityArr;
    NSMutableArray * _provinceArr;
    NSMutableArray * _districtArr;
    NSInteger _provinceIndex;//选中了那个省
    NSInteger _cityIndex;//选中了哪个城市的city索引
    NSInteger _districtIndex;//选中了那个区
}
/**
 *  一般或者地址选择器
 */
@property (nonatomic,strong) UIPickerView * pView;
/**
 *  时间选择器
 */
@property (nonatomic,strong) UIDatePicker * dataView;
@property (nonatomic,strong) UIWindow * window;

@end

@implementation GWPickerView

- (instancetype)initWithData:(NSArray *)data title:(NSString *)title type:(GWPickerViewType)type color:(UIColor *)color
{
    if (self == [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _tempTitle = title;
        _tempType = type;
        if (color != nil) {
            _tempColor = color;
        } else {
            _tempColor = kPickViewColor;
        }
        [self addView];
        if (type == 0) {
            _temData = data;
        }else if (type == 1)
        {
            [self addData];
        }
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
    _backView.backgroundColor = _tempColor;
    _backView.layer.borderWidth = 2;
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
    if (_tempType == 1 || _tempType == 0) {
        self.pView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kViewHeight / 5, kViewWidth, kViewHeight/5 * 3)];
        self.pView.backgroundColor = [UIColor whiteColor];
        self.pView.delegate = self;
        self.pView.dataSource = self;
        [_backView addSubview:self.pView];
    }else if (_tempType == 2){
        self.dataView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kViewHeight / 5, kViewWidth, kViewHeight/5 * 3)];
        self.dataView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:self.dataView];
        //时间模式
        [_dataView setDatePickerMode:(kDatePickerMode)];
        //默认根据手机本地设置显示为中文还是其他语言
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        _dataView.locale = locale;
    }
    
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

- (void)addData
{
    _provinceArr = [NSMutableArray new];
    _cityArr = [NSMutableArray new];
    _districtArr = [NSMutableArray new];
    _temData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"]];
    for (NSDictionary * dict in _temData) {
        [_provinceArr addObject:[dict.allKeys firstObject]];
    }
    for (NSDictionary * dict in _temData) {
        if ([dict objectForKey:_provinceArr[_provinceIndex]]) {
            _cityArr = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceArr[_provinceIndex]] allKeys]];
            [self.pView reloadComponent:1];
            [self.pView selectRow:0 inComponent:1 animated:YES];
            _districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceArr[_provinceIndex]] objectForKey:_cityArr[0]]];
            [self.pView reloadComponent:2];
            [self.pView selectRow:0 inComponent:2 animated:YES];
        }
    }
}

/**
 *  出现，消失的事件
 */
- (void)show
{
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        _backView.alpha = 1;
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
    NSString * str = [self returnSelectedStr];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pickViewSureBtnSelectData:)])
    {
        //pickerView&&DatePickerView返回选择的数据
        [self.delegate pickViewSureBtnSelectData:str];
    }
    if (self.dateBlock) {
        self.dateBlock(str);
    }
}

//pickerView&&DatePickerView返回选择的数据
- (NSString *)returnSelectedStr
{
    NSString * str;
    if (_tempType == 0) {
        NSInteger num = [self.pView selectedRowInComponent:0];
        str = _temData[num];
    }else if (_tempType == 1){
        str = [NSString stringWithFormat:@"%@,%@,%@",_provinceArr[_provinceIndex],_cityArr[_cityIndex],_districtArr[_districtIndex]];
    }else if (_tempType == 2){
        NSDate *thedate=self.dataView.date;
        NSDateFormatter *dateforMatter=[[NSDateFormatter alloc]init];
        [dateforMatter setDateFormat:kDateFormat];
        str = [dateforMatter stringFromDate:thedate];
    }
    return str;
}

- (void)cancelBtnAction:(UIButton *)sender
{
    [self dissmiss];
}

#pragma mark -- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_tempType == 0) {
        return 1;
    }else if (_tempType == 1)
    {
        return 3;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_tempType == 0) {
        return _temData.count;
    }else if (_tempType == 1){
        if (component == 0) {
            return _provinceArr.count;
        }else if (component == 1){
            return _cityArr.count;
        }else if (component == 2){
            return _districtArr.count;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = [UILabel new];
    pickerLabel.numberOfLines = 0;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    if (_tempType == 0) {
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
    } else {
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:12]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_tempType == 0) {
        return _temData[row];
    }else if (_tempType == 1){
        if (component == 0) {
            return _provinceArr[row];
        }else if (component == 1){
            return _cityArr[row];
        }else if (component == 2){
            return _districtArr[row];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_tempType == 1) {
        if (component == 0) {
            _provinceIndex = row;
            _cityIndex = 0;
            _districtIndex = 0;
            for (NSDictionary * dict in _temData) {
                if ([dict objectForKey:_provinceArr[_provinceIndex]]) {
                    _cityArr  = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceArr[_provinceIndex]]allKeys]];
                    [self.pView reloadComponent:1];
                    [self.pView selectRow:0 inComponent:1 animated:YES];
                    
                    _districtArr = [NSMutableArray arrayWithArray:[[dict objectForKey:_provinceArr[_provinceIndex]] objectForKey:_cityArr[0]]];
                    [_pView reloadComponent:2];
                    [_pView selectRow:0 inComponent:2 animated:YES];
                }
            }
        }
        if (component == 1) {
            _cityIndex = row;
            _districtIndex = 0;
            for (NSDictionary * dict in _temData) {
                if ([dict objectForKey:_provinceArr[_provinceIndex]]) {
                    _districtArr = [[dict objectForKey:_provinceArr[_provinceIndex]] objectForKey:_cityArr[_cityIndex]];
                    [_pView reloadComponent:2];
                    [_pView selectRow:0 inComponent:2 animated:YES];
                }
            }
        }
        if (component == 2) {
            _districtIndex = row;
        }
    }
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

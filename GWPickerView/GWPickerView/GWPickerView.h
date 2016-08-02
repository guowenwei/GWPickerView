//
//  PickerView.h
//  PickerView
//
//  Created by 魏郭文 on 16/7/23.
//  Copyright © 2016年 魏郭文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /**
     *  简单选择器，就必须传data;
     */
    GWPickerViewTypeSimple,
    /**
     *  地址选择器，就不用传data;
     */
    GWPickerViewTypeAddress,
    /**
     *  时间选择器，就不用传data;
     */
    GWPickerViewTypeTime,
} GWPickerViewType;

typedef void (^SelectedBlock) (NSString *dateStr);

@protocol GWPickerViewDelegate <NSObject>

- (void)pickViewSureBtnSelectData:(NSString *)data;

@end

@interface GWPickerView : UIView

@property (nonatomic,assign) id<
GWPickerViewDelegate> delegate;

- (instancetype)initWithData:(NSArray *)data title:(NSString *)title type:(GWPickerViewType)type color:(UIColor *)color;
- (void)show;
- (void)dissmiss;
@property (nonatomic,copy) SelectedBlock dateBlock;

@end

//
//  PickerView.h
//  PickerView
//
//  Created by 魏郭文 on 16/7/23.
//  Copyright © 2016年 魏郭文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GWPickerViewTypeSimple,
    /**
     *  如果是地址类型，就不用传data;
     */
    GWPickerViewTypeAddress,
} GWPickerViewType;

@protocol GWPickerViewDelegate <NSObject>

- (void)pickViewSureBtnSelectData:(NSString *)data;

@end

@interface GWPickerView : UIView

@property (nonatomic,assign) id<
GWPickerViewDelegate> delegate;

- (instancetype)initWithData:(NSArray *)data title:(NSString *)title type:(GWPickerViewType)type;
- (void)show;
- (void)dissmiss;

@end

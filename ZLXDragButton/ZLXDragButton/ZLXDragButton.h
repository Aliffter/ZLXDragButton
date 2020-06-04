//
//  ZLXDragButton.h
//  ZLXDragButton
//
//  Created by leo on 2020/6/1.
//  Copyright © 2020年 zlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLXDragButton : UIButton
@property(nonatomic, strong) UIView *customView;  //可自定义中间弹出视图
@property(nonatomic, assign) BOOL showCustomView; //点击悬浮按钮是是否弹出子视图。默认为YES，不弹出则直接响应clickHandler 回调
@property(nonatomic, assign) BOOL canMove;
@property (nonatomic, copy) void (^clickHandler)(ZLXDragButton *touchBtn); // 悬浮按钮的点击回调
@property (nonatomic, copy) void (^clickItemHandler)(UIButton *itemBtn); // 默认悬浮按钮的子视图按钮点击回调

+ (instancetype)shareInstance;
@end

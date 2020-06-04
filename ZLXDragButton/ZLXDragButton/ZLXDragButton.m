//
//  ZLXDragButton.m
//  ZLXDragButton
//
//  Created by leo on 2020/6/1.
//  Copyright © 2020年 zlx. All rights reserved.
//

#import "ZLXDragButton.h"

#define ZLXIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 ?  YES : NO)

#define ZLXMainW (!ZLXIOS8?[UIScreen mainScreen].bounds.size.width:[[[UIScreen mainScreen] fixedCoordinateSpace] bounds].size.width)

#define ZLXMainH (!ZLXIOS8?[UIScreen mainScreen].bounds.size.height:[[[UIScreen mainScreen] fixedCoordinateSpace] bounds].size.height)

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define  CustomViewWH 200
#define  DragBtnWH  50

@interface ZLXDragButton ()
@property(nonatomic, assign) CGPoint beginpoint;
@property(nonatomic, assign)BOOL currentSelect;
@property(nonatomic, assign) BOOL moving;

@end

@implementation ZLXDragButton

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static ZLXDragButton *DragButton;
    dispatch_once(&onceToken, ^{
        DragButton = [ZLXDragButton buttonWithType:UIButtonTypeCustom];
        CGFloat DragBottom = 8;
        CGFloat DragRight  = 0;
        CGFloat TarbarHight = 49;
        CGFloat DragButtonX = ZLXMainW - DragRight - DragBtnWH;
        CGFloat DragButtonY = ZLXMainH - DragBottom - DragBtnWH;
        DragButton.frame = CGRectMake(DragButtonX, DragButtonY - TarbarHight, DragBtnWH, DragBtnWH);
        DragButton.backgroundColor = [UIColor orangeColor];
        [DragButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
        DragButton.layer.cornerRadius = DragBtnWH * 0.5;
        DragButton.layer.masksToBounds = YES;
        DragButton.canMove = YES;
        DragButton.showCustomView = YES;
        [DragButton addTarget:DragButton action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    });
    return DragButton;
}
-(void)showDragButton:(BOOL)show{
    if (show) {
        [ZLXDragButton shareInstance].hidden = NO;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    }else{
        [ZLXDragButton shareInstance].hidden = YES;
        self.customView.hidden = YES;
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCustomViewSubView];
    }
    return self;
}
//开始(触摸-清扫)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _moving = NO;
    NSLog(@"touchesBegan_moving:%d",_moving);
    
    [super touchesBegan:touches withEvent:event];
    if (!_canMove) {
        [super touchesEnded: touches withEvent: event];
        
        return;
    }
    UITouch *touch = [touches anyObject];
    _beginpoint = [touch locationInView:self];
}

//触摸移动

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved_moving:%d",_moving);
    if (!_canMove) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    //偏移量
    float offsetX = currentPosition.x - _beginpoint.x;
    float offsetY = currentPosition.y - _beginpoint.y;
    
    if (fabsf(offsetX)+fabsf(offsetY)) {
        _moving = YES;//单击事件可用
    }
    
    //移动后的中心坐标
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    //x轴左右极限坐标
    if (self.center.x > (self.superview.frame.size.width-self.frame.size.width/2))
    {
        CGFloat x = self.superview.frame.size.width-self.frame.size.width/2;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }else if (self.center.x < self.frame.size.width/2)
    {
        CGFloat x = self.frame.size.width/2;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }
    
    //y轴上下极限坐标
    if (self.center.y > (self.superview.frame.size.height-self.frame.size.height/2)) {
        CGFloat x = self.center.x;
        CGFloat y = self.superview.frame.size.height-self.frame.size.height/2;
        self.center = CGPointMake(x, y);
    }else if (self.center.y <= self.frame.size.height/2){
        CGFloat x = self.center.x;
        CGFloat y = self.frame.size.height/2;
        self.center = CGPointMake(x, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_canMove) {
        return;
    }
    
    if (self.center.x >= self.superview.frame.size.width/2) {//向右侧移动
        //偏移动画
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        self.frame=CGRectMake(self.superview.frame.size.width - DragBtnWH,self.center.y-DragBtnWH/2, DragBtnWH,DragBtnWH);
        //提交UIView动画
        [UIView commitAnimations];
    }else{//向左侧移动
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        self.frame=CGRectMake(0.f,self.center.y-DragBtnWH/2, DragBtnWH,DragBtnWH);
        //提交UIView动画
        [UIView commitAnimations];
        
    }
    
    //不加此句话，UIButton将一直处于按下状态
    [super touchesEnded: touches withEvent: event];
    
}

//外界因素取消touch事件，
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)initCustomViewSubView
{
    //tab bar view  始终居中显示
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2 - CustomViewWH/2, HEIGHT/2 - CustomViewWH/2, CustomViewWH , CustomViewWH)] ;
    self.customView.layer.masksToBounds = YES;
    self.customView.layer.cornerRadius = 10;//设置圆角的大小
    self.customView.backgroundColor = [UIColor blackColor];
    self.customView.alpha = 0.8f;//设置透明
    [[UIApplication sharedApplication].keyWindow addSubview:self.customView];
    
    //循环设置tabbar上的button
    NSArray *tabTitle = @[@"笔记",@"家庭",@"取消",@"退出"];
    
    for (int i=0; i<tabTitle.count; i++) {
        CGRect rect;
        rect.size.width = 60;
        rect.size.height = 60;
        switch (i) {
            case 0:
                rect.origin.x = 100-30;
                rect.origin.y = 40-30;
                break;
            case 1:
                rect.origin.x = 160-30;
                rect.origin.y = 100-30;
                break;
            case 2:
                rect.origin.x = 100-30;
                rect.origin.y = 160-30;
                break;
            case 3:
                rect.origin.x = 40-30;
                rect.origin.y = 100-30;
                break;
        }
        
        
        UIView *tabView = [[UIView alloc] initWithFrame:rect];
        [self.customView addSubview:tabView];
        
        //设置子视图的图标
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame = CGRectMake(15, 0, 30, 30);
        NSString *iconStr = [NSString stringWithFormat:@"%d.jpg",i+1];
        [tabButton setBackgroundImage:[UIImage imageNamed:iconStr] forState:UIControlStateNormal];
        [tabButton setTag:i];
        [tabButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:tabButton];
        
        //设置标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 60, 15)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = tabTitle[i];
        [tabView addSubview:titleLabel];
    }
    
    [self.customView setHidden:YES];
}



- (void)click:(ZLXDragButton *)sender
{
    if (!self.moving) {
        sender.selected = !sender.selected;
        if (self.showCustomView) {
            if (sender.selected) {
                [self.customView setHidden:NO];
                [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.customView];
                self.hidden = YES;
            }else{
                [self.customView setHidden:YES];
                self.hidden = NO;
            }
        }else{
            if (self.clickHandler) {
                self.clickHandler(sender);
            }
        }
    }
}
- (void)buttonClicked:(UIButton *)sender{
    
    if (self.clickItemHandler) {
        self.clickItemHandler(sender);
    };
    [self click:self];
}

-(void)setCustomView:(UIView *)customView{
    if (_customView != customView) {
        _customView = customView;
        _customView.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_customView];
        
    }
    
}

@end

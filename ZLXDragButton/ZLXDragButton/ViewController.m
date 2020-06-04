//
//  ViewController.m
//  ZLXDragButton
//
//  Created by leo on 2020/6/1.
//  Copyright © 2020年 zlx. All rights reserved.
//

#import "ViewController.h"
#import "ZLXDragButton.h"
#import "ZLXDragBaseViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    if (![ZLXDragButton shareInstance].superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:[ZLXDragButton shareInstance]];
    }
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[ZLXDragButton shareInstance]];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    v.backgroundColor = [UIColor redColor];
//    [ZLXDragButton shareInstance].customView = v;
    [ZLXDragButton shareInstance].showCustomView = YES;
    
    [[ZLXDragButton shareInstance] setClickHandler:^(ZLXDragButton *touchBtn) {
        UIViewController *RWBaseVc = [[UIViewController alloc] init];
        RWBaseVc.view.backgroundColor = [UIColor blueColor];
        [self.navigationController pushViewController:RWBaseVc animated:YES];;
    }];
    [[ZLXDragButton shareInstance] setClickItemHandler:^(UIButton *itemBtn) {
        NSLog(@"ClickItemHandler");
    }];
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIViewController *VC = [[UIViewController alloc] init];
    VC.view.backgroundColor = [UIColor purpleColor];
    [self presentViewController:VC animated:YES completion:nil];
}

@end

//
//  ZLXDragBaseViewController.m
//  ZLXDragButton
//
//  Created by leo on 2020/6/1.
//  Copyright © 2020年 zlx. All rights reserved.
//

#import "ZLXDragBaseViewController.h"
#import "ZLXDragButton.h"
@interface ZLXDragBaseViewController ()

@end

@implementation ZLXDragBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[ZLXDragButton shareInstance]];
    [ZLXDragButton shareInstance].hidden = NO; //
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

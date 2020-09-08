//
//  ViewController.m
//  YXCodeConfusionTest
//
//  Created by ios on 2020/9/8.
//  Copyright © 2020 August. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

#pragma mark - 混淆属性
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *str;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 混淆方法
- (void)testMethod {
    
}
- (void)testMethod:(NSString *)str {
    
}
- (NSString *)testMethods:(NSInteger)index {
    
    return @"";
}
- (void)testMethodSecond {
    
}

@end

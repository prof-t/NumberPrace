//
//  ViewController.m
//  NumberPrace
//
//  Created by 平山亮 on 2016/03/01.
//  Copyright © 2016年 平山亮. All rights reserved.
//

#import "ViewController.h"
#import "NumberPrace.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NumberPrace *numberPrace = [[NumberPrace alloc]init];
    
    
    NSArray *firstRowArray = [numberPrace getNumberPraceArray];
    
    
    NSArray *firstColumnArray = [numberPrace getNumberPraceArray];
    NSNumber *rowInt = [firstRowArray objectAtIndex:0];
    NSNumber *columnInt = [firstColumnArray objectAtIndex:0];
    
    while ([rowInt isEqualToNumber:columnInt]){
        firstColumnArray = [numberPrace getNumberPraceArray];
        columnInt = [firstColumnArray objectAtIndex:0];
    }
    
    NSMutableArray *secondRowArray = [NSMutableArray array];
    NSInteger i;
    for (i = 1;i<=9;i++){
            NSInteger newCellNum = [numberPrace checkRule1WithArray:secondRowArray agoAgoArray:nil agoArray:firstRowArray indexPathRow:2 indexPathColumn:i];
        [secondRowArray addObject:[NSNumber numberWithInteger:newCellNum]];
    }
    
    // test 1行目 5列目

    UIButton *hogeButon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:hogeButon];
    
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

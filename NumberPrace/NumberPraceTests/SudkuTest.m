//
//  SudkuTest.m
//  NumberPrace
//
//  Created by 平山亮 on 2016/03/02.
//  Copyright © 2016年 平山亮. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SudokuSample.h"

@interface SudkuTest : XCTestCase

@property (nonatomic,strong) SudokuSample *sudoku;

@end

@implementation SudkuTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.sudoku = [[SudokuSample alloc]init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

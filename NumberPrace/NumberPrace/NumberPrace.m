//
//  NumberPrace.m
//  NumberPrace
//
//  Created by 平山亮 on 2016/03/01.
//  Copyright © 2016年 平山亮. All rights reserved.
//

#import "NumberPrace.h"

static NSInteger const MaxNum = 9;

@interface NumberPrace ()

// 縦横マスの数字配列
@property (nonatomic,strong) NSArray *verticalAndHorizontalArray;

// 縦マスの数字配列
@property (nonatomic,strong) NSArray *verticalArray;

// 横マスの数字配列
@property (nonatomic,strong) NSArray *horizontalArray;

// 行の数字を格納する配列(1〜9マス分)
@property (nonatomic,strong) NSMutableArray *row1stNumArray;
@property (nonatomic,strong) NSMutableArray *row2ndNumArray;
@property (nonatomic,strong) NSMutableArray *row3rdNumArray;
@property (nonatomic,strong) NSMutableArray *row4thNumArray;
@property (nonatomic,strong) NSMutableArray *row5thNumArray;
@property (nonatomic,strong) NSMutableArray *row6thNumArray;
@property (nonatomic,strong) NSMutableArray *row7thNumArray;
@property (nonatomic,strong) NSMutableArray *row8thNumArray;
@property (nonatomic,strong) NSMutableArray *row9thNumArray;

@property (nonatomic,strong) NSMutableArray *candidateNumArray;

@end

@implementation NumberPrace

// ランダムな値を得る
- (NSInteger)getRandomNum
{
    NSInteger randomNumInt = arc4random () % MaxNum + 1;
    return randomNumInt;
}

// 数字を配列に格納する
- (void)storeArrayWithNum:(NSInteger)num array:(NSMutableArray *)array
{
    NSInteger randomNum;
    BOOL isSetObject = NO;
    int i;
    
    for (i = 1; i <= 9; i++) {
        isSetObject = NO;

        while(isSetObject == NO){
            randomNum = [self getRandomNum];
            if ([self isMatchNumWithSameArray:array randomNum:randomNum]){
                // 一致するなら周回を回す
            } else {
                // 一致しなければarrayをセット
                [array addObject:@(randomNum)];
                isSetObject = YES;
            }
        }
    }
}


#pragma mark - Public Methods
- (NSArray *)getNumberPraceArray
{
    NSMutableArray *numberPraceArray = [NSMutableArray array];
    [self storeArrayWithNum:[self getRandomNum] array:numberPraceArray];
    
    return numberPraceArray;
}

// 引数のランダム数字と一致する数字が配列内にあればyesを返す
- (BOOL)isMatchNumWithSameArray:(NSMutableArray *)array randomNum:(NSInteger)randomNum
{
    NSInteger roopCount = 0;
    for (NSNumber *num in array)
    {
        NSInteger numInt = [num integerValue];
        if (numInt == randomNum){
            return YES;
        } else {
            roopCount ++;
            
            if ([array count] <= roopCount){
            return NO;
            }
        }
    }
    return NO;
}

// 引数のランダム数字と配列の数字を比較して一致するかどうか
- (BOOL)isMatchNumWithDifferenceArray:(NSArray *)array arrayCount:(NSInteger)arrayCount randomNum:(NSNumber *)randomNum
{
    NSNumber *arrayNum = [array objectAtIndex:arrayCount];
    BOOL isMatch = [randomNum isEqualToNumber:arrayNum];
    
    return isMatch;
}

// ルール1に照らし合せて、重複しない数字を返す
- (NSInteger)checkRule1WithArray:(NSArray *)array agoAgoArray:(NSArray *)agoAgoArray agoArray:(NSArray *)agoArray indexPathRow:(NSInteger)indexPathRow indexPathColumn:(NSInteger)indexPathColumn
{
    // マスに入れる候補の数字をランダムに生成
    self.candidateNumArray = [NSMutableArray array];
    self.candidateNumArray = [[self getNumberPraceArray]mutableCopy];
//    NSInteger candidateNum = [self getRandomNum];
    NSInteger candidateNum;
    
    //自分のパターンはどれ？
    NSInteger myCount = indexPathColumn % 3;
    
    
    switch (myCount) {
        case 0:
            // 列番号 3 or 6 or 9
            for (int i = 1;i == MaxNum;i++){
                
                if (![self isDuplicationNumBeforeCellWithArray:agoAgoArray indexPathRow:indexPathRow caseNum:0 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]
                    && ![self isDuplicationNumBeforeCellWithArray:agoArray indexPathRow:indexPathRow caseNum:0 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]
                    && ![self isDuplicationNumBeforeCellWithArray:array indexPathRow:indexPathRow caseNum:0 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]){
                    candidateNum = [[self.candidateNumArray objectAtIndex:0] integerValue];
                    break;
                } else {
                    [self.candidateNumArray removeObjectAtIndex:0];
                }
            }
            break;
            
        case 1:
            // 列番号 1 or 4 or 7
            for (int i = 1;i == MaxNum;i++){
                
                if (![self isDuplicationNumBeforeCellWithArray:agoAgoArray indexPathRow:indexPathRow caseNum:1 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]
                    && ![self isDuplicationNumBeforeCellWithArray:agoArray indexPathRow:indexPathRow caseNum:1 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]
                    && ![self isDuplicationNumBeforeCellWithArray:array indexPathRow:indexPathRow caseNum:1 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]){
                    candidateNum = [[self.candidateNumArray objectAtIndex:0] integerValue];
                    break;
                } else {
                    [self.candidateNumArray removeObjectAtIndex:0];
                }
            }
            break;
            
        case 2:
            // 列番号 2 or 5 or 8
            for (int i = 1;i == MaxNum;i++){
                
                if (![self isDuplicationNumBeforeCellWithArray:agoAgoArray indexPathRow:indexPathRow caseNum:2 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]
                    && ![self isDuplicationNumBeforeCellWithArray:agoArray indexPathRow:indexPathRow caseNum:2 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]
                    && ![self isDuplicationNumBeforeCellWithArray:array indexPathRow:indexPathRow caseNum:2 candidateNum:[[self.candidateNumArray objectAtIndex:0] integerValue]]){
                    candidateNum = [[self.candidateNumArray objectAtIndex:0] integerValue];
                    break;
                } else {
                    [self.candidateNumArray removeObjectAtIndex:0];
                }
            }
            break;
    }
    
    [self.candidateNumArray removeAllObjects];
    return candidateNum;
}

// 指定した要素に重複があるかのチェック
- (BOOL)isDuplicationNumWithArray:(NSArray *)array arrayCount:(NSInteger)arrayCount candidateNum:(NSInteger)candidateNum
{
    if (!array) {
        return NO;
    }
    
    NSInteger arrayNum = [[array objectAtIndex:arrayCount] integerValue];
    if (candidateNum == arrayNum){
        return YES;
    } else {
        return NO;
    }
}

// 自身より前の3x3マス内に同じ値があるかどうかのチェック
- (BOOL)isDuplicationNumBeforeCellWithArray:(NSArray *)array indexPathRow:(NSInteger)indexPathRow caseNum:(NSInteger)caseNum candidateNum:(NSInteger)candidateNum
{
    switch (caseNum) {
        case 0:
            // 列番号 3 or 6 or 9
            if (![self isDuplicationNumWithArray:array arrayCount:indexPathRow -0 candidateNum:candidateNum] && ![self isDuplicationNumWithArray:array arrayCount:indexPathRow -1 candidateNum:candidateNum] && ![self isDuplicationNumWithArray:array arrayCount:indexPathRow -2 candidateNum:candidateNum]){
                return NO;
            } else {
                return YES;
            }
            break;
            
        case 1:
            // 列番号 1 or 4 or 7
            if (![self isDuplicationNumWithArray:array arrayCount:indexPathRow -0 candidateNum:candidateNum] && ![self isDuplicationNumWithArray:array arrayCount:indexPathRow -1 candidateNum:candidateNum]) {
                return NO;
            } else {
                return YES;
            }
            break;

        case 2:
            // 列番号 2 or 5 or 8
            if (![self isDuplicationNumWithArray:array arrayCount:indexPathRow -0 candidateNum:candidateNum]){
                return NO;
            } else {
                return YES;
            }
            break;
            
        default:
            break;
    }
    return YES;
}

@end

//
//  Sudoku.m
//  Sudoku
//
//  Created by 山口 徹 on 2016/03/01.
//  Copyright (c) 2016年 山口 徹. All rights reserved.
//

#import "SudokuSample.h"

@interface SudokuSample()
// 数独解答データ
@property(nonatomic,strong)NSMutableArray *sudokuData;

// 破綻した状態かどうか
@property(nonatomic,assign)BOOL isHatan;

// 通常走査の破綻状態の一時保存用(破綻したマスのインデックスと破綻した数(0〜3)を記憶しておく)
@property(nonatomic,assign)NSUInteger rowHatan;
@property(nonatomic,assign)NSUInteger colmnHatan;
@property(nonatomic,assign)NSUInteger countHatan;
@property(nonatomic,assign)NSUInteger numHatan;

@property(nonatomic,assign)NSInteger charengeCount;

// 走査をあきらめるためのカウンタorz
@property(nonatomic,assign)NSInteger counter;

@end


@implementation SudokuSample

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Public

- (NSArray*)createSudokuData
{
    // 初回スキャン
    [self scanHatanAll];
    
    while ([self scanHatanAll]) {
        [self updateHatanData];
        
        self.counter++;
        // 走査をあきらめてやり直し
        if (self.counter > 200) {
            [self initialize];
        }
        
        [self scanHatanAll];
    }
    
    return self.sudokuData;
}

#pragma mark - Private

/*
 初期化
 */
- (void)initialize
{
    self.counter = 0;
    
    self.isHatan = NO;
    self.rowHatan = 0;
    self.colmnHatan = 0;
    self.countHatan = 4;
    self.numHatan = 0;
    
    self.sudokuData = [@[[@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy],
                         [@[@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0),@(0)] mutableCopy]] mutableCopy];
}

/*
 乱数生成
 @return 乱数(1 to 9)
 */
- (NSInteger)createRandNumber
{
    int min = 1;
    int max = 9;
    srandomdev();
    return (random() % (max + 1 - min)) + min;
}

/*
 乱数を範囲内でループインクリメントする
 @return インクリメントされた数値(1 to 9)
 */
- (NSInteger)incRand:(NSInteger)rand
{
    if (rand >= 9) {
        return 1;
    } else {
        return rand+1;
    }
    
}

/*
 判定条件1：正方形ブロックの破綻判定
 @param number 判定する数値
 @param row 判定するrow
 @param colmn 判定するcolmn
 @return 破綻していればYESを返す。正常ならNOを返す。
*/
- (BOOL)isHatanSquareWithNumber:(NSInteger)number row:(NSUInteger)row colmn:(NSUInteger)colmn
{
    NSArray *squareData = [self squareDataWithRow:row colmn:colmn];
    
    for (NSNumber *num in squareData) {
        NSInteger compNum = [num integerValue];
        if (compNum == number) {
            return YES;
        }
    }
    
    return NO;
}

/*
 正方形ブロックの現在値を配列で取得
 @param row 行
 @param colmn 列
 @return 指定行列を含む正方形ブロック内にある指定行列の値を除く8つの値を配列で返す
 */
- (NSArray *)squareDataWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    // min行
    NSUInteger minRow = row - (row%3);
    // max行
    NSUInteger maxRow = row + (2-row%3);
    
    // min列
    NSUInteger minColmn = colmn - (colmn%3);
    // max列
    NSUInteger maxColmn = colmn + (2-colmn%3);
    
    NSMutableArray *squareData = [@[] mutableCopy];
    
    for (NSUInteger r = minRow; r <= maxRow; r++) {
        for (NSUInteger c = minColmn; c <= maxColmn; c++) {
            if (r == row && c == colmn) {
                continue;
            }
            [squareData addObject:self.sudokuData[r][c]];
        }
    }
    
    return squareData;
}

/*
 判定条件2：水平方向ブロックの破綻判定
 @param number 判定する数値
 @param row 判定するrow
 @param colmn 判定するcolmn
 @return 破綻していればYESを返す。正常ならNOを返す。
 */
- (BOOL)isHatanHorizontialWithNumber:(NSInteger)number row:(NSUInteger)row colmn:(NSUInteger)colmn
{
    NSArray *horizontialData = [self horizontialDataWithRow:row colmn:colmn];
    
    for (NSNumber *num in horizontialData) {
        NSInteger compNum = [num integerValue];
        if (compNum == number) {
            return YES;
        }
    }
    
    return NO;
}

/*
 水平方向ブロックの現在値を配列で取得
 @param row 行
 @param colmn 列
 @return 指定行列を含む水平方向ブロック内にある指定行列の値を除く8つの値を配列で返す
 */
- (NSArray *)horizontialDataWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    NSMutableArray *horizontialData = [self.sudokuData[row] mutableCopy];
    
    [horizontialData removeObjectAtIndex:colmn];
    
    return horizontialData;
}

/*
 判定条件3：垂直方向ブロックの破綻判定
 @param number 判定する数値
 @param row 判定するrow
 @param colmn 判定するcolmn
 @return 破綻していればYESを返す。正常ならNOを返す。
 */
- (BOOL)isHatanVerticalWithNumber:(NSInteger)number row:(NSUInteger)row colmn:(NSUInteger)colmn
{
    NSArray *verticalData = [self verticalDataWithRow:row colmn:colmn];
    
    for (NSNumber *num in verticalData) {
        NSInteger compNum = [num integerValue];
        if (compNum == number) {
            return YES;
        }
    }
    
    return NO;
}

/*
 垂直方向ブロックの現在値を配列で取得
 @param row 行
 @param colmn 列
 @return 指定行列を含む垂直方向ブロック内にある指定行列の値を除く8つの値を配列で返す
*/
- (NSArray *)verticalDataWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    NSMutableArray *verticalData = [@[] mutableCopy];
    
    [self.sudokuData enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger rIdx, BOOL *stop) {
        if (rIdx != row) {
            [verticalData addObject:rows[colmn]];
        }
    }];
    
    return verticalData;
}


/*
 単一マスに対する通常破綻判定
 @param number 判定する数値
 @param row 判定するrow
 @param colmn 判定するcolmn
 @return 破綻している個数を返す(0 to 3)
 */
- (NSUInteger)countHatanWithNumber:(NSInteger)number row:(NSUInteger)row colmn:(NSUInteger)colmn
{
    NSUInteger countHatan = 0;
    
    // 判定条件1
    if ([self isHatanSquareWithNumber:number row:row colmn:colmn]) {
        countHatan++;
    }
    
    // 判定条件2
    if ([self isHatanHorizontialWithNumber:number row:row colmn:colmn]) {
        countHatan++;
    }
    
    // 判定条件3
    if ([self isHatanVerticalWithNumber:number row:row colmn:colmn]) {
        countHatan++;
    }

    return countHatan;
    
}

/*
 単一マスに対する通常破綻判定による値の格納及び破綻値の更新
 @param rand 初期格納値(1 to 9)
 @param row 判定するrow
 @param colmn 判定するcolmn
 */
- (void)challengeHatanWithRand:(NSInteger)rand row:(NSUInteger)row colmn:(NSUInteger)colmn
{
    // 破綻数最小値
    NSUInteger countHatanMin = 4; // 初期値は破綻最大値(=3)よりも大きい数値
    // 破綻数最小値時の数値
    NSInteger numHatanMin = 0;

    // 乱数初期値更新用
    NSInteger incRand = rand;
    
    // 1から9までの数値を格納出来るか判定
    for (NSInteger i = 0; i < 9; i++) {
        NSInteger countHatan = [self countHatanWithNumber:incRand row:row colmn:colmn];
        
        if (countHatan == 0) {
            // 値が格納出来る場合(=破綻0)はデータを更新して処理を抜ける
            self.sudokuData[row][colmn] = @(incRand);
            return;
            
        } else {
            // 破綻している場合は破綻最小値と乱数を更新して次へ
            if (countHatanMin > countHatan) {
                countHatanMin = countHatan;
                numHatanMin = incRand;
            }
            
            incRand = [self incRand:incRand];
        }
    }
    
    self.isHatan = YES;
    
    if (self.countHatan > countHatanMin) {
        self.countHatan = countHatanMin;
        self.rowHatan = row;
        self.colmnHatan = colmn;
        self.numHatan = numHatanMin;
    }
}

/*
 通常の全走査判定格納処理
 @return YES : まだ破綻している  NO : 破綻していない
 @note 乱数を用いて全マスに対して通常の破綻判定を行い格納できるマスのみ格納する
 */
- (BOOL)scanHatanAll
{
    self.isHatan = NO;
    [self.sudokuData enumerateObjectsUsingBlock:^(NSMutableArray *rowData, NSUInteger row, BOOL *stop) {
        [rowData enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger colmn, BOOL *stop) {
            NSInteger currentNum = [num integerValue];
            if (currentNum == 0) {
                // 空欄のマスに対して乱数の挿入の破綻判定をする
                NSInteger rand = [self createRandNumber];
                [self challengeHatanWithRand:rand row:row colmn:colmn];
            }
        }];
    }];
    
    [self printData];

    if (self.isHatan) {
        return YES;
    }
    
    return NO;
}

/*
 破綻マスの更新及び破綻データ値の除去
 */
- (void)updateHatanData
{
    // 破綻した値を一旦入れる
    if (self.isHatan) {
        self.sudokuData[self.rowHatan][self.colmnHatan] = @(self.numHatan);
    }
    
    // 各破綻データを削除する
    [self removeAllBlockDataWithRow:self.rowHatan colmn:self.colmnHatan];
//    [self removeAllValueWithRow:self.rowHatan colmn:self.colmnHatan];
    
//    [self removeSquareHatanValueWithRow:self.rowHatan colmn:self.colmnHatan];
//    
//    [self removeHorizontialValueWithRow:self.rowHatan colmn:self.colmnHatan];
//    
//    [self removeVerticalValueWithRow:self.rowHatan colmn:self.colmnHatan];
    
    // 破綻情報のリセット
    self.numHatan = 0;
    self.countHatan = 4;
    self.rowHatan = 0;
    self.colmnHatan = 0;
    
}


/*
 破綻データ値の除去：正方形ブロック
 指定行列を除く正方形ブロック内に存在する指定行列と同じ値(破綻した値)の除去(初期化)
 @param row 行
 @param colmn 列
 */
- (void)removeSquareHatanValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    // min行
    NSUInteger minRow = row - (row%3);
    // max行
    NSUInteger maxRow = row + (2-row%3);
    
    // min列
    NSUInteger minColmn = colmn - (colmn%3);
    // max列
    NSUInteger maxColmn = colmn + (2-colmn%3);
    
    for (NSUInteger r = minRow; r <= maxRow; r++) {
        for (NSUInteger c = minColmn; c <= maxColmn; c++) {
            if (r == row && c == colmn) {
                continue;
            }
            
            NSNumber *num = self.sudokuData[r][c];
            NSInteger targetNum = [num integerValue];
            
            if (targetNum == self.numHatan) {
                self.sudokuData[r][c] = @(0);
                return;
            }
        }
    }
}

/*
 破綻データ値の除去：水平方向ブロック
 指定行列を除く水平方向ブロック内に存在する指定行列と同じ値(破綻した値)の除去(初期化)
 @param row 行
 @param colmn 列
 */
- (void)removeHorizontialValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    [self.sudokuData[row] enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        NSInteger targetNum = [num integerValue];
        
        if (idx != colmn && targetNum == self.numHatan) {
            self.sudokuData[row][idx] = @(0);
            *stop = YES;
        }
    }];
}

/*
 破綻データ値の除去：垂直方向ブロック
 指定行列を除く垂直方向ブロック内に存在する指定行列と同じ値(破綻した値)の除去(初期化)
 @param row 行
 @param colmn 列
 */
- (void)removeVerticalValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    [self.sudokuData enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger r, BOOL *stop) {
        NSNumber *num = rows[colmn];
        NSInteger targetNum = [num integerValue];
        if (r != row && targetNum == self.numHatan) {
            self.sudokuData[r][colmn] = @(0);
            *stop = YES;
        }
    }];
}

/*
 破綻データ値の除去：全数値除去
 */
- (void)removeAllValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    [self.sudokuData enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger r, BOOL *stop) {
        [rows enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger c, BOOL *stop) {
            NSInteger targetNum = [num integerValue];
            if (r != row && c != colmn && targetNum == self.numHatan) {
                self.sudokuData[r][c] = @(0);
            }
        }];
    }];
}

/*
 破綻データ値の除去：関連データの全除去
 */
- (void)removeAllBlockDataWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    [self removeAllSquareValueWithRow:row colmn:colmn];
    [self removeAllHorizontialValueWithRow:row colmn:colmn];
    [self removeAllVerticalValueWithRow:row colmn:colmn];

}

/*
 破綻データの除去：正方形ブロック全除去
 */
- (void)removeAllSquareValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    // min行
    NSUInteger minRow = row - (row%3);
    // max行
    NSUInteger maxRow = row + (2-row%3);
    
    // min列
    NSUInteger minColmn = colmn - (colmn%3);
    // max列
    NSUInteger maxColmn = colmn + (2-colmn%3);
    
    for (NSUInteger r = minRow; r <= maxRow; r++) {
        for (NSUInteger c = minColmn; c <= maxColmn; c++) {
            if (r == row && c == colmn) {
                continue;
            }
            
            self.sudokuData[r][c] = @(0);
        }
    }
}

/*
 破綻データの除去：水平方向ブロック全除去
 */
- (void)removeAllHorizontialValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    [self.sudokuData[row] enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        if (idx != colmn) {
            self.sudokuData[row][idx] = @(0);
        }
    }];
}

/*
 破綻データの除去：垂直方向ブロック全除去
 */
- (void)removeAllVerticalValueWithRow:(NSUInteger)row colmn:(NSUInteger)colmn
{
    [self.sudokuData enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger r, BOOL *stop) {
        if (r != row) {
            self.sudokuData[r][colmn] = @(0);
            *stop = YES;
        }
    }];

}

#pragma mark - Debug

// データの表示
- (void)printData
{
    [self.sudokuData enumerateObjectsUsingBlock:^(NSMutableArray *rows, NSUInteger idx, BOOL *stop) {
        NSLog(@"|%@|%@|%@|%@|%@|%@|%@|%@|%@|",rows[0],rows[1],rows[2],rows[3],rows[4],rows[5],rows[6],rows[7],rows[8]);
    }];

    self.charengeCount ++;
    NSLog(@"\nnumHatan : %lu\ncountHatan : %lu\nrowHatan   : %lu\ncolmnHatan : %lu \ncharengeCount : %lu",(unsigned long)self.numHatan,(unsigned long)self.countHatan,(unsigned long)self.rowHatan,(unsigned long)self.colmnHatan,(unsigned long)self.charengeCount);
}

@end

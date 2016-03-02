//
//  Sudoku.h
//  Sudoku
//
//  Created by 山口 徹 on 2016/03/01.
//  Copyright (c) 2016年 山口 徹. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 数独の解答データを作成するためのクラス
 */
@interface SudokuSample : NSObject

/**
 * 数独のデータをランダムに作成する
 * @return 数独データの２次元配列
 */
- (NSArray*)createSudokuData;

- (NSInteger)incRand:(NSInteger)rand;

@end

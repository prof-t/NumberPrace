//
//  NumberPrace.h
//  NumberPrace
//
//  Created by 平山亮 on 2016/03/01.
//  Copyright © 2016年 平山亮. All rights reserved.
//

/**
 数独の計算を行うクラス
 */

#import <Foundation/Foundation.h>

@interface NumberPrace : NSObject

// 数独の一列分の値が格納された配列を返す
- (NSArray *)getNumberPraceArray;

// ルール1のチェック
- (NSInteger)checkRule1WithArray:(NSArray *)array agoAgoArray:(NSArray *)agoAgoArray agoArray:(NSArray *)agoArray indexPathRow:(NSInteger)indexPathRow indexPathColumn:(NSInteger)indexPathColumn;

// ランダムな値を得る
- (NSInteger)getRandomNum;

// 配列内に同じ数字があるかどうか
- (BOOL)isMatchNumWithSameArray:(NSMutableArray *)array randomNum:(NSInteger)randomNum;

// 他配列の同一要素が同じ数字かどうか
- (BOOL)isMatchNumWithDifferenceArray:(NSMutableArray *)array arrayCount:(NSInteger)arrayCount randomNum:(NSNumber *)randomNum;

@end

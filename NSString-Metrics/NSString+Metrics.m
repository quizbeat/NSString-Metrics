//
//  NSString+Metrics.m
//  NSString-Metrics
//
//  Created by Nikita Makarov on 11/04/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "NSString+Metrics.h"

NSInteger max(NSInteger a, NSInteger b) {
    return (a > b) ? a : b;
}

NSInteger min(NSInteger a, NSInteger b) {
    return (a < b) ? a : b;
}

NSInteger min3(NSInteger a, NSInteger b, NSInteger c) {
    return min(min(a, b), c);
}


static const NSInteger defaultInsertCost = 1;
static const NSInteger defaultDeleteCost = 1;
static const NSInteger defaultReplaceCost = 1;
static const NSInteger defaultTransposeCost = 1;


@implementation NSString (Metrics)

- (NSInteger)LevenshteinDistanceFromString:(NSString *)string
                             caseSensitive:(BOOL)caseSensitive
{
    return [self LevenshteinDistanceFromString:string
                                    insertCost:defaultInsertCost
                                    deleteCost:defaultDeleteCost
                                   replaceCost:defaultReplaceCost
                                 caseSensitive:caseSensitive];
}

- (NSInteger)LevenshteinDistanceFromString:(NSString *)string
                                insertCost:(NSInteger)insertCost
                                deleteCost:(NSInteger)deleteCost
                               replaceCost:(NSInteger)replaceCost
                             caseSensitive:(BOOL)caseSensitive
{
    NSString *selfString = nil;
    NSString *otherString = nil;
    
    if (!caseSensitive) {
        selfString = [[self copy] lowercaseString];
        otherString = [[string copy] lowercaseString];
    } else {
        selfString = self;
        otherString = string;
    }
    
    NSInteger m = [selfString length];
    NSInteger n = [otherString length];
    
    NSInteger **d = (NSInteger **)malloc((m + 1) * sizeof(NSInteger *));
    for (NSInteger i = 0; i < m + 1; i++) {
        d[i] = (NSInteger *)malloc((n + 1) * sizeof(NSInteger));
    }
    
    for (NSInteger i = 0; i <= m; i++) {
        d[i][0] = i;
    }
    
    for (NSInteger j = 0; j <= n; j++) {
        d[0][j] = j;
    }
    
    for (NSInteger i = 1; i <= m; i++) {
        NSString *selfCharacter = [selfString substringWithRange:NSMakeRange(i - 1, 1)];
        for (NSInteger j = 1; j <= n; j++) {
            NSString *stringCharacter = [otherString substringWithRange:NSMakeRange(j - 1, 1)];
            if (i == 0 && j == 0) {
                d[i][j] = 0;
            } else if (i == 0) {
                d[i][j] = j;
            } else if (j == 0) {
                d[i][j] = i;
            } else {
                NSInteger matchCharacters = 1;
                if ([selfCharacter isEqualToString:stringCharacter]) {
                    matchCharacters = 0;
                }
                d[i][j] = min3(d[i][j - 1] + insertCost,
                               d[i - 1][j] + deleteCost,
                               d[i - 1][j - 1] + matchCharacters);
            }
        }
    }
    
    NSInteger distance = d[m][n];
    
    for (NSInteger i = 0; i < m + 1; i++) {
        free(d[i]);
    }
    free(d);
    
    return distance;
}

- (CGFloat)normalizedLevenshteinDistanceFromString:(NSString *)string
                                     caseSensitive:(BOOL)caseSensitive
{
    return [self normalizedLevenshteinDistanceFromString:string
                                              insertCost:defaultInsertCost
                                              deleteCost:defaultDeleteCost
                                             replaceCost:defaultReplaceCost
                                           caseSensitive:caseSensitive];
}

- (CGFloat)normalizedLevenshteinDistanceFromString:(NSString *)string
                                        insertCost:(NSInteger)insertCost
                                        deleteCost:(NSInteger)deleteCost
                                       replaceCost:(NSInteger)replaceCost
                                     caseSensitive:(BOOL)caseSensitive
{
    NSInteger distance = [self LevenshteinDistanceFromString:string
                                                  insertCost:insertCost
                                                  deleteCost:deleteCost
                                                 replaceCost:replaceCost
                                               caseSensitive:caseSensitive];
    NSInteger maxLength = max([self length], [string length]);
    CGFloat ratio = (CGFloat)distance / (CGFloat)maxLength;
    return ratio;
}

- (NSInteger)DamerauLevenshteinDistanceFromString:(NSString *)string 
                                    caseSensitive:(BOOL)caseSensitive
{
    return [self DamerauLevenshteinDistanceFromString:string
                                           insertCost:defaultInsertCost
                                           deleteCost:defaultDeleteCost
                                          replaceCost:defaultReplaceCost
                                        transposeCost:defaultTransposeCost
                                        caseSensitive:caseSensitive];
}

- (NSInteger)DamerauLevenshteinDistanceFromString:(NSString *)string
                                       insertCost:(NSInteger)insertCost
                                       deleteCost:(NSInteger)deleteCost
                                      replaceCost:(NSInteger)replaceCost
                                    transposeCost:(NSInteger)transposeCost
                                    caseSensitive:(BOOL)caseSensitive
{
    NSString *selfString = nil;
    NSString *otherString = nil;
    
    if (!caseSensitive) {
        selfString = [[self copy] lowercaseString];
        otherString = [[string copy] lowercaseString];
    } else {
        selfString = self;
        otherString = string;
    }
    
    NSInteger m = [selfString length];
    NSInteger n = [otherString length];
    
    if ([selfString isEqualToString:@""]) {
        if ([otherString isEqualToString:@""]) {
            return 0;
        } else {
            return n;
        }
    } else if ([otherString isEqualToString:@""]) {
        return m;
    }
    
    NSInteger **d = (NSInteger **)malloc((m + 2) * sizeof(NSInteger *));
    for (NSInteger i = 0; i < m + 2; i++) {
        d[i] = (NSInteger *)malloc((n + 2) * sizeof(NSInteger));
    }
    
    NSInteger inf = INT_MAX / 2;
    
    d[0][0] = inf;
    
    for (NSInteger i = 0; i <= m; i++) {
        d[i + 1][1] = i;
        d[i + 1][0] = inf;
    }
    
    for (NSInteger j = 0; j <= n; j++) {
        d[1][j + 1] = j;
        d[0][j + 1] = inf;
    }
    
    NSMutableDictionary *lastPosition = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < m; i++) {
        NSString *character = [selfString substringWithRange:NSMakeRange(i, 1)];
        [lastPosition setObject:@(0) forKey:character];
    }
    
    for (NSInteger j = 0; j < n; j++) {
        NSString *character = [otherString substringWithRange:NSMakeRange(j, 1)];
        [lastPosition setObject:@(0) forKey:character];
    }
    
    for (NSInteger i = 1; i <= m; i++) {
        NSInteger last = 0;
        NSString *selfCharacter = [selfString substringWithRange:NSMakeRange(i - 1, 1)];
        for (NSInteger j = 1; j <= n; j++) {
            NSString *stringCharacter = [otherString substringWithRange:NSMakeRange(j - 1, 1)];
            NSInteger ii = [[lastPosition objectForKey:stringCharacter] integerValue];
            NSInteger jj = last;
            if ([selfCharacter isEqualToString:stringCharacter]) {
                d[i + 1][j + 1] = d[i][j];
                last = j;
            } else {
                d[i + 1][j + 1] = min3(d[ i ][ j ] + replaceCost,
                                       d[i + 1][j] + insertCost,
                                       d[i][j + 1] + deleteCost);
            }
            d[i + 1][j + 1] = min(d[i + 1][j + 1],
                                  d[ii][jj] + (i - ii - 1) * deleteCost + transposeCost + (j - jj - 1) * insertCost);
        }
        [lastPosition setObject:@(i) forKey:selfCharacter];
    }
    
    NSInteger distance = d[m + 1][n + 1];
    
    for (NSInteger i = 0; i < m + 2; i++) {
        free(d[i]);
    }
    free(d);
    
    return distance;
}

- (CGFloat)normalizedDamerauLevenshteinDistanceFromString:(NSString *)string
                                            caseSensitive:(BOOL)caseSensitive
{
    return [self normalizedDamerauLevenshteinDistanceFromString:string
                                                     insertCost:defaultInsertCost
                                                     deleteCost:defaultDeleteCost
                                                    replaceCost:defaultReplaceCost
                                                  transposeCost:defaultTransposeCost
                                                  caseSensitive:caseSensitive];
}

- (CGFloat)normalizedDamerauLevenshteinDistanceFromString:(NSString *)string
                                               insertCost:(NSInteger)insertCost
                                               deleteCost:(NSInteger)deleteCost
                                              replaceCost:(NSInteger)replaceCost
                                            transposeCost:(NSInteger)transposeCost
                                            caseSensitive:(BOOL)caseSensitive
{
    NSInteger distance = [self DamerauLevenshteinDistanceFromString:string
                                                         insertCost:insertCost
                                                         deleteCost:deleteCost
                                                        replaceCost:replaceCost
                                                      transposeCost:transposeCost
                                                      caseSensitive:caseSensitive];
    NSInteger maxLength = max([self length], [string length]);
    CGFloat ratio = (CGFloat)distance / (CGFloat)maxLength;
    return ratio;
}

@end

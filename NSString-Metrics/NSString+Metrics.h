//
//  NSString+Metrics.h
//  NSString-Metrics
//
//  Created by Nikita Makarov on 11/04/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Metrics)

// Levenshtein distance
- (NSInteger)LevenshteinDistanceFromString:(NSString *)string
                             caseSensitive:(BOOL)caseSensitive;
- (NSInteger)LevenshteinDistanceFromString:(NSString *)string
                                insertCost:(NSInteger)insertCost
                                deleteCost:(NSInteger)deleteCost
                               replaceCost:(NSInteger)replaceCost
                             caseSensitive:(BOOL)caseSensitive;

- (CGFloat)normalizedLevenshteinDistanceFromString:(NSString *)string
                                     caseSensitive:(BOOL)caseSensitive;
- (CGFloat)normalizedLevenshteinDistanceFromString:(NSString *)string
                                        insertCost:(NSInteger)insertCost
                                        deleteCost:(NSInteger)deleteCost
                                       replaceCost:(NSInteger)replaceCost
                                     caseSensitive:(BOOL)caseSensitive;

// Damerau-Levenshtein distance
- (NSInteger)DamerauLevenshteinDistanceFromString:(NSString *)string
                                    caseSensitive:(BOOL)caseSensitive;
- (NSInteger)DamerauLevenshteinDistanceFromString:(NSString *)string
                                       insertCost:(NSInteger)insertCost
                                       deleteCost:(NSInteger)deleteCost
                                      replaceCost:(NSInteger)replaceCost
                                    transposeCost:(NSInteger)transposeCost
                                    caseSensitive:(BOOL)caseSensitive;

- (CGFloat)normalizedDamerauLevenshteinDistanceFromString:(NSString *)string
                                            caseSensitive:(BOOL)caseSensitive;
- (CGFloat)normalizedDamerauLevenshteinDistanceFromString:(NSString *)string
                                               insertCost:(NSInteger)insertCost
                                               deleteCost:(NSInteger)deleteCost
                                              replaceCost:(NSInteger)replaceCost
                                            transposeCost:(NSInteger)transposeCost
                                            caseSensitive:(BOOL)caseSensitive;

@end

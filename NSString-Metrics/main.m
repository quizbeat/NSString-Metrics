//
//  main.m
//  NSString-Metrics
//
//  Created by Nikita Makarov on 11/04/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Metrics.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *s1 = @"Abc";
        NSString *s2 = @"acb";
        
        NSLog(@"Levenshtein(%@, %@) = %li", s1, s2, [s1 LevenshteinDistanceFromString:s2 caseSensitive:NO]);
        NSLog(@"Damerau-Levenshtein(%@, %@) = %li", s1, s2, [s1 DamerauLevenshteinDistanceFromString:s2 caseSensitive:NO]);
        
        NSLog(@"--");
        
        NSLog(@"Levenshtein(%@, %@) = %li", s1, s2, [s1 LevenshteinDistanceFromString:s2 caseSensitive:YES]);
        NSLog(@"Damerau-Levenshtein(%@, %@) = %li", s1, s2, [s1 DamerauLevenshteinDistanceFromString:s2 caseSensitive:YES]);
        
        // ADD MORE TESTS
        
    }
    return 0;
}

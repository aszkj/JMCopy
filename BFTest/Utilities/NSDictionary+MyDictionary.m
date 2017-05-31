//
//  NSDictionary+MyDictionary.m
//  BFTest
//
//  Created by 伯符 on 17/3/4.
//  Copyright © 2017年 bofuco. All rights reserved.
//

#import "NSDictionary+MyDictionary.h"

@implementation NSDictionary (MyDictionary)

- (NSDictionary *)deleteAllNullValue{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        id result = [self objectForKey:keyStr];
        if (result == NULL || result == nil ||result == Nil ||result == NULL ||[result isEqual:@"null"] || [result isEqual:@"(null)"] ||[result isEqual:@"<null>"]||[result isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}
@end

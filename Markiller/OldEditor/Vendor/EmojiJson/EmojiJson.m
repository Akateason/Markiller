//
//  EmojiJson.m
//  Notebook
//
//  Created by teason23 on 2019/4/8.
//  Copyright © 2019 teason23. All rights reserved.
//

#import "EmojiJson.h"
#import <XTlib/XTlib.h>

@implementation EmojiJson

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"description" : @"descriptionEm",
             };
}

+ (NSArray *)allList {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"emojisJson" ofType:@"json"] ;
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *list  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return list ;
}

+ (EmojiJson *)list:(NSArray *)list random:(int)random {
    return [EmojiJson yy_modelWithJSON:list[random]] ;
}


@end

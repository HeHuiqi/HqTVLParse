//
//  HqTLVParse.m
//  HqTLVParse
//
//  Created by macpro on 2017/8/9.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "HqTLVParse.h"

@implementation HqTLVParse

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
- (NSDictionary<NSString *,HqTLVParse *> *)parseMutilTVLStrToDic:(NSString *)tlvstr{
    
    NSMutableDictionary *tlvs = [[NSMutableDictionary alloc]initWithCapacity:0];
    while (tlvstr.length>0) {
        HqTLVParse *parse = [self parseTLVStr:tlvstr];
        tlvstr = [tlvstr substringFromIndex:parse.tlvLength];
        tlvs[parse.tag] = parse;
    }
    return tlvs;
    
}
- (NSArray<HqTLVParse *> *)parseMutilTVLStrToArray:(NSString *)tlvstr{
    
    NSMutableArray *tlvs = [NSMutableArray arrayWithCapacity:0];
    
    while (tlvstr.length>0) {
        HqTLVParse *parse = [self parseTLVStr:tlvstr];
        tlvstr = [tlvstr substringFromIndex:parse.tlvLength];
        [tlvs addObject:parse];
    }
    
    return tlvs;
    
}
// 可添加自己设置的tag值即可解析
// 目前的是tag有 61，4F，9F70
- (id)parseTLVStr:(NSString *)dataStr{
    
    dataStr = dataStr.uppercaseString;
    int tagLength = 2;
    NSInteger tlvLength = 0;
    NSString *dataStrLengthStr = @"";
    
    //两位tag
    NSString *tag = [dataStr substringToIndex:tagLength];
    if ([tag isEqualToString:@"41"]||
        [tag isEqualToString:@"4F"]||
        [tag isEqualToString:@"61"]||
        [tag isEqualToString:@"80"]||
        [tag isEqualToString:@"81"]||
        [tag isEqualToString:@"87"]||
        [tag isEqualToString:@"88"]) {
        tag = [dataStr substringWithRange:NSMakeRange(0, tagLength)];
        dataStrLengthStr = [dataStr substringWithRange:NSMakeRange(tagLength, 2)];
    }
    
    //四位tag
    if ([tag isEqualToString:@"9F"]) {
        NSString *lTag = [dataStr substringWithRange:NSMakeRange(tagLength, 2)];
        tag = [dataStr substringToIndex:tagLength*2];
        if ([lTag isEqualToString:@"70"]) {
            tagLength = 4;
            tag = [dataStr substringWithRange:NSMakeRange(0, tagLength)];
        }
        dataStrLengthStr = [dataStr substringWithRange:NSMakeRange(tagLength, 2)];
        
    }
    
    //四位tag
    if ([tag isEqualToString:@"01"]) {
        NSString *lTag = [dataStr substringWithRange:NSMakeRange(tagLength, 2)];
        tag = [dataStr substringToIndex:tagLength*2];
        if ([lTag isEqualToString:@"0A"]) {
            tagLength = 4;
            tag = [dataStr substringWithRange:NSMakeRange(0, tagLength)];
        }
        dataStrLengthStr = [dataStr substringWithRange:NSMakeRange(tagLength, 2)];
        
    }
    NSUInteger dataStrLength = [self hexStrTolong:dataStrLengthStr];
    NSString *dataStrValue = [dataStr substringWithRange:NSMakeRange(tagLength+dataStrLengthStr.length, dataStrLength*2)];
    tlvLength = tag.length+dataStrLengthStr.length+dataStrValue.length;
    HqTLVParse *parse = [[HqTLVParse alloc]init];
    parse.tag = tag;
    parse.length = dataStrLength;
    parse.value = dataStrValue;
    parse.tlvLength  = tlvLength;
    
    return parse;
}
#pragma mark - 十六进制字符串转long
- (NSUInteger )hexStrTolong:(NSString *)hexStr{
    char *rest = (char *)[hexStr UTF8String];
    unsigned long sum = 0;
    for (int i = 0; i<hexStr.length; i++) {
        char j[1] = {rest[i]};
        unsigned long k =  strtoul(j,0,16);
        sum = sum + k*powf(16, hexStr.length - i - 1);
    }
    return sum;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"HqTVLParse=[tag=%@,length=%@,v=%@,tlvlength=%@]",self.tag,@(self.length),self.value,@(self.tlvLength)];
}
@end

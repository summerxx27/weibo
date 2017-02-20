//
//  NSString+XTAdd.m
//  XTWeibo
//
//  Created by zjwang on 16/9/14.
//  Copyright © 2016年 夏天然后. All rights reserved.
//

#import "NSString+XTAdd.h"

@implementation NSString (XTAdd)
- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    NSParameterAssert(attribute);
    CGFloat width = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        width = rect.size.width;
    }
    return width;
}
- (CGFloat)heightWithStringAttribute:(NSDictionary<NSString *,id> *)attribute
{
    NSParameterAssert(attribute);
    CGFloat height = 0;
    if (self.length) {
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        height = rect.size.height;
    }
    return height;
}

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    return [self sizeWithConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX) fromFont:font1 lineSpace:lineSpace];
}

- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    CGFloat minimumLineHeight = font1.pointSize,maximumLineHeight = minimumLineHeight, linespace = lineSpace;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)font1.fontName,font1.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    //Apply paragraph settings
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,(NSString*)kCTFontAttributeName,(__bridge id)style,(NSString*)kCTParagraphStyleAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    //    [self clearEmoji:string start:0 font:font1];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [string length]), NULL, size, NULL);
    CFRelease(framesetter);
    CFRelease(font);
    CFRelease(style);
    string = nil;
    attributes = nil;
    return result;
}

@end

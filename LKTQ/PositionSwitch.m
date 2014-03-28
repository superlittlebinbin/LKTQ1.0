//
//  PositionSwitch.m
//  故事盒子
//
//  Created by mac on 14-1-10.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "PositionSwitch.h"
#import "TypeDevice.h"
@implementation PositionSwitch
-(id)init
{
    if (self=[super init]) {
        typeDevice=[NSString stringWithString:[TypeDevice returnTypeName]];
        NSLog(@"type=%@",typeDevice);
    }
    return self;


}
-(CGRect)switchRect:(CGRect)rect
{
    printf("变化");
    float _x=rect.origin.x;
    float _y=rect.origin.y;
    float _w=rect.size.width;
    float _h=rect.size.height;
    if ([typeDevice isEqualToString:@"Type5"]) {
        rect=CGRectMake(_x, _y+88,_w, _h);//88
        
    }
    return rect;
}
-(CGPoint)switchPoint:(CGPoint)point
{
    float _x=point.x;
    float _y=point.y;
    
    if ([typeDevice isEqualToString:@"Type5"]) {
        point=CGPointMake(_x,_y+88);
    }
    return point;
}
-(CGRect)switchBound:(CGRect)rect
{
    printf("变化");
    float _x=rect.origin.x;
    float _y=rect.origin.y;
    float _w=rect.size.width;
    float _h=rect.size.height;
    if ([typeDevice isEqualToString:@"Type5"]) {
        rect=CGRectMake(_x, _y,_w, _h+88);//88
    }
    return rect;
}
-(void)dealloc
{
    [super dealloc];
}
@end

//
//  ShareView.h
//  LKTQ
//
//  Created by mac on 13-12-27.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionSwitch.h"
#import <ShareSDK/ShareSDK.h>
@protocol AccessHomeDelegate <NSObject>
-(void)clickPhotoPickup:(id)sender;
-(void)accessPhotoAblum;//相册
-(void)reloadimageView;
-(void)clear;

@end
@interface ShareView : UIView
{
    UIImageView *topView;//顶部导航栏
    UIButton * outputBtn;//导出保存按钮
    
    UIButton * outputAllBtn;//保存长图按钮
    UIView  *pannerShareView;//社会化分享容器
    
    NSMutableArray * imageVArr;
    NSMutableArray * textEditVArr;
    UIImage *img_Merged;
    NSString* pathImageM;
    PositionSwitch * positionSwitch;
    ShareType shareTypeSocial;
    
    UIImageView * bg;
    UIImageView * label;
    
}

@property(retain,nonatomic)id<AccessHomeDelegate>delegate;
@property(nonatomic,retain)  NSString* pathImageM;//合成图路径
@property(nonatomic,retain) UIImage *img_Merged;//社会化分享容器
@property(nonatomic,retain) UIView  *pannerShareView;//社会化分享容器
- (id)initWithFrame:(CGRect)frame  withImageVA:(NSMutableArray*)imageVA withTextEditVA:(NSMutableArray *)textEVA;

 
-(void)clickBack:(id)sender;
-(void)clickHome:(id)sender;
@end

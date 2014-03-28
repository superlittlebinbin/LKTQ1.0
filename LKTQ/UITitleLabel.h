//
//  UITextField.h
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITitleLabel: UIView<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UIImageView * imageViewBg;
//    UITextView  *_textView;
    UIView * maskTouch;
    BOOL used;
    
    int  index_colorLable;
    
    NSMutableArray * textVArray;
    UIScrollView * scView;//父视图
    
}
@property(retain,nonatomic) UIView * maskTouch;
@property(retain,nonatomic) UIImageView * imageViewBg;
@property(retain,nonatomic) UITextView * _textView;
@property(assign)BOOL used;
 
-(id)initWithFrame:(CGRect)frame  initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc;

-(void)startPanHandle;//父视图转换
-(void)endPanHandle;//父视图转换
@end

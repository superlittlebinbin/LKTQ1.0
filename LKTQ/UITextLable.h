//
//  UITextField.h
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextLable : UIView<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    UIImageView * imageViewBg;
    UITextView  *_textView;
    UIView * maskTouch;
    int rows_Char;//当前行数
    BOOL used;
    
    int currentMax;//记录最大行
    int curentRow_width;
    int  index_colorLable;
    int direction;//标签的方向0/1
    
    NSMutableArray * textVArray;
    UIScrollView * scView;//父视图
    
    NSMutableArray *lableArr;
    
}
@property(retain,nonatomic) UIView * maskTouch;
@property(retain,nonatomic) UIImageView * imageViewBg;
@property(retain,nonatomic) UITextView * _textView;
@property(assign)BOOL used;
 
-(id)initWithFrame:(CGRect)frame  initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc;

-(BOOL)textViewShouldEndEditing:(UITextView *)textView;
-(void)startPanHandle;//父视图转换
-(void)endPanHandle;//父视图转换
-(void)initWithLableArray:(NSMutableArray *)arrLable;

@end

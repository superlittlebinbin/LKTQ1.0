//
//  UITextField.m
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "UITitleLabel.h"

@implementation UITitleLabel
@synthesize _textView,imageViewBg;
@synthesize used;
@synthesize maskTouch;

#define image_width 60
#define image_height 60


-(id)initWithFrame:(CGRect)frame  initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        index_colorLable=index;//记录不同标签序号0~7
      
        textVArray=textVA;//文字视图 数组
        scView=sc;
        
        imageViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,image_width,image_height)];//
        [self initImage:tag withflag:index];//加载标签图片
        [self addSubview:imageViewBg];
        [imageViewBg release];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,imageViewBg.frame.size.width, imageViewBg.frame.size.height)];
        
        maskTouch=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
        [maskTouch setBackgroundColor:[UIColor clearColor]];
        [self addSubview:maskTouch];
        [maskTouch release];
        
        UITapGestureRecognizer * tapG=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapHandle:)];
        [maskTouch addGestureRecognizer:tapG];
        [tapG release];
        
        UIPanGestureRecognizer * panG=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:panG];
        [panG release];

        used=YES;
    }
    return self;
}

-(void)initImage:(int)tag withflag:(int)index
{
    NSString* strImg=[NSString stringWithFormat:@"%d%d.png",index,tag];
    UIImage *image = [UIImage imageNamed:strImg];//13 13 13 13
    [imageViewBg setFrame:CGRectMake(0, 0,  image.size.width/2,  image.size.height/2)];
    [imageViewBg setImage:image];
    
    
    
}


-(void)panHandle:(UIPanGestureRecognizer * )panG
{
    
    if (panG.state==UIGestureRecognizerStateBegan) {
        printf("kaishi");
        [self startPanHandle];
    }
    CGPoint center=self.center;
    CGPoint point= [panG translationInView:self];
    CGPoint newCenter=CGPointMake(center.x+point.x, center.y+point.y);
    
    [self setCenter:[self judgeTextlableBound:newCenter]];
   
    NSLog(@"x=%f,y=%f",self.center.x,self.center.y);
   [panG setTranslation:CGPointZero inView:self];

    if (panG.state==UIGestureRecognizerStateEnded) {
        [self endPanHandle];
    }
    
}
-(void)startPanHandle
{
    if (![self.superview isKindOfClass:[UIScrollView class]]) {//不在scrollview中 需要把其移入scrollview
        printf("不在sc");
       
        float _y=self.superview.frame.origin.y+self.frame.origin.y;//计算坐标Y
        printf("0==%f",_y);
        
//        [self removeFromSuperview];//父为textView
         printf("1");
        [self setFrame:CGRectMake(self.frame.origin.x, _y, self.frame.size.width, self.frame.size.height)];//
        printf("2");
        [scView addSubview:self];
         printf("3");
        
    }
    else{
    
        printf("在sc 中");
    }
    printf("over");
}
-(void)endPanHandle
{//把标签从scrollView移除，放入对应的textView
    printf("end-------");
    float _x=self.frame.origin.x;
    float _y=self.frame.origin.y;
    float _w=self.frame.size.width;
    float _h=self.frame.size.height;
    int d=-1;
    [self removeFromSuperview];
    
    int num=textVArray.count;
    int sum=0;

    UIView * _textV;
    for (int i=0; i<num; ++i) {
        _textV=[textVArray objectAtIndex: i];
        
        float max=_textV.frame.origin.y+_textV.frame.size.height-self.frame.size.height;//
        float min=_textV.frame.origin.y;
        float _bound=_textV.frame.origin.y+_textV.frame.size.height+4-self.frame.size.height/2;//边界
        float _bound2=_textV.frame.origin.y+_textV.frame.size.height+8;
        
        sum=min;//min
        if (_y<=max&&_y>=min) {
            d=i;//找到点击对应的视图序号
            _y=_y-sum;
            [self setFrame:CGRectMake( _x,_y,_w,_h)];
            [_textV addSubview:self];
            [_textV bringSubviewToFront:self];
            printf("退出");
            return;
        }
        else if(_y>max&&_y<=_bound)//中间区域偏上
        {
            printf("偏上");
            _y=_textV.frame.size.height-self.frame.size.height;
            [self setFrame:CGRectMake(_x,_y, _w,_h)];
            [_textV addSubview:self];
            [_textV bringSubviewToFront:self];
            return;
        }
        else if(_y>_bound &&_y<_bound2)//中间区域偏下
        {
            printf("循环下");
            float _y_new=_textV.frame.origin.y+_textV.frame.size.height+8;
            [self setFrame:CGRectMake(_x,_y_new, _w,_h)];
            _y=self.frame.origin.y;
            
        
        }
        else
            printf("无");
        
    }
    printf("sum=%d,d=%d,",sum,d);
   
 
}

-(CGPoint)judgeTextlableBound:(CGPoint)center
{
    //定义点的范围用四个点构成一个闭合的区域（可见区  x<320 Y<420）
    //左上开始顺时针
    //标签运动感区域默认 宽 高区域320 420//当图片高度小于420时，已实际高度作为运动区域
//    float _h=420;

    UIScrollView * sc=(UIScrollView*) self.superview;
    float _h=sc.contentSize.height-60;//区域高度
    NSLog(@"%@",self);
    printf("h=%f",_h);
    float _margin=10;
    if (self.superview.frame.size.height<_h) {
        _margin=0;
    }
    
    CGPoint point1=CGPointMake(self.frame.size.width/2, self.frame.size.height/2+_margin);//10 不想拖动顶部栏的下面
    CGPoint point2=CGPointMake(320-self.frame.size.width/2, self.frame.size.height/2+_margin);
//    CGPoint point3=CGPointMake(self.frame.size.width/2, 410-self.frame.size.height/2);
     CGPoint point4=CGPointMake(320-self.frame.size.width/2, _h-self.frame.size.height/2);//左下
    
    float x=0;
    float y=0;
 
    if (center.x <point1.x) {
        x=point1.x;
    }
    if (center.x>point2.x) {
        x=point2.x;
    }
    
    if (center.y<point1.y) {
        y=point1.y;
    }
    if (center.y>point4.y) {
        y=point4.y;
    }
    if (x||y) {//有越界
        if (x&&y) {
            return CGPointMake(x, y);
        }
        else if (x)
        {
            return CGPointMake(x, center.y);
        }
        else
        {
            return CGPointMake(center.x,y);
        
        }
       
    }
    else
    {
        return  center;
    }
}
-(void)tapHandle:(UITapGestureRecognizer * )tapG
{
    printf("taptitle");
    [self.superview bringSubviewToFront:self];

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
    [alert release];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {//确定删除
        case 1:
        {
            [self removeFromSuperview];
            break;
        }
        default:
            break;
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    printf("text touch");
    return;
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    [self.superview bringSubviewToFront:self];
//    printf("ing");
//    return YES;
//    
//}

//-(void)adjustTextLableCenter
//{
//    printf("上拉");
//    int bottom_y=self.frame.origin.y+self.frame.size.height;
//    if (bottom_y>340) {
//        self.transform=CGAffineTransformMakeTranslation(0, -200);
//    }
//    
//}
-(void)clear
{
    for (int i=0; i<self.subviews.count; ++i) {
        UIView * _v=[self.subviews objectAtIndex:i];
        [_v removeFromSuperview];
    }
}
-(void)dealloc
{
    [imageViewBg release];
    [_textView release];
    [super dealloc];
}
@end

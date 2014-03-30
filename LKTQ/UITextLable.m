//
//  UITextField.m
//  LKTQ
//
//  Created by mac on 13-12-3.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "UITextLable.h"

@implementation UITextLable
@synthesize _textView,imageViewBg;
@synthesize used;
@synthesize maskTouch;

#define Max_width 200//宽度上限
#define height_textView 25//25
//#define width_textView 120

#define min_width 30//初始化最小宽度30


-(id)initWithFrame:(CGRect)frame  initImage:(int)tag withFlagModel:(int)index withTextVArr:(NSMutableArray *)textVA withView:(UIScrollView *)sc
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        rows_Char=1;//默认字符行数为1
        currentMax=min_width;
        
        index_colorLable=index;//记录不同标签序号0~7
        direction=-1;//记录标签的方向
        int add_w=5;
        int add_h=5;//5

        
        textVArray=textVA;//文字视图 数组
        scView=sc;
 
        imageViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,min_width+add_w,height_textView+add_h)];//
        [self initImage:tag withflag:index];//加载标签图片
        [self addSubview:imageViewBg];
        [imageViewBg release];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y,imageViewBg.frame.size.width,imageViewBg.frame.size.height)];
        
        maskTouch=[[UIView alloc] initWithFrame:CGRectMake(0,0,imageViewBg.frame.size.width,imageViewBg.frame.size.height)];
        [maskTouch setBackgroundColor:[UIColor clearColor]];
        [self addSubview:maskTouch];
        [maskTouch release];
        UITapGestureRecognizer * tapG=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapHandle:)];
        [maskTouch addGestureRecognizer:tapG];
        [tapG release];
        
        float x_t=7;
        float y_t=2;
      
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(x_t, y_t, min_width, height_textView)];
        [_textView setBackgroundColor:[UIColor clearColor]];
        _textView.delegate=self;
        if (index==0) {
            _textView.text=@"";
        }
        _textView.text=@"";
        UIColor *color;
//        printf("=====%d",index_colorLable);
        NSLog(@"===%d,%d",index,tag);
        if ((index_colorLable==1&&tag==1)||index_colorLable==21) {//白色
            color=[UIColor blackColor];
        }
        else
        {
            color=[UIColor whiteColor];
        }
        
        _textView.textColor=color;
        _textView.font = [UIFont fontWithName:@"Arial" size:12.0];//12
        _textView.scrollEnabled=NO;
        [self addSubview: _textView];
        [_textView release];
        
        UIPanGestureRecognizer * panG=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:panG];
        [panG release];

       
        used=YES;
    }
    return self;
}

-(void)initWithLableArray:(NSMutableArray *)arrLable
{
    lableArr=arrLable;
}
-(void)initImage:(int)tag withflag:(int)index
{
    float top=22;//25
    float left=28;
    float bottom=25;
    float right=28;
 
 
//    NSLog(@"===%d,%d",index,tag);
    NSString* strImg=[NSString stringWithFormat:@"%d%d.png",index,tag];

    UIImage *image = [[UIImage imageNamed:strImg]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)];//13 13 13 13
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
    printf("tap");
    [self.superview bringSubviewToFront:self];
    if ([self._textView.text isEqualToString:@"@"]||[self._textView.text isEqualToString:@""]) {
        [self._textView becomeFirstResponder];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",@"编辑",nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
        [alert release];

    
    }
   
}

-(void)clearFromArrayLable
{
    printf("清除从数组");
    for (int i=0; i<lableArr.count; ++i) {
        UITextLable * la=[lableArr objectAtIndex:i];
        if ([la._textView.text isEqualToString:self._textView.text]) {
            [lableArr removeObjectAtIndex:i];
        }
    }


}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {//确定删除
        case 1:
        {
            [self clearFromArrayLable];
             
            [self removeFromSuperview];
            
            break;
        }
        case 2:
        {
            [self bringSubviewToFront:_textView];
            [_textView becomeFirstResponder];
            [self adjustTextLableCenter];
            
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

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.superview bringSubviewToFront:self];
    printf("ing");
    return YES;
    
}

-(void)updateFrame
{
    int add_w=10;//10
    int add_h=5;//20
    printf("烤麸==%d",index_colorLable);
    if (index_colorLable>=20) {
        if (direction==0) {
            add_w=20;//20
        }
        if (direction==1) {
            add_w=30;//20
        }
        add_h=0;
        printf("you-----");
    }
    printf("====%d",add_h);
    [imageViewBg setFrame:CGRectMake(0, 0,_textView.frame.size.width+add_w,_textView.frame.size.height+add_h)];
    [maskTouch setFrame:CGRectMake(0, 0, _textView.frame.size.width+add_w, _textView.frame.size.height+add_h)];
    [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, _textView.frame.size.width+add_w, _textView.frame.size.height+add_h)];

}
-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"began=%@",textView.text);
    NSString* str;
    CGSize s;
    int rows=0;
    int coutCharWidth=0;
    int maxHistorylength=0;
    int height_text=0;//
    for (int i=0; i<textView.text.length; ++i) {
        str=[NSString stringWithFormat:@"%C",[textView.text characterAtIndex:i]];
        s=[str sizeWithFont:[textView font]];
        height_text=height_text>s.height?height_text:s.height;
        if ([str isEqualToString:@"\n"]) {
              NSLog(@",%f,",s.width);
 
            if (coutCharWidth>maxHistorylength) {
                 maxHistorylength=coutCharWidth;//记录行宽
            }
            coutCharWidth=0;
            ++rows;
        }
        else if (coutCharWidth+s.width>Max_width)//超出，不加
        {
            printf("最大了");
            ++rows;
            maxHistorylength=Max_width;
            coutCharWidth=0;
            NSLog(@"r=%d",rows);
 
        }
        else
        {
            coutCharWidth=coutCharWidth+s.width;
            
        }
    }
    maxHistorylength= coutCharWidth>maxHistorylength?coutCharWidth:maxHistorylength;
 
    NSLog(@"max=%d",maxHistorylength);
    NSLog(@"row=%d",rows);
    if (maxHistorylength==Max_width) {
         [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, Max_width,height_textView+rows*height_text+5)];//3
    }
    else if(maxHistorylength!=Max_width&&maxHistorylength>17)
    {
         [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, maxHistorylength+s.height,height_textView+rows*height_text+5)];//3
    
    }
    else
    {
    
    
    }
    
   
    [self updateFrame];//更新背景大小
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.transform=CGAffineTransformIdentity;
    [textView resignFirstResponder];
    [self bringSubviewToFront:maskTouch];
        printf("失效");
    
    return YES;
}
-(void)adjustTextLableCenter
{
    printf("上拉");
    int bottom_y=self.frame.origin.y+self.frame.size.height;
    if (bottom_y>340) {
        self.transform=CGAffineTransformMakeTranslation(0, -200);
    }
    
}
-(void)clearView
{
    for (int i=0; i<self.subviews.count; ++i) {
        UIView *_v=[self.subviews objectAtIndex:i];
        [_v removeFromSuperview];
    }
}
-(void)dealloc
{
    printf("lable release");
    [self clearView];
    [super dealloc];
}
@end

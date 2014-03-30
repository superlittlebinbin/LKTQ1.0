//
//  ModifyImageView.m
//  故事盒子
//
//  Created by mac on 14-3-3.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "ModifyImageView.h"
#import "ClipViewController.h"
#import "CameraCustom.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

int Start_y_ColorPanel;//410功能容器
#define _width 320
#define width_btn_bar 160
#define Height_btn_bar 44
#define gap_btn_bar 160
#define width_More_btn_bar 67
#define height_More_btn_bar 16
#define height_textEditView 640//文字层高度
#define Height_ColorPanel 50//功能容器高度
#define Height_subPanel 45  //子功能列表高度
#define width_subbtn_bar 26 //子功能列表按钮
#define Height_subbtn_bar 26
#define x_imgView 0
#define y_imgView 80//100

@implementation ModifyImageView
@synthesize delegate;
-(id)initWithImageView:(UIImageView*)imgV withTextView:(UIView*)textV withIndex:(int)index   withScrollView:(UIScrollView *)sc withTextArray:(NSMutableArray*)textArray withImageArray:(NSMutableArray*)imageArray
{
    
    self = [super init];
    if (self) {
        if(IS_IPHONE_5)
        {
            
            Start_y_ColorPanel=524;
            [self setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else
        {
            Start_y_ColorPanel=436;
            [self setFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        [self  setBackgroundColor:[UIColor blackColor]];
        state_V=NO;
        state_H=NO;
        
        [imgV setFrame:CGRectMake(0,45, imgV.frame.size.width, imgV.frame.size.height)];
        [textV setFrame:imgV.frame];
        
        [self addSubview:imgV];
        [self addSubview:textV];
        
        currentImageView=imgV;
         _textV=textV;
        _textV.hidden=YES;
        _sc=sc;
        imageCG= CGImageCreateCopy(currentImageView.image.CGImage) ;
       
        
        imageIndex=index;
        imageViewArr=imageArray;
        textViewArr=textArray;
        
        imageTrangsform=currentImageView.transform;
        
        [self initColorPanel];
        [self initSubFunction];
        [self initNavigationBar];
        [self bringSubviewToFront:NavigationView];
        [self bringSubviewToFront:imageBarView];
        [self bringSubviewToFront:subFunctionView];
    }
    return  self;
   
    

}

//导栏
-(void)initNavigationBar
{
    NavigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    UIImageView *NavigationViewBg= [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45) ] initWithImage:[UIImage imageNamed:@"editTopView.png"]];
    [NavigationView addSubview:NavigationViewBg];
    [self addSubview:NavigationView];
    [NavigationViewBg release];
    [NavigationView release];
    
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(10, 15, 88,16)];
    [back setImage:[UIImage imageNamed:@"editBackBtn.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:back];
    
    UIButton* finish=[UIButton buttonWithType:UIButtonTypeCustom];
    [finish setFrame:CGRectMake(262, 15, 48,15)];
    [finish setImage:[UIImage imageNamed:@"editFinishBtn.png"] forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(finishEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:finish];
}

-(void)backEdit:(id)sender
{
    currentImageView.transform=imageTrangsform;
    
    [currentImageView setImage:[UIImage imageWithCGImage:imageCG]];

    
    [_sc addSubview:currentImageView];
    [_sc addSubview:_textV];
    _textV.hidden=NO;
    [self reloadScrollview];
    [self.delegate hiddenTopView:NO];
    

    [self removeFromSuperview];
    
}

-(void)finishEdit:(id)sender
{
   
    [self reSetImgView];
    [_sc addSubview:currentImageView];
    [_sc addSubview:_textV];
     _textV.hidden=NO;
     [self reloadScrollview];
    
     [self.delegate hiddenTopView:NO];
    [self removeFromSuperview];
    
    
}
//更新图片和文字层
-(void)reSetImgView
{
    
    UIView * temp_textView=[textViewArr objectAtIndex:imageIndex];
    for (int i=0; i<temp_textView.subviews.count; ++i) {
        UIView * temp=[temp_textView.subviews objectAtIndex:i];
        [temp removeFromSuperview];
    }
    NSString * _path=[CameraCustom pathOfTempImage];
    
    [CameraCustom SaveToBoxForTempImage:[CameraCustom singleImage:currentImageView withTextView:temp_textView] withPath: _path];

    float _x=currentImageView.frame.origin.x;
    float _y=currentImageView.frame.origin.y;
    float _w=currentImageView.frame.size.width;
    float _h=currentImageView.frame.size.height;
    currentImageView.transform=CGAffineTransformIdentity;
    
    NSLog(@"%@",currentImageView);
    [currentImageView setImage:[UIImage imageWithContentsOfFile:_path]];
    [currentImageView setFrame: CGRectMake(_x, _y, _w, _h)];
    
    [self anjustTextLableOFView:_textV];
    [_textV setFrame:currentImageView.frame];
    
    [_textV removeFromSuperview];
    [currentImageView removeFromSuperview];
  
}
-(void)anjustTextLableOFView:(UIView*)_v
{
    UIView *_temp=nil;
    float  dis=0;
    for (int i=0; i<_v.subviews.count; ++i) {
        _temp=[_v.subviews objectAtIndex:i];
        dis=dis+ _temp.frame.size.height;
        [_temp setFrame:CGRectMake(40,30+dis, _temp.frame.size.width, _temp.frame.size.height)];
        
    }
  
}

-(void)reloadScrollview
{
    int height=0;
    int  _y=0;//two图片Y坐标
    for (int i=0; i<imageViewArr.count; ++i) {
        UIImageView * imgv;
        UIView *textv;
        if(i==imageIndex)
        {
            imgv=currentImageView;
            textv=_textV;
        }
        else{
            imgv=[imageViewArr objectAtIndex:i];
            textv=[textViewArr objectAtIndex:i];
            
        }
        [imgv setFrame:CGRectMake(0,_y,imgv.frame.size.width, imgv.frame.size.height)];
        [textv setFrame:imgv.frame];
        height=height+imgv.frame.size.height;
       
        _y=_y+imgv.frame.size.height+8;
        
    }
    [_sc setContentSize:CGSizeMake(320,height+60)];//更新滚动视图的内容大小
  
}

-(void)initColorPanel//初始化图片功能栏
{
    ///剪切 旋转 删除面板
    //变化
    NSLog(@"%d is the width,%d is the ColorPanel.\n",_width,Start_y_ColorPanel);
    imageBarView=[[UIView alloc] initWithFrame:CGRectMake(0,Start_y_ColorPanel, _width, 44)];//功能面板背景
    [imageBarView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageBarView];
    [imageBarView release];

    
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
    [imgV setImage:[UIImage imageNamed:@"functionBg.png"]];
    [imageBarView addSubview:imgV];
    
    UIButton*  btnCutting=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCutting setFrame:CGRectMake(0, 0, width_btn_bar,Height_btn_bar)];
    //    [btnCutting setTitle:@"裁剪" forState:UIControlStateNormal];
    [btnCutting setImage:[UIImage imageNamed:@"clipBtn.png"] forState:UIControlStateNormal];
    [btnCutting addTarget:self action:@selector(clickCutting:) forControlEvents:UIControlEventTouchUpInside];
    [imageBarView addSubview:btnCutting];
    
    UIButton* btnRotateLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotateLeft setFrame:CGRectMake(0+gap_btn_bar, 0, width_btn_bar,Height_btn_bar)];
    //    [btnRotateLeft setTitle:@"左旋" forState:UIControlStateNormal];
    [btnRotateLeft setImage:[UIImage imageNamed:@"rotateBtn.png"] forState:UIControlStateNormal];
    [btnRotateLeft addTarget:self action:@selector(clickRotate:) forControlEvents:UIControlEventTouchUpInside];
    [imageBarView addSubview:btnRotateLeft];
    
    //    UIButton* btnRotateRight=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnRotateRight setFrame:CGRectMake(gap_btn_bar*2+20, 4, width_btn_bar,Height_btn_bar)];
    ////    [btnRotateRight setTitle:@"滤镜" forState:UIControlStateNormal];
    //     [btnRotateRight setImage:[UIImage imageNamed:@"filterBtn.png"] forState:UIControlStateNormal];
    //    [btnRotateRight addTarget:self action:@selector(clickFilter:) forControlEvents:UIControlEventTouchUpInside];
    //    [imageBarView addSubview:btnRotateRight];
    
//    UIButton* btnRotateRight=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnRotateRight setFrame:CGRectMake(gap_btn_bar*2+20, 4, width_btn_bar,Height_btn_bar)];
//    //    [btnRotateRight setTitle:@"滤镜" forState:UIControlStateNormal];
//    [btnRotateRight setImage:[UIImage imageNamed:@"filterBtn.png"] forState:UIControlStateNormal];
////    [btnRotateRight addTarget:self action:@selector(clickAddImage:) forControlEvents:UIControlEventTouchUpInside];
//    [imageBarView addSubview:btnRotateRight];
    
    
//    UIButton* btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnDelete setFrame:CGRectMake(gap_btn_bar*3+20,4, width_btn_bar,Height_btn_bar)];
//    //    [btnDelete setTitle:@"删除" forState:UIControlStateNormal];
//    [btnDelete setImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
////    [btnDelete addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
//    [imageBarView addSubview:btnDelete];
    
//    UIButton* btnMore=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnMore setFrame:CGRectMake(gap_btn_bar*4+20, 4, width_btn_bar,Height_btn_bar)];
//    //    [btnMore setTitle:@"更多" forState:UIControlStateNormal];
//    [btnMore setImage:[UIImage imageNamed:@"moreFunctionBtn.png"] forState:UIControlStateNormal];
////    [btnMore addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
//    [imageBarView addSubview:btnMore];
    
    
    //更多容器
    //界面适应
    moreFunction=[[UIView alloc] initWithFrame:CGRectMake(186,Start_y_ColorPanel-80,134, 80)];
    [moreFunction setBackgroundColor:[UIColor clearColor]];
    moreFunction.hidden=YES;
    [self addSubview:moreFunction];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, moreFunction.frame.size.width, moreFunction.frame.size.height)];
    [imgView setImage:[UIImage imageNamed:@"moreFunctionBg.png"]];
    [moreFunction addSubview:imgView];
    
    
    UIImageView * imgf=[[UIImageView alloc] initWithFrame:CGRectMake(11, 5, 30, 26)];
    [imgf setImage:[UIImage imageNamed:@"frontMoveBg.png"]];
    [moreFunction addSubview:imgf];
    UIButton * frontMove=[UIButton buttonWithType:UIButtonTypeCustom];
    [frontMove setFrame:CGRectMake(48, 12, width_More_btn_bar, height_More_btn_bar)];
    //    [frontMove setTitle:@"前移" forState:UIControlStateNormal];
    [frontMove setImage:[UIImage imageNamed:@"frontMoveBtn.png"] forState:UIControlStateNormal];
    [frontMove addTarget:self action:@selector(clickFrontMove:) forControlEvents:UIControlEventTouchUpInside];
    [moreFunction addSubview:frontMove];
    
    UIImageView * imgb=[[UIImageView alloc] initWithFrame:CGRectMake(11, 5+40, 30, 26)];
    [imgb setImage:[UIImage imageNamed:@"backMoveBg.png"]];
    [moreFunction addSubview:imgb];
    UIButton * backMove=[UIButton buttonWithType:UIButtonTypeCustom];
    [backMove setFrame:CGRectMake(48, 12+40, width_More_btn_bar, height_More_btn_bar)];
    //    [backMove setTitle:@"后移" forState:UIControlStateNormal];
    [backMove setImage:[UIImage imageNamed:@"backMoveBtn.png"] forState:UIControlStateNormal];
    [backMove addTarget:self action:@selector(clickBackMove:) forControlEvents:UIControlEventTouchUpInside];
    [moreFunction addSubview:backMove];
    
    
}
-(void)initSubFunction
{
    
    subFunctionView=[[UIView alloc]initWithFrame:CGRectMake(0,Start_y_ColorPanel-Height_subPanel, _width, Height_ColorPanel)];
    subFunctionView.hidden=YES;
    [self addSubview:subFunctionView];
    
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, Height_subPanel)];
    [imgV setImage:[UIImage imageNamed:@"subFunctionBg.png"]];
    [subFunctionView addSubview:imgV];
    
    
    UIButton* btnRotateLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotateLeft setFrame:CGRectMake(45, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnRotateLeft setTitle:@"左旋" forState:UIControlStateNormal];
    [btnRotateLeft setImage:[UIImage imageNamed:@"leftRotaeBtn.png"] forState:UIControlStateNormal];
    [btnRotateLeft addTarget:self action:@selector(clickRotateLeft:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnRotateLeft];
    
    UIButton* btnRotateRight=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotateRight setFrame:CGRectMake(113, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnRotateRight setTitle:@"右旋" forState:UIControlStateNormal];
    [btnRotateRight setImage:[UIImage imageNamed:@"rightRotaeBtn.png"] forState:UIControlStateNormal];
    [btnRotateRight addTarget:self action:@selector(clickRotateRight:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnRotateRight];
    
    UIButton* btnTurnToL=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTurnToL setFrame:CGRectMake(181, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnTurnToL setTitle:@"垂直" forState:UIControlStateNormal];
    [btnTurnToL setImage:[UIImage imageNamed:@"verticalMirror.png"] forState:UIControlStateNormal];
    [btnTurnToL addTarget:self action:@selector(clickTurnToL:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnTurnToL];
    
    UIButton*  btnTurnToR=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnTurnToR setFrame:CGRectMake(249, 6, width_subbtn_bar,Height_subbtn_bar)];
    //    [btnTurnToR setTitle:@"水平" forState:UIControlStateNormal];
    [btnTurnToR setImage:[UIImage imageNamed:@"levelMirror.png"] forState:UIControlStateNormal];
    [btnTurnToR addTarget:self action:@selector(clickTurnToR:) forControlEvents:UIControlEventTouchUpInside];
    [subFunctionView addSubview:btnTurnToR];
    
}
-(void)clickCutting:(id)sender
{
    
    printf("clip");
    ClipViewController* clipViewC=[[ClipViewController alloc] initWithNibName:@"ClipViewController_iPhone" bundle:nil];
    [clipViewC initWith:currentImageView.image with:self withDelegate:self];
    [self.superview addSubview:clipViewC.view];
    
    [self removeFromSuperview];
    
    
    moreFunction.hidden=YES;
}
-(void)clickRotate:(id)sender
{
    printf("子功能");
    if (subFunctionView.hidden) {
        printf("hidd");
        subFunctionView.hidden=NO;
    }
    else
    { printf("yes dis");
        subFunctionView.hidden=YES;
    }
    
    moreFunction.hidden=YES;
    
}
-(void)clickFilter:(id)sender
{
    printf("滤镜");
    
}
-(void)clickRotateLeft:(id)sender
{
    printf("click1");
    
    float h_img=currentImageView.frame.size.height;
    CGPoint  center=currentImageView.center;
    CGAffineTransform newTrangsform;
    switch (currentImageView.tag) {
        case 0:
            newTrangsform=CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1.5),320/h_img, 320/h_img);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:3];
            break;
        case 3:
            newTrangsform=CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1), 1, 1);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:2];
            break;
        case 2:
            newTrangsform=CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*0.5), 320/h_img, 320/h_img);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:1];
            break;
        case 1:
            newTrangsform=CGAffineTransformIdentity;
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:0];
            break;
        default:
            break;
    }
    
    
    [textEditView setFrame:CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, currentImageView.frame.size.width, currentImageView.frame.size.height)];
    
    textEditView.center=center;
    currentImageView.center=center;
    
}
-(void)clickRotateRight:(id)sender
{
    CGPoint  center=currentImageView.center;
    CGAffineTransform newTrangsform;
    float h_img=currentImageView.frame.size.height;
    
    switch (currentImageView.tag) {
        case 0:
            newTrangsform=CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*0.5), 320/h_img, 320/h_img);//高，宽
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:1];
            break;
        case 1:
            newTrangsform=CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1), 1, 1);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:2];
            break;
        case 2:
            newTrangsform=CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI*1.5), 320/h_img,320/h_img);
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:3];
            break;
        case 3:
            newTrangsform=CGAffineTransformIdentity;
            currentImageView.transform=newTrangsform;
            [currentImageView setTag:0];
            break;
        default:
            break;
    }
    
    [textEditView setFrame:CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, currentImageView.frame.size.width, currentImageView.frame.size.height)];
    textEditView.center=center;
    currentImageView.center=center;
    
    printf("click1");
    
}
-(void)clickTurnToL:(id)sender
{
    printf("垂直");
    CGPoint  center=currentImageView.center;
    int flag=currentImageView.tag;
    UIImageOrientation  imageOrientation;
    switch (flag) {
        case 0://竖着
        case 2:
            imageOrientation=UIImageOrientationDownMirrored;
            break;
        case 1:
        case 3://横着
            imageOrientation=UIImageOrientationUpMirrored;
            
            break;
        default:
            break;
    }
    if (!state_V) {
        UIImage * img=[UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:imageOrientation];
        [currentImageView setImage:img];
        
        
        
        state_V=YES;
    }
    else
    {
        UIImage * img=[UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];
        [currentImageView setImage:img];
        state_V=NO;
        
    }
    
    currentImageView.center=center;
    printf("垂直over");
    
}
-(void)clickTurnToR:(id)sender
{
    printf("水平");
    CGPoint  center=currentImageView.center;
    int flag=currentImageView.tag;
    UIImageOrientation  imageOrientation;
    switch (flag) {
        case 0://竖着
        case 2:
            imageOrientation=UIImageOrientationUpMirrored;
            break;
        case 1:
        case 3://横着
            imageOrientation=UIImageOrientationDownMirrored;
            break;
        default:
            break;
    }
    
    if (!state_H) {
        UIImage * img=[UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:imageOrientation];//UIImageOrientationUpMirrored
        [currentImageView setImage:img];
        state_H=YES;
    }
    else
    {
        UIImage * img=[UIImage imageWithCGImage:currentImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];//UIImageOrientationUp
        [currentImageView setImage:img];
        state_H=NO;
        
    }
    
    currentImageView.center=center;
    printf("水平");
}

-(void)UpdateCurrentImage:(UIImage*)img
{
    float img_w=img.size.width;
    float img_h=img.size.height;
    img_h=img_h*_width/img_w;//转换
    NSLog(@"高度:%f,宽度;%d",img_h,_width);
    if (_width>img_h) {
         [currentImageView setFrame:CGRectMake(0, y_imgView, _width, img_h)];
    }
    else
    {
         [currentImageView setFrame:CGRectMake(0, 0, _width, img_h)];

    }
    if(IS_IPHONE_5)
    {
        [currentImageView setCenter:CGPointMake(160, 284)];
    }
    else
    {
        [currentImageView setCenter:CGPointMake(160, 240)];
    }
    [currentImageView setImage:img];

}

//-(void)clickFrontMove:(id)sender
//{
//    printf("front");
//    
//    int front=current_index-1;
//    printf("index=%d",front);
//    if (front>=0) {
//        [imageViewArray exchangeObjectAtIndex:current_index withObjectAtIndex:front];
//        current_index=front;
//    }
//    
//    swipeG=1;
//    [self clickRight:nil];
//    
//    moreFunction.hidden=YES;
//}
//-(void)clickBackMove:(id)sender
//{
//    printf("back");
//    
//    
//    int next=current_index+1;
//    printf("next=%d",next);
//    if (next<imageViewArray.count) {
//        [imageViewArray exchangeObjectAtIndex:current_index withObjectAtIndex:next];
//        current_index=next;
//    }
//    
//    swipeG=-1;
//    [self clickLeft:nil];
//    
//    moreFunction.hidden=YES;
//}

//-(void)clickDelete:(id)sender//删除当前图片和文字层
//{
//    swipeG=1;
//    [self clickRight:nil];//显示右边的
//    
//    int del_index=current_index-1;
//    if (del_index==-1) {//最后一张
//        del_index=imageArray.count-1;
//    }
//    else
//    {
//        current_index--;
//    }
//    
//    if (del_index>=0&&imageArray.count>1) {
//        [imageArray removeObjectAtIndex:del_index];
//        [imageViewArray removeObjectAtIndex:del_index];
//        [textEditViewArray removeObjectAtIndex:del_index];
//        
//    }
//    else
//    {//del按钮失效
//        
//        
//    }
//    moreFunction.hidden=YES;
//    printf("click1");
//}
//-(void)clickAddImage:(id)sender
//{
//    printf("add image");
//    [self.delegate accessPhotoAblum];
//    moreFunction.hidden=YES;
//    
//}
-(void)clickMore:(id)sender
{
    if (moreFunction.hidden) {
        moreFunction.hidden=NO;
    }
    else
    {
        moreFunction.hidden=YES;
    }
    
}

-(void)tapHandle:(UIGestureRecognizer *)tapD
{
    printf("tap");
//    //    CGPoint  point=[tapD locationInView:self];
//    if (CGRectContainsPoint(imageBarView.frame, [tapD locationInView:self])||CGRectContainsPoint(gemomtryView.frame, [tapD locationInView:gemomtryView]))
//    {
//        return;
//    }
//    else
//    {
//        if (gemomtryView.hidden==NO) {
//            //            gemomtryView.hidden=YES;模板标签栏
//            //            imageBarView.hidden=NO;//图片工具栏
//            //            [self.delegate hiddenTopView:NO];//顶部工具栏
//            
//        }
//        else
//        {
//            gemomtryView.hidden=NO;
//            imageBarView.hidden=YES;
//            
//            
////            [self.delegate hiddenTopView:YES];
//        }
//        
//        subFunctionView.hidden=YES;
//        subGemomtryView.hidden=YES;
//        moreFunction.hidden=YES;
//        simlarGemomtryView.hidden=YES;
//        [self resignTextLable];
//    }
    
}

-(void)dealloc
{
    [super dealloc];
}

@end

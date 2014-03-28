//
//  SelectTitleView.m
//  故事盒子
//
//  Created by caijunbin on 14-3-17.
//  Copyright (c) 2014年 sony. All rights reserved.
//
#import "UITitleLabel.h"
#import "SelectTitleView.h"
#define start_x 5
#define start_y 20
#define title_width 100
#define title_height 123
#define title_gar 103
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@implementation SelectTitleView
@synthesize delegate;
@synthesize positionSwich;
@synthesize selectView;
int x;
-(id)initWithScrollView:(UIScrollView *)scrollView withTextArr:(NSMutableArray *)arr
{
    self = [super init];
    if (self) {
        positionSwich=[[PositionSwitch alloc] init];
        if(IS_IPHONE_5)
        {
            [self setFrame:CGRectMake(0, 0, 320, 568)];
            selectView=[[UIScrollView alloc] initWithFrame:[positionSwich switchBound:CGRectMake(0, 45, 320,568-45)]];
            [selectView setContentSize:CGSizeMake(320,568)];
        }
        else
        {
            [self setFrame:CGRectMake(0, 0, 320, 480)];
            selectView=[[UIScrollView alloc] initWithFrame:[positionSwich switchBound:CGRectMake(0, 45, 320,480-45)]];
            [selectView setContentSize:CGSizeMake(320,480)];

        }
    }
    x=0;
    _sc=scrollView;
    textEditViewArray=arr;
    [selectView setBackgroundColor:[UIColor colorWithRed:(38.0/255) green:(43.0/255) blue:49.0/255 alpha:0.9]];;
    [self addSubview:selectView];
    [selectView release];
    
    [self  setBackgroundColor:[UIColor blackColor]];
    [self initNavigationBar];
    [self initTitleWithNumber:2];
    [self bringSubviewToFront:NavigationView];
    return  self;
}

-(void)initNavigationBar
{
    NavigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    [NavigationView setBackgroundColor:[UIColor colorWithRed:(28.0/255) green:(33.0/255) blue:39.0/255 alpha:0.95]];
    [self addSubview:NavigationView];
    [NavigationView release];
    
    UIButton* back=[UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(20, 15, 40,15)];
    [back setImage:[UIImage imageNamed:@"titleBackBtn.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backEdit:) forControlEvents:UIControlEventTouchUpInside];
    [NavigationView addSubview:back];
    
//    UIButton* finish=[UIButton buttonWithType:UIButtonTypeCustom];
//    [finish setFrame:CGRectMake(200, 4, 60,44)];
//    [finish setTitle:@"完成" forState:UIControlStateNormal];
//    [finish addTarget:self action:@selector(finishEdit:) forControlEvents:UIControlEventTouchUpInside];
//    [NavigationView addSubview:finish];
}

-(void)initTitleWithNumber:(int)numberOfTitle
{
    selectedSignal=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [selectView setContentSize:CGSizeMake(320,start_y+(numberOfTitle/2+numberOfTitle%2)*title_gar+title_height)];
    for(int i =0;i<numberOfTitle;i++)
    {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(start_x+i%3*title_gar,start_y+i/3*title_gar, title_width, title_height)];
            [btn setTag:i];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"button3%d.png",i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickAddTitle:) forControlEvents:UIControlEventTouchUpInside];
            [selectView addSubview:btn];
    }
}
-(void)clickAddTitle:(id)sender
{
    printf("添加标题");
    x=[sender tag];
    UITitleLabel *label=[[UITitleLabel alloc]initWithFrame:CGRectMake(100, _sc.contentOffset.y+100, 200, 100) initImage:x withFlagModel:3 withTextVArr:textEditViewArray withView:_sc];
    [_sc addSubview:label];
  
    
    [label endPanHandle];
    [self.delegate hiddenTopView:NO];
    
//    [label release];
    [self removeFromSuperview];
    
}
-(void)backEdit:(id)sender
{
    [self.delegate hiddenTopView:NO];
    [self removeFromSuperview];
//    UITitleLabel *label=[[UITitleLabel alloc]initWithFrame:CGRectMake(100, _sc.contentOffset.y+100, 85, 99) initImage:x withFlagModel:3 withTextVArr:textEditViewArray withView:_sc];
//    [_sc addSubview:label];
//   
//    [label endPanHandle];
//    [self.delegate hiddenTopView:NO];
//    [label release];
//    [self removeFromSuperview];

}

//-(void)finishEdit:(id)sender
//{
//    printf("完成编辑");
//    UITitleLabel *label=[[UITitleLabel alloc]initWithFrame:CGRectMake(100, _sc.contentOffset.y+100, 85, 99) initImage:x withFlagModel:3 withTextVArr:textEditViewArray withView:_sc];
//    [_sc addSubview:label];
//    [label endPanHandle];
//    [self.delegate hiddenTopView:NO];
//    [label release];
//    [self removeFromSuperview];
//}
-(void)dealloc
{
    [positionSwich release];
    [super dealloc];
}
@end

//
//  HomeViewController.m
//  LKTQ
//
//  Created by mac on 13-12-2.
//  Copyright (c) 2013年 sony. All rights reserved.
//

#import "HomeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MHImagePickerMutilSelector.h"
#import <SinaWeiboConnection/SinaWeiboConnection.h>

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize sheet,picker;
@synthesize imagePkViewC;
-(id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        show=NO;
        isadd=NO;
        [self barControl];
       
    }
    return self;

}
-(void)barControl
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }


}
- (BOOL)prefersStatusBarHidden
{
    printf("父控制执行");
    if (!show) {
        printf("1");
        show=YES;
    }
    else
    {
        printf("2");
        show=NO;
    }
    return YES;//隐藏为YES，显示为NO
//    return show;
}
-(void)clickPhotoPickup:(id)sender//相册
{
//    //方法一
//    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//
//    imagePickerController.limitsMaximumNumberOfSelection=YES;
//    imagePickerController.maximumNumberOfSelection= 12;  //设置限制的张数
//
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//    [self presentViewController:navigationController animated:YES completion:NULL];
//    [imagePickerController release];
//    [navigationController release];
    
    //方法二
    NSArray* arr=(NSArray*)sender;
    [MHImagePickerMutilSelector showInViewController:self withArr:arr];
    
}
-(void)imagePickerMutilSelectorDidGetImages:(NSArray*)imageArray
{
    printf("do");
    imageA=imageArray;
    [self jumpToImagePkVC:imageA];

}
//
//- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
//{
//    printf("选择完毕");
//    NSArray *mediaInfoArray = (NSArray *)info;
//    NSLog(@"选择了 %d 图片", mediaInfoArray.count);
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self jumpToImagePkVC:mediaInfoArray];
//    
//}
//- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
//{
//    printf("picker cancell");//取消
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
-(void)jumpToImagePkVC:(NSArray*)array//跳转页面
{
    printf("跳转页面");
    NSArray* array_temp;
    
//    if (imagePkViewC) {
//        if (imagePkViewC.addIS) {
//           array_temp=[imagePkViewC addImageToImageArray:array];
//            printf("test图片===%d,",array_temp.count);
//            [imagePkViewC setAddIS:NO];
//            isadd=YES;
//        }
//        else
//        {
//            array_temp=array;
//        
//        }
//        
//    }
//    else
//    {
        array_temp=array;
    
    
//    }
    
     printf("最后图片===%d,",array_temp.count);
    self.imagePkViewC=[[ImagePickupViewController alloc] initWithNibName:@"ImagePickupView" bundle:nil];
    
//    if (isadd) {
//        [imagePkViewC addUpdateImageArray:array_temp];
//        isadd=NO;
//    }
//    else
//    {
        [imagePkViewC updateImageArray:array_temp];
    
//    }
    imagePkViewC.delegate=self;
    [self.view addSubview:imagePkViewC.view];
    [imagePkViewC.view release];//add
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc ];
}
@end

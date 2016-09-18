//
//  IJKMediaPlayerVC.m
//  AudioAndVideo
//
//  Created by fy on 16/9/13.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "IJKMediaPlayerVC.h"

#import <IJKMediaFramework/IJKMediaFramework.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#define screenSize [UIScreen mainScreen].bounds.size

@interface IJKMediaPlayerVC ()

@property(atomic,strong)id <IJKMediaPlayback> player;

@end

@implementation IJKMediaPlayerVC



#pragma mark - 屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate{
    
    return YES;
    
}
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //配置播放器
    [self setupPlayer];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //准备播放
    [self.player prepareToPlay];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //释放掉播放器
    [self.player stop];
    
    [self.player shutdown];
}

#pragma mark - 配置播放器
-(void)setupPlayer{
    
    // 检查当前FFmpeg版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    // IJKFFOptions 是对视频的配置信息
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    //是否要展示配置信息指示器(默认为NO)
    options.showHudView = NO;
    
    //创建播放器,配置
    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:self.url] withOptions:options];
    
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGFloat width = MAX(screenSize.width, screenSize.height);
    
    CGFloat height = MIN(screenSize.width, screenSize.height);
    
    //判断横竖屏
    if (screenSize.width>400) {
        
        //横屏
        self.player.view.frame = CGRectMake(0, 0, width, height);
        
    } else {
        //竖屏
        self.player.view.frame = CGRectMake(0, 0, screenSize.width, 300);
    }
    
    //监听屏幕翻转通知
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] subscribeNext:^(id x) {
        
        if (screenSize.width>400) {
            
            //横屏
            self.player.view.frame = CGRectMake(0, 0, width, height);
            
        } else {
            //竖屏
            self.player.view.frame = CGRectMake(0, 0, screenSize.width, 300);
        }
        
        [self.player.view setNeedsDisplay];
    }];
    
    //ijkplaeyer缩放模式
    self.player.scalingMode = IJKMPMovieScalingModeFill;
    
    //打开自动播放
    self.player.shouldAutoplay = YES;
    
    //播放器背景颜色
    self.player.view.backgroundColor = [UIColor whiteColor];
    
    self.view.autoresizesSubviews = YES;
    
    [self.view addSubview:self.player.view];
    
    [self.player play];
}


@end

//
//  ViewController.m
//  VedioPlayUse
//
//  Created by xy on 2019/3/14.
//  Copyright © 2019年 xy. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@property (nonatomic, strong)AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"b" withExtension:@"mp4"];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    //[item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:item];
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"播放中%f",CMTimeGetSeconds(time));
    }];
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = self.view.bounds;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:layer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

//播放结束
- (void)playEnd {
    NSLog(@"播放完了");
}

//暂停
- (IBAction)begin:(id)sender {
    //rate 0意味着暂停 1是正常播放
    if (self.player.rate > 0.1) {
        [self.player pause];
    }
    
}

//播放
- (IBAction)end:(id)sender {
    [self.player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    NSDictionary *useDic = (NSDictionary *)change;
    if ([useDic[@"new"] integerValue] == AVPlayerItemStatusReadyToPlay) {
        NSLog(@"prepare");
        [self.player play];
    }
    NSLog(@"change = %@",useDic);
}
@end

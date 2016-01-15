//
//  ViewController.m
//  VLCDemo
//
//  Created by WeiCheng—iOS_1 on 15/12/22.
//  Copyright © 2015年 WeiCheng—iOS_1. All rights reserved.
//

#import "ViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "Masonry.h"
@interface ViewController ()<VLCMediaDelegate,VLCMediaPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *movieViewC;
@property (weak, nonatomic) UIView *movieView;
@property (strong, nonatomic) VLCMediaPlayer *mediaPlayer;
@property (weak, nonatomic) UIButton *playBtn;
@property (weak, nonatomic) UIView *movieViewM;
@property (weak, nonatomic) IBOutlet UILabel *currentLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (strong, nonatomic) VLCMedia *media;
@property (weak, nonatomic) CALayer *movieLayer;
@end

@implementation ViewController

#pragma mark - lazy initialize
#if 0
- (UIView *)movieView {
    if (!_movieView) {
        UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:v];
        v.backgroundColor = [UIColor whiteColor];
    }
    return _movieView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(0, 0, 100, 50);
        btn.center = CGPointMake(self.view.center.x, 600);
        [btn setTitle:@"Play" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"Pause" forState:UIControlStateSelected];
        _playBtn = btn;
    }
    return _playBtn;
}
#endif
- (UIView *)movieViewM {
    if (!_movieViewM) {
        UIView *v = [UIView new];
        [self.view addSubview:v];
        __weak typeof(self) weakSelf = self;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        v.backgroundColor = [UIColor whiteColor];
        _movieViewM = v;
    }
    return _movieViewM;
    
}


- (CALayer *)movieLayer {
    if (!_movieLayer) {
        CALayer *l = [[CALayer alloc] init];
        [self.view.layer addSublayer:l];
        l.frame = CGRectMake(0, 400, 375, 267);
    }
    return _movieLayer;
}

- (VLCMediaPlayer *)mediaPlayer {
    if (!_mediaPlayer) {
        _mediaPlayer = [[VLCMediaPlayer alloc] init];
    }
    return _mediaPlayer;
}




#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//  @"rtsp://192.168.42.1/tmp/fuse_d/NORMAL/media001/2015-12-22-14-21-23.MP4"
    
    self.mediaPlayer.delegate = self;
    self.mediaPlayer.drawable = self.movieViewM;
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:@"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov"]];
    media.delegate = self;
    self.mediaPlayer.media = media;//[VLCMedia mediaWithURL:[NSURL URLWithString:@"rtsp://192.168.42.1/live"]];
    [self playBtn];
    self.media = media;
    
    [self.mediaPlayer play];
    
#if 0
    [media addObserver:self forKeyPath:@"length" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.mediaPlayer addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:nil];
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
#if 0
    [self.media removeObserver:self forKeyPath:@"length"];
    [self.mediaPlayer removeObserver:self forKeyPath:@"time"];
#endif
    NSLog(@"dealloc");
}

#pragma mark - clickHandle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.movieViewM.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    __weak typeof(self) weakSelf = self;
    [self.movieViewM mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.width.mas_equalTo(667);
        make.height.mas_equalTo(375);
    }];
}
- (void)btnClick:(UIButton *)btn {
    if (self.mediaPlayer.isPlaying) {
        [self.mediaPlayer pause];
        btn.selected = YES;
    } else {
        [self.mediaPlayer play];
        btn.selected = NO;
    }

}
- (IBAction)btnTouch:(UIButton *)sender {
    if (self.mediaPlayer.isPlaying) {
        [self.mediaPlayer pause];
        sender.selected = YES;
    } else {
        [self.mediaPlayer play];
        sender.selected = NO;
    }

}

#pragma mark - VLCMediaDelegate
- (void)mediaDidFinishParsing:(VLCMedia *)aMedia {
    NSString *time = self.mediaPlayer.media.length.stringValue;
    self.totalLab.text = [NSString stringWithFormat:@"总时间： %@",time];
}

#pragma mark - VLCMediaPlayerDelegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    VLCMediaPlayer *player = aNotification.object;
    self.currentLab.text = [NSString stringWithFormat:@"当前时间： %@",player.time.stringValue];
    self.movieViewC.contentMode = UIViewContentModeScaleToFill;
}


#if 0
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"length"]) {
        VLCTime *totalTime = [change objectForKey:@"new"];
        NSLog(@"totalTime is %@",totalTime.stringValue);
    }
    if ([keyPath isEqualToString:@"time"]) {
        VLCTime *currentTime = [change objectForKey:@"new"];
        NSLog(@"currentTime is %@",currentTime.stringValue);
    }
}
#endif

@end

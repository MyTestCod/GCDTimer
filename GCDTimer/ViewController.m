//
//  ViewController.m
//  GCDTimer
//
//  Created by King on 16/8/29.
//  Copyright © 2016年 King. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *countdownBtn;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self daojishi:10];
}

- (void)daojishi:(int)seconds {
    __block int timeout = seconds;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *string = kSendVerifyCode;
                
//                NSMutableAttributedString *attrString = [self setMutableAttributedStringWithString:string color:kColor(orangeColor) range:NSMakeRange(0, string.length)];
//                [self setAttributedTitle:attrString forState:UIControlStateNormal];
                
//                self.layer.borderColor = kCGColor(orangeColor);
//                [self setUserInteractionEnabled:YES];
            });
        } else {
            int sec = timeout % (seconds + 1);
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *string = kResendVerifyCode(sec);
//                
//                NSUInteger location = [string rangeOfString:@"("].location + 1;
//                NSUInteger length = [string rangeOfString:@"s)"].location - location;
//                NSRange range = NSMakeRange(location, length);
//                
//                NSMutableAttributedString *attrString = [self setMutableAttributedStringWithString:string color:kColor(grayColor) range:NSMakeRange(0, string.length) subStrColor:kColor(orangeColor) subStrRange:range];
//                [self setAttributedTitle:attrString forState:UIControlStateNormal];
//                
//                self.layer.borderColor = kCGColor(grayColor);
//                [self setUserInteractionEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)countdownAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *countdownAlert = [UIAlertController alertControllerWithTitle:nil
                                                                            message:@"输入倒计时时间"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    [countdownAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入倒计时时间";
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf
                                                 selector:@selector(alertTextFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }];
    UIAlertAction *countdownActonCancel = [UIAlertAction actionWithTitle:@"取消"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [[NSNotificationCenter defaultCenter] removeObserver:weakSelf
                                                                                                               name:UITextFieldTextDidChangeNotification
                                                                                                             object:nil];
                                                           }];
    UIAlertAction *countdownActionStart = [UIAlertAction actionWithTitle:@"开始"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:weakSelf
                                                                                                                     name:UITextFieldTextDidChangeNotification
                                                                                                                   object:nil];
                                                                     [weakSelf startGCDCountDownWithTime:[countdownAlert.textFields.lastObject.text integerValue]];
                                                                 }];
    [countdownAlert addAction:countdownActonCancel];
    [countdownAlert addAction:countdownActionStart];
    [self presentViewController:countdownAlert animated:YES completion:nil];
}

- (IBAction)cancelAction:(id)sender {
//    关闭计时器
    dispatch_source_cancel(_timer);
}

- (void)startGCDCountDownWithTime:(NSInteger)time {
    __weak typeof(self) weakSelf = self;
    __block NSInteger count = time;
    __block BOOL repeat = YES;
//    创建一个队列 存放计时任务
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    创建一个timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    给timer设置参数：第二个参数表示计时器启动时间；第三个参数表示计时器运行间隔；第四个参数表示计时器精度；
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);//dispatch_walltime(NULL, 0)
//    给计时器添加任务
    dispatch_source_set_event_handler(_timer, ^{
        if (!repeat) {
            dispatch_source_cancel(_timer);
        }else {
            count --;
            [weakSelf countdouwEvent:count];
        }
        
    });
//    启动计时器
    dispatch_resume(_timer);
}

- (void)countdouwEvent:(NSInteger)time {
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%ld", time);
//    });
}

- (void)alertTextFieldDidChange:(NSNotification *)notification {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

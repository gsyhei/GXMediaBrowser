//
//  ViewController.m
//  GXMediaBrowserSample
//
//  Created by GuoShengyong on 2018/2/27.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "ViewController.h"
#import "GXWaterViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startButtonClick:(id)sender {
    GXWaterViewController *ctr = [[GXWaterViewController alloc] init];
    ctr.scrollDirection = UICollectionViewScrollDirectionVertical;
    ctr.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

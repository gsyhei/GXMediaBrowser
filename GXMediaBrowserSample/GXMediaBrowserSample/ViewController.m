//
//  ViewController.m
//  GXMediaBrowserSample
//
//  Created by GuoShengyong on 2018/2/27.
//  Copyright © 2018年 protruly. All rights reserved.
//

#import "ViewController.h"
#import "GXWaterViewController.h"
#import "GXUserViewController.h"
#import "UIView+GXAdd.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIButton *demo1Button;
@property (nonatomic, weak) IBOutlet UIButton *demo2Button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)demo1ButtonClick:(id)sender {
    GXWaterViewController *ctr = [[GXWaterViewController alloc] init];
    ctr.scrollDirection = UICollectionViewScrollDirectionVertical;
    ctr.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (IBAction)demo2ButtonClick:(id)sender {
    GXUserViewController *uvc = [[GXUserViewController alloc] initWithNibName:@"GXUserViewController" bundle:nil];
    uvc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

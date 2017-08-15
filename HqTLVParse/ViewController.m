//
//  ViewController.m
//  HqTLVParse
//
//  Created by macpro on 2017/8/9.
//  Copyright © 2017年 macpro. All rights reserved.
//

#import "ViewController.h"
#import "HqTVLParse.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *tlvStr = @"010a10df5387d1da200400e700000000000000";
    tlvStr = @"9f70020700";
    tlvStr = @"61224f0e535a542e57414c4c45542e454e569f7002070080020003810108870100880100611f4f0ba0000000034c4e545353449f70020f0180020002810109870100880100611c4f085943542e555345529f700207018002000281010a870100880100";

    HqTVLParse *parse = [[HqTVLParse alloc]init];
    NSArray *tlvs1 = [parse parseMutilTVLStrToArray:tlvStr];
    NSLog(@"tlvs1 = %@",tlvs1);
    parse = tlvs1[2];
    NSDictionary *ttt = [parse parseMutilTVLStrToDic:parse.value];
    NSLog(@"ttt = %@",ttt);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

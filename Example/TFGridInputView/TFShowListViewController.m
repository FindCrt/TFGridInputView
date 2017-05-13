//
//  TFShowListViewController.m
//  TFGridInputView
//
//  Created by shiwei on 17/5/13.
//  Copyright © 2017年 wei shi. All rights reserved.
//

#import "TFShowListViewController.h"
#import "TFInputViewShowViewController.h"

@interface TFShowListViewController (){
    NSArray *_showList;
}

@end

@implementation TFShowListViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"列表";
    
    _showList = @[
                  @"单行+使用默认设置",
                  @"多行+输入颜色变化+待输入高亮",
                  @"带边框类型",
                  @"cell紧贴+边框",
                  @"密码输入",
                  @"一进页面就弹出键盘"
                  ];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _showList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TFInputViewShowViewController *showVC = [[TFInputViewShowViewController alloc] init];
    
    showVC.showType = indexPath.row;
    [self.navigationController pushViewController:showVC animated:YES];
}

@end

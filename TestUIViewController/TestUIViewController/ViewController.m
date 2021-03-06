//
//  ViewController.m
//  TestUIViewController
//
//  Created by baoyewei on 17/3/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "ViewController.h"
#import "BYModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableVIew;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.dataArr addObject:[BYModel modelWithKey:@"LifeCircle1ViewController" value:@"测试生命周期"]];
    [self.dataArr addObject:[BYModel modelWithKey:@"NavSetVC1ViewController" value:@"仿网易云的VC顺序变化"]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseID = @"reuseID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    BYModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.value;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYModel *model = self.dataArr[indexPath.row];
    Class class =  NSClassFromString(model.key);
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

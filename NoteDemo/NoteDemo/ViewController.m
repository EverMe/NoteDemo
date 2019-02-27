//
//  ViewController.m
//  NoteDemo
//
//  Created by byw on 2018/12/20.
//  Copyright © 2018 byw. All rights reserved.
//

#import "ViewController.h"
#import "MYSegmentView.h"
#import "NSString+Utility.h"


@interface listItem : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;
+ (instancetype)itemWithKey:(NSString *)key value:(NSString *)value;
@end

@implementation listItem
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value{
    if (self = [super init]) {
        self.key = key;
        self.value = value;
    }
    return self;
}
+ (instancetype)itemWithKey:(NSString *)key value:(NSString *)value{
    return [[[self class] alloc] initWithKey:key value:value];
}
@end

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <listItem *>*listData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *a;
    //[self testSegmentView];
    NSArray *data = @[[listItem itemWithKey:@"Class/Self/Super" value:@"TestClassViewController"],
                      [listItem itemWithKey:@"NSString" value:@"TestStringViewController"],
                      [listItem itemWithKey:@"Animation" value:@"TestUIViewAnimationController"],
                      ];
    self.listData = [[NSMutableArray alloc] initWithArray:data];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *reuseId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    listItem *item = [self.listData objectAtIndex:indexPath.row];
    cell.textLabel.text = item.key;
    cell.detailTextLabel.text = item.value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    listItem *item = [self.listData objectAtIndex:indexPath.row];
    if (item.value) {
        Class c = NSClassFromString(item.value);
        UIViewController *vc = [[c alloc] init];
        if (vc && [vc isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)testSegmentView{
    
    MYSegmentView *segmentView = [[MYSegmentView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50)];
    segmentView.contentInset = UIEdgeInsetsMake(7, 0, 7, 0);
    segmentView.titleColor = UIColor.lightGrayColor;
    segmentView.titleFont = [UIFont systemFontOfSize:18];
    segmentView.titleHighlightColor = UIColor.redColor;
    segmentView.lineColor = UIColor.redColor;
    segmentView.lineHeight = 2.5;
    [segmentView setTitles:@[@"交易榜",@"跟随榜232",@"分红榜"] selectedIndex:0];
    [self.view addSubview:segmentView];
    segmentView.selectedIndexBlock = ^(NSInteger index, NSString * _Nonnull text) {
        NSLog(@"selected %ld  %@",index,text);
    };
    
}

@end

//
//  TestListViewController.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/6/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "TestListViewController.h"
#import "TestListTableViewCell.h"
#import "UIView+WebVoiceCache.h"

@interface TestListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSIndexPath *playingIndexPath;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}

- (void)initUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mTableView registerNib:[UINib nibWithNibName:@"TestListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TestListTableViewCell"];
    self.mTableView.rowHeight = 225;
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.frame = CGRectMake(0, 0, 64, 44);
    [reloadBtn setTitle:@"Reload" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    reloadBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [reloadBtn addTarget:self.mTableView action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:reloadBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TestListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestListTableViewCell" forIndexPath:indexPath];
    [cell setCellData:self.dataArr[indexPath.row] playing:self.playingIndexPath == indexPath];
    __weak __typeof(self) weakSelf = self;
    [cell setPlayVoiceBlock:^(TestListTableViewCell *playCell,NSString *voiceURL){
        
        NSIndexPath *playingIndexPath = [self.mTableView indexPathForCell:playCell];
        [playCell sy_playVoiceWithURL:[NSURL URLWithString:voiceURL] completed:^(NSString *voicePath, NSError *error, NSURL *voiceURL) {
            weakSelf.playingIndexPath = playingIndexPath;
            NSLog(@"completed");
        }];
    }];
    
    [cell setPlayFinishBlock:^{
        weakSelf.playingIndexPath = nil;
    }];
    return cell;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        
        
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614133416-FoT_8oQPsn1WVqf6YLZGh2lleMdb.mp3?auth_key=1497431857-0-0-159841de8c9edd3231af3178be3a9962"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614114904-FuEfOIL9EaVH88nvM-7YPKPfWIEm.mp3?auth_key=1497431889-0-0-f29cac756d8d9c32705e0139dff102d9"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614125726-Fv1OeNeQpl-rBNX_MFCsDg4s5_TW.mp3?auth_key=1497431934-0-0-a4bb6bd7cc89924749b498f7c800c7f9"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614114609-FrQVqZDZELifycRIVtWxnh3UOIQy.mp3?auth_key=1497432013-0-0-ad36ef4656209729ac7bcb00203dfdb6"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614093337-Fi4ZVbgPgba1FaS65zmwT5OhvSpW.mp3?auth_key=1497432032-0-0-c7a1166bcae44e80be0b59ff652a8bc9"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614091819-Fozagye5Q0yhbKfJnX4U8_LaIiOg.mp3?auth_key=1497432046-0-0-36d5c4a834d504a40fefa7838a7a026e"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170614020201-Fr_BsyTGL2Va2v_JcvtTHN6fRfKu.mp3?auth_key=1497432061-0-0-8b925831b88a93c6c64e74e24497364f"];
        [_dataArr addObject:@"https://video-cdn.suiyueyule.com/20170613200328-FnTw_u_ppuZLTkxMmdA958lO5_xU.mp3?auth_key=1497432123-0-0-4adcc43d13572fb2d39e9eb93460902b"];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MCNewsView.m
//  Project
//
//  Created by Nitch Zheng on 2019/12/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCNewsView.h"
#import "MCNewsCell.h"

static NSString *api_getnews = @"/user/app/news/getnewsby/brandidandclassification/andpage";


@interface MCNewsView ()<UITableViewDelegate,UITableViewDataSource>
/** 主视图 */
@property(nonatomic,readwrite,strong) UITableView* za_tableview;

/**  header */
@property(nonatomic,readwrite,strong) UIView *headView;
/**  标题 */
@property(nonatomic,readwrite,strong) UILabel *headTitleLabel;
/**  line */
@property(nonatomic,readwrite,strong) UILabel *line;
/**  更多 */
@property(nonatomic,readwrite,strong) UILabel *moreLabel;
/**  箭头 */
@property(nonatomic,readwrite,strong) UIImageView *moreIcone;

/** 数据源 */
@property(nonatomic,readwrite,strong)  NSMutableArray *datasource;
@end

@implementation MCNewsView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self requestData];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.za_tableview];
}

- (void) requestData{
    

    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:@"资讯" forKey:@"classifiCation"];
    [param setObject:BCFI.brand_id forKey:@"brandId"];
    [param setObject:@"20" forKey:@"size"];
    [param setObject:@"0" forKey:@"page"];
    
    __weak __typeof(self)weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_POST:api_getnews parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        self.datasource = [MCNewsModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updataHeight];
            [self.za_tableview reloadData];
        });
    }];
}
- (void)updataHeight{
    if (self.datasource.count < 3) {
        if (self.datasource.count == 0) {
            self.frame = CGRectMake(self.ly_x, self.ly_y, self.ly_width,0);
        }else{
            self.frame = CGRectMake(self.ly_x, self.ly_y, self.ly_width,49 + 49 + 105 * 3 + 15 + 10);
        }
        if (self.height) {
            self.height(self.ly_height);
        }
        self.za_tableview.frame = CGRectMake(0, 0,self.width,self.ly_height);
    }else{
        self.frame = CGRectMake(self.ly_x, self.ly_y, self.ly_width,49 + 105 * 3 + 15 + 10);
        if (self.height) {
            self.height(self.ly_height);
        }
        self.za_tableview.frame = CGRectMake(0, 0,self.width,self.ly_height);
    }
}

#pragma mark - Protocol Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count > 3 ? 3 : self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCNewsCell cellWithTableview:tableView newsModel:self.datasource[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCNewsModel* model = self.datasource[indexPath.row];
    NSString* isAddParam = [NSString stringWithFormat:@"%@",model.publisher];
    if ([isAddParam isEqualToString:@"add"]) {
        [self pushWebWithUrl:[self appendOtherParams:model.content] title:model.title];
    }else{
        [self pushWebWithUrl:model.content title:model.title];
    }
}

- (void)pushWebWithUrl:(NSString*)url title:(NSString*)title{
    NSString *urlNew = [MCVerifyStore verifyURL:url];
    if (!urlNew) {
        urlNew = @"http://mc.mingchetech.com/link/soon.html";
    }
    [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":urlNew, @"title":title}];
}
- (NSString*)appendOtherParams:(NSString*)url{
    NSString *phone = MCModelStore.shared.userInfo.phone;
    NSString *token = TOKEN;
    NSString *userID = MCModelStore.shared.userInfo.userid;
    NSString *ip = BCFI.pureHost;
    url = [NSString stringWithFormat:@"%@?phone=%@&token=%@&brandid=%@&userid=%@&ip=%@", url,phone,token,BCFI.brand_id,userID,ip];
    return url;
}

#pragma mark - Action
- (void) headAction{
    [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"资讯"}];
}

- (UITableView *)za_tableview {
    if (!_za_tableview) {
        _za_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.width,350) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _za_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _za_tableview.scrollEnabled = NO;
        _za_tableview.backgroundColor = [UIColor whiteColor];
        _za_tableview.delegate = self;
        _za_tableview.dataSource = self;
       
        UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width,15)];
        _za_tableview.tableFooterView = footView;
    }
    return _za_tableview;
}
- (UILabel*)headTitleLabel{
    if (nil == _headTitleLabel) {
        _headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0,self.width-44,49)];
        _headTitleLabel.text = @"资讯";
        _headTitleLabel.font = [UIFont systemFontOfSize:15];
        _headTitleLabel.textColor = [UIColor qmui_colorWithHexString:@"#3C3C3C"];
    }
    return _headTitleLabel;
}

- (UILabel*)line{
    if (nil == _line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0,48,self.width,1)];
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line;
}

- (UILabel*)moreLabel{
    if (nil == _moreLabel) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ly_width-26.5-25,15,30,20)];
        _moreLabel.textColor = [UIColor mainColor];
        _moreLabel.font = [UIFont systemFontOfSize:14];
        _moreLabel.textAlignment = NSTextAlignmentLeft;
        _moreLabel.text = @"更多";
    }
    return _moreLabel;
}
- (UIImageView*)moreIcone{
    if (nil == _moreIcone) {
        _moreIcone = [[UIImageView alloc] initWithFrame:CGRectMake(self.moreLabel.qmui_right+5,18.5, 7, 12.5)];
        _moreIcone.image = [[UIImage mc_imageNamed:@"CreditsExchangeFooterArrow"] imageWithColor:[UIColor mainColor]];
    }
    return _moreIcone;
}
- (UIView*) headView {
    if (nil == _headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,50)];
        _headView. userInteractionEnabled = YES;
        [_headView addSubview:self.headTitleLabel];
        [_headView addSubview:self.line];
        [_headView addSubview:self.moreLabel];
        [_headView addSubview:self.moreIcone];
        
        //添加手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}
- (NSMutableArray*) datasource {
    if (nil == _datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}
@end

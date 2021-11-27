//
//  ZABuyGoodsView.m
//  Project
//
//  Created by SS001 on 2019/7/15.
//  Copyright © 2019 LY. All rights reserved.
//

#import "ZABuyGoodsView.h"

#import "ZAReceviceAddressModel.h"
#import "ZAPayTypeViewCell.h"
#import "ZAChannelModel.h"
#import <BRAddressPickerView.h>


@interface ZABuyGoodsView ()<UITableViewDelegate, UITableViewDataSource, QMUITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameView;
@property (weak, nonatomic) IBOutlet QMUITextField *userPhoneView;
@property (weak, nonatomic) IBOutlet UIButton *provinceAndCityView;
@property (weak, nonatomic) IBOutlet QMUITextView *addressDetailView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MCUserInfo *userInfo;
@property (nonatomic, strong) ZAReceviceAddressModel *addressModel;
@property (nonatomic, strong) NSMutableArray *channelArray;
@property (weak, nonatomic) IBOutlet UIButton *kdBtn;
@property (weak, nonatomic) IBOutlet UIButton *ztBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) ZAChannelModel *selectPayType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeightCons;
@property (weak, nonatomic) IBOutlet UIView *textViewBottomLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (nonatomic, assign) CGFloat keyboardY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeiCons;
@end

@implementation ZABuyGoodsView

- (NSMutableArray *)channelArray
{
    if (!_channelArray) {
        _channelArray = [NSMutableArray array];
    }
    return _channelArray;
}

+ (instancetype)showView
{
    NSArray *array = [[NSBundle OEMSDKBundle] loadNibNamed:@"ZABuyGoodsView" owner:nil options:nil];
    return [array lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.goodsImg.layer.cornerRadius = 8;
    self.goodsImg.layer.masksToBounds = YES;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = self.confirmBtn.ly_height * 0.5;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    
    self.goodsPriceLabel.textColor = [UIColor mainColor];
    self.goodsNumLabel.textColor = [UIColor mainColor];
    UIImage *selectImg = [[UIImage mc_imageNamed:@"shops_chose_yes"] imageWithColor:[UIColor mainColor]];
    [self.kdBtn setImage:selectImg forState:UIControlStateSelected];
    [self.ztBtn setImage:selectImg forState:UIControlStateSelected];
    
    
    self.addressDetailView.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);
    self.addressDetailView.contentSize = CGSizeMake(self.addressDetailView.ly_width, 33);
    self.addressDetailView.delegate = self;
    
    
    [self getDefaultAddress];
    [self getPersonInfo];
    [self getPayType];
}

- (void)setGoodsModel:(ZAGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.remark]];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", goodsModel.money];
    
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        if ([userInfo.grade integerValue] < goodsModel.grade) {
            [self.confirmBtn setTitle:@"立即开通" forState:UIControlStateNormal];
            [self.confirmBtn setBackgroundColor:[UIColor mainColor]];
        } else {
            [self.confirmBtn setTitle:@"已经开通" forState:UIControlStateNormal];
            [self.confirmBtn setBackgroundColor:[UIColor grayColor]];
        }
    }];
}

#pragma mark - 数据请求
- (void)getPersonInfo
{
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        self.userInfo = userInfo;
    }];
}
- (void)getDefaultAddress
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [[MCSessionManager shareManager] mc_POST:@"/user/app/receiveaddress/getbyuserid/andstatus" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *addressArray = [ZAReceviceAddressModel mj_objectArrayWithKeyValuesArray:resp.result];
        if (addressArray.count != 0) {
            self.addressModel = addressArray.firstObject;
        }

    }];
}

- (void)setAddressModel:(ZAReceviceAddressModel *)addressModel
{
    _addressModel = addressModel;
    
    if (addressModel.userName) {
        self.userNameView.text = addressModel.userName;
    }
    if (addressModel.phone) {
        self.userPhoneView.text = addressModel.phone;
    }
    if (addressModel.city) {
        [self.provinceAndCityView setTitle:addressModel.city forState:UIControlStateNormal];
    }
    if (addressModel.detailedAddress) {
        self.addressDetailView.text = addressModel.detailedAddress;
    }
    
    self.kdBtn.selected = YES;
}

- (void)getPayType
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"user_id"];
    [[MCSessionManager shareManager] mc_POST:@"/user/app/channel/query/all/brandid" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *array = [ZAChannelModel mj_objectArrayWithKeyValuesArray:resp.result];
        for (ZAChannelModel *model in array) {
            if ([model.channelNo isEqualToString:@"6"]) {
                model.remarks = @"高效、安全、专用（消费）的支付方式";
                model.isChose = YES;
                [self.channelArray addObject:model];
                self.selectPayType = model;
            }
            if ([model.channelNo isEqualToString:@"7"]) {
                model.remarks = @"五大安全保障，打造“智慧生活”";
                model.isChose = NO;
                [self.channelArray addObject:model];
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)createReceiveAddress
{
    NSString *name = self.userNameView.text;
    if (name.length == 0) {
        [MCToast showMessage:@"请输入收货人的姓名"];
        return;
    }
    NSString *phone = self.userPhoneView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }
    NSString *city = self.provinceAndCityView.titleLabel.text;
    if (city.length == 0) {
        [MCToast showMessage:@"请选择收货人的省市区"];
        return;
    }
    NSString *detailAddress = self.addressDetailView.text;
    if (detailAddress.length == 0) {
        [MCToast showMessage:@"请输入收货人的详细地址"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:SharedDefaults.phone forKey:@"userPhone"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brandId"];
    [params setValue:phone forKey:@"phone"];
    [params setValue:name forKey:@"userName"];
    [params setValue:city forKey:@"city"];
    [params setValue:self.addressDetailView.text forKey:@"detailedAddress"];
    NSString *type = @"0";
    /* 等级  */
    params[@"grade"] = [NSString stringWithFormat:@"%ld",self.goodsModel.grade];
    params[@"nameOfCommodity"] = self.goodsModel.name;
    params[@"commodityPrice"] = [NSString stringWithFormat:@"%.2f",self.goodsModel.money];

    if (!self.kdBtn.selected) {
        type = @"1";
    }
    [params setValue:type forKey:@"isExpress"];
    [[MCSessionManager shareManager] mc_POST:@"/user/app/receiveaddress/create" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            [self payOrder];
        }
    }];
}

- (void)payOrder
{
    if ([self.selectPayType.name isEqualToString:@"支付宝"]) {
        [MCPayStore aliPayWithAmount:[NSString stringWithFormat:@"%.2f", self.goodsModel.money] productId:self.goodsModel.ID orderDesc:self.goodsModel.name channelTag:@"ALI" couponId:nil];
    } else {
        [MCPayStore weixinPayWithAmount:[NSString stringWithFormat:@"%.2f", self.goodsModel.money] productId:self.goodsModel.ID orderDesc:self.goodsModel.name channelTag:@"WX" couponId:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.channelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZAPayTypeViewCell *cell = [ZAPayTypeViewCell cellWithTableView:tableView];
    cell.channelModel = self.channelArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (ZAChannelModel *model in self.channelArray) {
        model.isChose = NO;
    }
    ZAChannelModel *model = self.channelArray[indexPath.row];
    model.isChose = YES;
    self.selectPayType = model;
    [self.tableView reloadData];
}

- (IBAction)kdBtnAction:(UIButton *)sender {
    sender.selected = YES;
    self.ztBtn.selected = NO;
}
- (IBAction)ztBtnAction:(UIButton *)sender {
    sender.selected = YES;
    self.kdBtn.selected = NO;
}
- (IBAction)confirmBtnAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"已经开通"]) {
        [MCToast showMessage:@"已经开通"];
    } else {
        [self createReceiveAddress];
    }
}
- (IBAction)clickAddressButton:(UIButton *)sender {
    [self endEditing:YES];
    
    BRAddressPickerView *pickView = [[BRAddressPickerView alloc] init];
    pickView.pickerMode = BRAddressPickerModeArea;
    pickView.title = @"请选择地区";
    pickView.isAutoSelect = YES;
    pickView.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
        NSString *address = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, area.name];
        [sender setTitle:address forState:UIControlStateNormal];
    };
    [pickView show];
}


- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height
{
    self.detailHeightCons.constant = height;

    CGFloat changeHeight = height - 33;
    self.contentViewHeiCons.constant = 624 + changeHeight;
    self.ly_height = 755 + changeHeight;
    if (self.callBack) {
        self.callBack(self.ly_height);
    }
}
@end

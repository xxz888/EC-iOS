//
//  ZAOrderViewCell.m
//  Project
//
//  Created by SS001 on 2019/7/16.
//  Copyright © 2019 LY. All rights reserved.
//

#import "ZAOrderViewCell.h"
#import "ZAGoodsStatusModel.h"

@interface ZAOrderViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *smContentView;
@property (nonatomic, strong) ZAGoodsStatusModel *goodsModel;
@end

@implementation ZAOrderViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"order_cell";
    ZAOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ZAOrderViewCell" bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.confirmBtn.layer.borderColor = [UIColor qmui_colorWithHexString:@"#FD5D02"].CGColor;
    self.confirmBtn.layer.borderWidth = 1;
    self.confirmBtn.layer.cornerRadius = self.confirmBtn.ly_height * 0.5;
    self.confirmBtn.layer.masksToBounds = YES;
    
    self.smContentView.layer.masksToBounds = YES;
    self.smContentView.layer.cornerRadius = 10;
    
    [self getGoodsType];
}

- (void)setShopModel:(ZAShopsModel *)shopModel
{
    _shopModel = shopModel;
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:shopModel.lowSource]];
    self.goodsName.text = shopModel.content;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", shopModel.previewNumber];
}

- (void)getGoodsType
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"-1" forKey:@"isSend"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brandId"];
    [params setValue:SharedDefaults.phone forKey:@"userPhone"];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [[MCSessionManager shareManager] mc_POST:@"/user/app/receiveaddress/getbyuserid/andstatus" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        NSArray *array = [ZAGoodsStatusModel mj_objectArrayWithKeyValuesArray:resp.result];
        if (array.count != 0) {
            self.goodsModel = array.firstObject;
        } else {
            self.confirmBtn.hidden = YES;
        }
    }];
}
- (void)getGoods
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"2" forKey:@"isSend"];
    [params setValue:MCModelStore.shared.brandConfiguration.brand_id forKey:@"brandId"];
    [params setValue:SharedDefaults.phone forKey:@"userPhone"];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [[MCSessionManager shareManager] mc_POST:@"/user/app/receiveaddress/create" parameters:params ok:^(MCNetResponse * _Nonnull resp) {
        if ([resp.code isEqualToString:@"000000"]) {
            [MCToast showMessage:@"收获成功"];
            [self getGoodsType];
        }
    }];
}
- (void)setGoodsModel:(ZAGoodsStatusModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    if (goodsModel.isSend == 2) {
        self.confirmBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [self.confirmBtn setTitle:@"已收货" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else if (goodsModel.isSend == 0) {
        self.confirmBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [self.confirmBtn setTitle:@"未发货" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else if (goodsModel.isSend == 1) {
        self.confirmBtn.layer.borderColor = [UIColor qmui_colorWithHexString:@"#FD5D02"].CGColor;
        [self.confirmBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#FD5D02"] forState:UIControlStateNormal];
    }
}
- (IBAction)clickConfirmBtn:(UIButton *)sender {
    if (self.goodsModel.isSend == 1) {
        [self getGoods];
    } else if (self.goodsModel.isSend == 2) {
        [MCToast showMessage:@"你已经收过该商品了"];
    } else if (self.goodsModel.isSend == 0) {
        [MCToast showMessage:@"商家还未发货"];
    }
}
@end

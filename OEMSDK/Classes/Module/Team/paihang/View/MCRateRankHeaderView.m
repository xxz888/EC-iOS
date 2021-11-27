//
//  MCRateRankHeaderView.m
//  AFNetworking
//
//  Created by SS001 on 2020/7/22.
//

#import "MCRateRankHeaderView.h"
#import "MCIncomeRateModel.h"

@interface MCRateRankHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *paihLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView1;
@property (weak, nonatomic) IBOutlet UIImageView *logoView2;
@property (weak, nonatomic) IBOutlet UIImageView *logoView3;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel3;
@property (weak, nonatomic) IBOutlet UILabel *anoumtLabel1;
@property (weak, nonatomic) IBOutlet UILabel *anoumtLabel2;
@property (weak, nonatomic) IBOutlet UILabel *anoumtLabel3;

@end

@implementation MCRateRankHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.logoView1.image = MCModelStore.shared.brandConfiguration.image_logo;
    self.logoView2.image = MCModelStore.shared.brandConfiguration.image_logo;
    self.logoView3.image = MCModelStore.shared.brandConfiguration.image_logo;
    self.topView.backgroundColor = [UIColor mainColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCRateRankHeaderView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    if (dataArray.count == 0) {
        self.view1.hidden = YES;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
        return;
    }
    
    if (dataArray.count >= 3) {
        MCIncomeRateModel *model1 = dataArray[0];
        MCIncomeRateModel *model2 = dataArray[1];
        MCIncomeRateModel *model3 = dataArray[2];
        [self setModel:model1];
        [self setModel:model2];
        [self setModel:model3];
    } else {
        if (dataArray.count == 1) {
            MCIncomeRateModel *model1 = dataArray[0];
            [self setModel:model1];
            self.view2.hidden = YES;
            self.view3.hidden = YES;
        }
        if (dataArray.count == 2) {
            MCIncomeRateModel *model1 = dataArray[0];
            [self setModel:model1];
            MCIncomeRateModel *model2 = dataArray[1];
            [self setModel:model2];
            self.view3.hidden = YES;
        }
    }
    
    MCIncomeRateModel *mode = [dataArray lastObject];
    if ([mode.ranking integerValue] > 100) {
        self.paihLabel.text = [NSString stringWithFormat:@"当前排行:未上榜"];
    } else {
        self.paihLabel.text = [NSString stringWithFormat:@"当前排行:%@",mode.ranking];
    }
}

- (void)setModel:(MCIncomeRateModel *)model
{
    if (model.ranking.intValue == 1) {
        self.anoumtLabel1.text = [NSString stringWithFormat:@"%.2f", model.rebate.floatValue];
        self.nameLabel1.attributedText = [self createNewStringWithName:model.name phone:model.phone];
    }
    if (model.ranking.intValue == 2) {
        self.anoumtLabel2.text = [NSString stringWithFormat:@"%.2f", model.rebate.floatValue];
        self.nameLabel2.attributedText = [self createNewStringWithName:model.name phone:model.phone];
    }
    if (model.ranking.intValue == 3) {
        self.anoumtLabel3.text = [NSString stringWithFormat:@"%.2f", model.rebate.floatValue];
        self.nameLabel3.attributedText = [self createNewStringWithName:model.name phone:model.phone];
    }
}

- (NSMutableAttributedString *)createNewStringWithName:(NSString *)name phone:(NSString *)phone
{
    NSString *newstr = [NSString stringWithFormat:@"%@%@", name, phone];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:newstr];
    NSRange range = [newstr rangeOfString:name];
    [atts addAttribute:NSFontAttributeName value:LYFont(15) range:range];
    return atts;
}

@end

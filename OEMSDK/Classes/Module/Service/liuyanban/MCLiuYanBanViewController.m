//
//  MCLiuYanBanViewController.m
//  OEMSDK
//
//  Created by apple on 2021/1/4.
//

#import "MCLiuYanBanViewController.h"
#import "MCLiuYanBanTableViewCell.h"

@interface MCLiuYanBanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation MCLiuYanBanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"官方留言";
    self.dataArray = [[NSMutableArray alloc]init];
    [self requestGuanFangLiuYan];
}

-(void)requestGuanFangLiuYan{
    __weak typeof(self) weakSelf = self;
    [self.dataArray removeAllObjects];
    [MCSessionManager.shareManager mc_POST:@"/user/app/jpush/MessagePush/Query" parameters:@{@"userid":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        

        
        if ([resp.code isEqualToString:@"000000"]) {
            [weakSelf.dataArray addObjectsFromArray:resp.result];
            
            //这里判断未读数组，把未读变成已读
            for (NSDictionary * typeDic in resp.result) {
                if ([typeDic[@"type"] integerValue] == 0) {
                    [MCSessionManager.shareManager mc_POST:@"/user/app/jpush/MessagePush/update/App" parameters:@{@"id":typeDic[@"id"]} ok:^(MCNetResponse * _Nonnull resp) {}];
                }
            }
       
        }else{
            [MCToast showMessage:resp.messege];
        }
        [weakSelf.liuyanbanTableView reloadData];
    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    double describeheight = [self calculateLabelHeightWithText:self.dataArray[indexPath.row][@"content"] lineSpace:5 fontName:[UIFont systemFontOfSize:15] size:CGSizeMake(KScreenWidth-89, MAXFLOAT) label:nil];
    
    return (describeheight < 36 ? 36 : describeheight) + 55;
}
- (CGFloat )calculateLabelHeightWithText:(NSString *)text lineSpace:(NSInteger )lineSpace fontName:(UIFont *)fontName size:(CGSize )size label:(UILabel *)label

{

CGFloat height = 0;

if (text.length > 0) {

// 计算内容高度,判断显示几行

NSString *firstWord = [text substringToIndex:1];

CGFloat oneRowHeight = [firstWord sizeWithAttributes:@{NSFontAttributeName:fontName}].height;

NSDictionary *attributes = @{NSFontAttributeName:fontName};

CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;

CGFloat rows = textSize.height / oneRowHeight;

if (rows == 1) {

lineSpace = 0;

height = oneRowHeight;

} else if (rows > 1) {

height = (oneRowHeight + lineSpace) * rows;

}

if (label) {

NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];

NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];

[paragraphStyle setLineSpacing:lineSpace];

[string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,text.length)];

[label setAttributedText:string];

}

}

return height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCLiuYanBanTableViewCell *cell = [MCLiuYanBanTableViewCell cellWithTableView:tableView];
    cell.contentLbl.text = self.dataArray[indexPath.row][@"content"];
    cell.timeLbl.text = self.dataArray[indexPath.row][@"createTime"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.contentLbl.text];
    NSRange range1 = [[str string] rangeOfString:@"在线客服"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#0066FF"] range:range1];
    cell.contentLbl.attributedText = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
                              

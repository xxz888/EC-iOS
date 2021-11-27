//
//  MCFenrunCell.m
//  MCOEM
//
//  Created by wza on 2020/5/9.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCFenrunCell.h"




@implementation MCFenrunCell

+ (instancetype)cellForTableview:(UITableView *)tableview fenrunInfo:(MCFenrunModel *)model {
    static NSString *cellID = @"MCFenrunCell";
    MCFenrunCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableview registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableview dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (model.oriphone.length > 7) {
        NSMutableAttributedString* attr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"来自尾号%@的收益",[model.oriphone substringFromIndex:7]]];
        [attr setAttributes:@{NSForegroundColorAttributeName:UIColorGrayDarken} range:NSMakeRange(0, 11)];
        [attr setAttributes:@{NSForegroundColorAttributeName:MAINCOLOR} range:NSMakeRange(4, 4)];
        cell.remarkLab.attributedText = attr;
    }
    
    if (model.oriphone) {
        [cell requstPlace:model];
    }
    NSDateFormatter *f1 = [[NSDateFormatter alloc] init];
    f1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [f1 dateFromString:model.createTime];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    f2.dateFormat = @"MM-dd";
    cell.monthLab.text = [f2 stringFromDate:date];
    
    NSDateFormatter *f3 = [[NSDateFormatter alloc] init];
    f3.dateFormat = @"MM";
    int yue = [f3 stringFromDate:date].intValue;
    
    cell.monthZHLab.text = [NSString stringWithFormat:@"%@月",[cell translationArabicNum:yue]];
    cell.moneyLab.text = [NSString stringWithFormat:@"+%.2f", [model.acqAmount floatValue]];
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moneyLab.textColor = MAINCOLOR;
    self.phoneTypeLab.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    self.phoneTypeLab.layer.borderColor = UIColorGrayLighten.CGColor;
    self.phoneTypeLab.layer.cornerRadius = 4;
}

-(void)setFrame:(CGRect)frame{
    frame.origin.y += 1;
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)requstPlace:(MCFenrunModel *)model {
    MCSessionManager *manager = [MCSessionManager manager];
    AFHTTPResponseSerializer* serializer=[AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes=[NSSet setWithObjects:@"text/htLY", @"text/json", @"text/plain", @"text/javascript", @"text/xLY", @"image/*",@"application/javascript",@"text/html", nil];
    manager.responseSerializer = serializer;
    [manager GET:@"http://tcc.taobao.com/cc/json/mobile_tel_segment.htm" parameters:@{@"tel":model.oriphone} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //MCLog(@"%@",responseObject);
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *pageSource = [[NSString alloc] initWithData:responseObject encoding:gbkEncoding];
        NSArray* result=[pageSource componentsSeparatedByString:@" = "];
        if (result.count<=2) {
            NSString* resultStr= result[1];
            NSArray* results=[resultStr componentsSeparatedByString:@","];
            if (results.count>=3) {
                NSArray* phonresult=[results[1] componentsSeparatedByString:@":"];
                if (phonresult.count>=2) {
                    self.cityLab.text = [phonresult[1] stringByReplacingOccurrencesOfString:@"'" withString:@""];
                }
                NSArray* tagresult=[results[2] componentsSeparatedByString:@":"];
                if (tagresult.count>=2) {
                    self.phoneTypeLab.text = [[tagresult[1] substringFromIndex:3] stringByReplacingOccurrencesOfString:@"'" withString:@""];
                }
            }
        }else{
            self.cityLab.text=@"未知";
            self.phoneTypeLab.text=@"未知";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //MCLog(@"%@",error);
    }];
}


-(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

@end

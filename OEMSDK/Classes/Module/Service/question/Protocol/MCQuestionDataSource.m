//
//  QuestionDataSource.m
//  Project
//
//  Created by SS001 on 2020/3/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "MCQuestionDataSource.h"
#import "MCNewsModel.h"

@implementation MCQuestionDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    MCNewsModel *model = self.data[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
@end

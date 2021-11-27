//
//  QuestionDelegate.m
//  Project
//
//  Created by SS001 on 2020/3/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "MCQuestionDelegate.h"
#import "MCNewsModel.h"

@implementation MCQuestionDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MCNewsModel *model = self.data[indexPath.row];
    [MCPagingStore pushWebWithTitle:model.title classification:model.classifiCation];
}

@end

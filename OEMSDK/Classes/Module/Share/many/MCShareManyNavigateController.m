//
//  MCShareManyNavigateController.m
//  Pods
//
//  Created by wza on 2020/8/20.
//

#import "MCShareManyNavigateController.h"
#import "MCPosterModel.h"
#import "MCShareManyNavigateCell.h"

//底部小图的比例
#define small_ratio 0.2

@interface MCShareManyNavigateController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, copy) NSArray<MCPosterModel *> *dataSource;

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) UIImageView *bigImgView;

@property(nonatomic, strong) UIView *cellBackgroundView;
@property(nonatomic, strong) UIView *cellSelectedBackgroundView;

@end

@implementation MCShareManyNavigateController

- (UIView *)cellBackgroundView {
    if (!_cellBackgroundView) {
        _cellBackgroundView = [[UIView alloc] init];
        _cellBackgroundView.backgroundColor = UIColor.redColor;
    }
    return _cellBackgroundView;
}

- (UIView *)cellSelectedBackgroundView {
    if (!_cellSelectedBackgroundView) {
        _cellSelectedBackgroundView = [[UIView alloc] init];
        _cellSelectedBackgroundView.backgroundColor = MAINCOLOR;
    }
    return _cellSelectedBackgroundView;
}

- (UIImageView *)bigImgView {
    if (!_bigImgView) {
        _bigImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavigationContentTop+5, SCREEN_WIDTH, SCREEN_HEIGHT - self.collection.qmui_height-NavigationContentTop-5)];
        _bigImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bigImgView;
}
- (UICollectionView *)collection {
    if (!_collection) {
        CGFloat item_h = SCREEN_HEIGHT * small_ratio;
        CGFloat item_w = item_h * 0.562;
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(item_w, item_h - 1);
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-item_h, SCREEN_WIDTH, item_h) collectionViewLayout:flow];
        
        _collection.dataSource = self;
        _collection.delegate = self;
        
        [_collection registerClass:[MCShareManyNavigateCell class] forCellWithReuseIdentifier:@"MCShareManyNavigateCell"];
        
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"分享" backgroundImage:[UIImage qmui_imageWithColor:[UIColor blackColor]]];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collection];
    [self.view addSubview:self.bigImgView];
    
    [self requestPosters];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"分享" target:self action:@selector(share)];
    
}

- (void)share {
    if (self.bigImgView.image) {
        [MCShareStore shareIOS:self.bigImgView.image];
    }
}

- (void)requestPosters {
    
    __weak __typeof(self)weakSelf = self;
    
    [self.sessionManager mc_POST:@"/user/app/qrcodepicture/getqrcodepictureby/brandid" parameters:@{@"brandId":SharedConfig.brand_id} ok:^(MCNetResponse * _Nonnull resp) {
        weakSelf.dataSource = [MCPosterModel mj_objectArrayWithKeyValuesArray:resp.result];
        [weakSelf.collection reloadData];
        
        if (weakSelf.dataSource.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [weakSelf createShareImageWithUrl:weakSelf.dataSource.firstObject.qrcodeUrl];
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MCShareManyNavigateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCShareManyNavigateCell" forIndexPath:indexPath];
    
    [cell.bigImgView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row].qrcodeUrl] placeholderImage:nil];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MCShareManyNavigateCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImage *img = cell.bigImgView.image;
    if (img) {
        self.bigImgView.image = [MCImageStore creatShareImageWithImage:img];
    } else {
        [self createShareImageWithUrl:self.dataSource[indexPath.row].qrcodeUrl];
    }
}

- (void)createShareImageWithUrl:(NSString *)url {
    [MCLoading show];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //下载图片
        NSURL *URL = [NSURL URLWithString:url];
        if (URL) {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            UIImage *img = [UIImage imageWithData:data];
            UIImage *imgWithCode = [MCImageStore creatShareImageWithImage:img];
            if (imgWithCode) {
                //回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.bigImgView.image = imgWithCode;
                });
            }
        }
        
        //主线程关闭刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [MCLoading hidden];
        });
        
    });
}

@end

//
//  HNLinkageView.m
//  TestAppDemo
//
//  Created by rs l on 2019/8/20.
//  Copyright © 2019年 黎鹏. All rights reserved.
//

#import "HNLinkageView.h"
#import "ZXBHeader.h"
#import "PublicFunction.h"
#import "RepairInfoModel.h"

@interface HNLinkageView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *leftDataArray;

@end


@implementation HNLinkageView{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray*)data block:(resultBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
        _isScrollDown = YES;
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
        self.leftDataArray = data;
        self.rightDataArray = ((RepairInfoModel*)[_leftDataArray objectAtIndex:0]).children;
        self.myBlock = block;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
        _isScrollDown = YES;
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];


    }
    return self;
}




- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  self.bounds.size.width/3, self.bounds.size.height)];

        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 40*PXSCALEH;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.size.width/3, 0,  self.bounds.size.width*2/3, self.bounds.size.height)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 40*PXSCALEH;
        _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _rightTableView.showsVerticalScrollIndicator = NO;
    }
    return _rightTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.leftDataArray.count;
    }
    else
    {
        
        return self.rightDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell"];
        }
        UILabel* nameLabel = [PublicFunction getlabel:CGRectMake(0, 0, _leftTableView.bounds.size.width, 40*PXSCALEH) text:@"a" size:14 align:@"center"];
        RepairInfoModel *model = self.leftDataArray[indexPath.row];
        nameLabel.text = model.xlz;

        [cell.contentView addSubview:nameLabel];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"cell1"];
        }
        RepairInfoModel *model = [self.rightDataArray objectAtIndex:indexPath.row];

        NSString* imgName = model.isSelected==YES?@"right_now":@"right_now_no";
        UIImageView* checkBtnImg = [PublicFunction getImageView:CGRectMake(10*PXSCALE, (40*PXSCALEH-20*PXSCALEH)/2, 20*PXSCALE, 20*PXSCALEH) imageName:imgName];
        
        checkBtnImg.tag = 100;
//        [checkBtn setImage:[UIImage imageNamed:@"right_now"] forState:UIControlStateSelected];
//        [checkBtn setImage:[UIImage imageNamed:@"right_now_no"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//no
        cell.selectedBackgroundView = [[UIView alloc] init];
        //就这两句代码
        cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
        UILabel* nameLabel = [PublicFunction getlabel:CGRectMake(0, 0, _rightTableView.bounds.size.width, 40*PXSCALEH) text:@"" size:14 align:@"center"];
      
        nameLabel.text = model.xlg;

        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:checkBtnImg];
        return cell;
    }
}




//// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && !_isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section];
    }
}
//
// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && _isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        //清空原来数据
//        NSMutableArray* originalRightDataArray = ((RepairInfoModel*)[_orginDataArray objectAtIndex:_selectIndex]).children;
        RepairInfoModel* leftDataModel = [_leftDataArray objectAtIndex:_selectIndex];
//        leftDataModel.children = originalRightDataArray;
        for (RepairInfoModel* model in leftDataModel.children) {
            model.isSelected = NO;
        }
        [_leftDataArray replaceObjectAtIndex:_selectIndex withObject:leftDataModel];
        //更新新的数据
        _selectIndex = indexPath.row;
        _rightDataArray = ((RepairInfoModel*)[_leftDataArray objectAtIndex:_selectIndex]).children;
        [_rightTableView reloadData];
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView* checkBtnImg = [cell viewWithTag:100];
        RepairInfoModel *model = [self.rightDataArray objectAtIndex:indexPath.row];
        model.isSelected = !model.isSelected;
        NSString* imgName = model.isSelected==YES?@"right_now":@"right_now_no";
        [checkBtnImg setImage:[UIImage imageNamed:imgName]];
        [self.rightDataArray replaceObjectAtIndex:indexPath.row withObject:model];
//        [self.rightTableView reloadData];
        
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - Getters
- (NSMutableArray *)leftDataArray
{
    if (!_leftDataArray) {
        _leftDataArray = [NSMutableArray array];
    }
    return _leftDataArray;
}

- (NSMutableArray *)rightDataArray
{
    if (!_rightDataArray) {
        _rightDataArray = [NSMutableArray array];
    }
    return _rightDataArray;
}


@end

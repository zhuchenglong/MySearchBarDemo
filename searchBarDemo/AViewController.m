//
//  AViewController.m
//  searchBarDemo
//
//  Created by zhuchenglong on 16/7/5.
//  Copyright © 2016年 zhuchenglong. All rights reserved.
//

#import "AViewController.h"
#import "ViewController.h"
#import "DataModel.h"
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width

@interface AViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)NSArray *dataArray;

//@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation AViewController
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [DataModel demoData];
    }
    return _dataArray;
    
}
-(NSMutableArray *)resultArray{
    
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

-(UITableView *)tableView{
    
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth,kHeight-20)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 44;
        _tableView.layer.cornerRadius = 5;
        _tableView.tableHeaderView = [self headView];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
//UISearchBar作为tableview的头部
-(UIView *)headView{
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, 100, 44)];
    searchBar.keyboardType = UIKeyboardAppearanceDefault;
    searchBar.placeholder = @"请输入搜索关键字";
    searchBar.delegate = self;
    //底部的颜色
    searchBar.barTintColor = [UIColor grayColor];
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.barStyle = UIBarStyleDefault;
    return searchBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prefersStatusBarHidden];
    
    
    [self.resultArray addObjectsFromArray:self.dataArray];
    [self.view addSubview:self.tableView];
}

#pragma mark-searchBarDelegate

//在搜索框中修改搜索内容时，自动触发下面的方法
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    NSLog(@"开始输入搜索内容");
    searchBar.showsCancelButton = YES;//取消的字体颜色，
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //改变取消的文本
    for(UIView *view in [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"输入搜索内容完毕");
}

//搜框中输入关键字的事件响应
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"输入的关键字是---%@---%lu",searchText,(unsigned long)searchText.length);
    
    //需要事先情况存放搜索结果的数组
    [self.resultArray removeAllObjects];
    
    
    //加个多线程，否则数量量大的时候，有明显的卡顿现象
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if (searchText!=nil && searchText.length>0) {
            
            //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
            for (DataModel *model in self.dataArray) {
                
                NSString *tempStr = model.content;
                
                //----------->把所有的搜索结果转成成拼音
                NSString *pinyin = [self transformToPinyin:tempStr];
                NSLog(@"pinyin--%@",pinyin);
                
                if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                    //把搜索结果存放self.resultArray数组
                    [self.resultArray addObject:model];
                }
            }
            
        }else{

            self.resultArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

//取消的响应事件
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"取消搜索");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

//键盘上搜索事件的响应
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"搜索");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark--获取汉字转成拼音字符串 通讯录模糊搜索 支持拼音检索 首字母 全拼 汉字 搜索
- (NSString *)transformToPinyin:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}

#pragma mark -- tableViewDataSouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    DataModel *model = self.resultArray[indexPath.row];
    
    //关键字高亮
//    if (_keyword) {
//        
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.content];
//        NSRange range = [model.content rangeOfString:_keyword];
//        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:range];
//        
//        cell.textLabel.attributedText = attr;
//        
//    }else{
    
        cell.textLabel.text = model.content;
   // }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

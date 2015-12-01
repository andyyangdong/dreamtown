//
//  view3TableViewController.m
//  Cartoon
//
//  Created by 冬 on 15/8/21.
//  Copyright (c) 2015年 冬. All rights reserved.
//

#import "view3TableViewController.h"
#import "JSONKit.h"
#import "view3.h"
#import "ViewController.h"
@interface view3TableViewController ()
{
    NSMutableArray *dataArray;
    NSURLConnection *conn;
    NSMutableData *resultData;
    UIActivityIndicatorView *loadingView;

}
@end

@implementation view3TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"章节列表";
    
    resultData = [[NSMutableData alloc] initWithCapacity:0];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSURL *url = [NSURL URLWithString:@"http://japi.juhe.cn/comic/chapter"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:@"key=d803f9fea3594ae4e62dc9899f755453&comicName=%@",self.comicName];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(160, 250, 50, 50)];
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView addSubview:loadingView];
    [loadingView startAnimating];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -NSURLConnection回调
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data != nil) {
        [resultData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [loadingView stopAnimating];
    loadingView.hidden = YES;
    NSString *str = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [str objectFromJSONString];
    if (dic != nil) {
        if ([dic[@"error_code"] intValue] == 200) {
            
            NSDictionary *resultDic = dic[@"result"];
            NSArray *chapterListArray = resultDic[@"chapterList"];
            for (NSDictionary *chapterDic in chapterListArray) {
               view3 *model = [[view3 alloc] init];
                model.name = chapterDic[@"name"];
                model.idx = [chapterDic[@"id"] intValue];
                
                [dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    view3 *view=dataArray[indexPath.row];
    cell.textLabel.text=view.name;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"path3"])
    {
        UITableViewCell *cell=(UITableViewCell *)sender;
        NSIndexPath *path=[self.tableView indexPathForCell:cell];
        ViewController * viewcontroller=segue.destinationViewController;
        view3 *view=dataArray[path.row];
        viewcontroller.name1=self.comicName;
        viewcontroller.idx=view.idx;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

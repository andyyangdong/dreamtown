//
//  ViewController.m
//  Cartoon
//
//  Created by 冬 on 15/8/21.
//  Copyright (c) 2015年 冬. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "view1.h"

@interface ViewController ()
{
    NSMutableArray *dataArray;
    NSURLConnection *conn;
    NSMutableData *resultData;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"漫画内容";
    
    resultData = [[NSMutableData alloc] initWithCapacity:0];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSURL *url = [NSURL URLWithString:@"http://japi.juhe.cn/comic/chapterContent"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:@"key=d803f9fea3594ae4e62dc9899f755453&comicName=%@&id=%d",self.name1,self.idx];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    

    // Do any additional setup after loading the view, typically from a nib.
}

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
    
    NSString *str = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [str objectFromJSONString];
    if (dic != nil) {
       if ([dic[@"error_code"] intValue] == 200) {
        
            NSDictionary *resultDic = dic[@"result"];
            NSArray *imageListArray = resultDic[@"imageList"];
            //整合数据
            for (NSDictionary *imageDic in imageListArray) {
               view1 *model = [[view1 alloc] init];
                model.imageurl = imageDic[@"imageUrl"];
                model.idx = [imageDic[@"id"] intValue];
                [dataArray addObject:model];
            }
            //设置imageview
            float width = self.view.frame.size.width;
            float height = self.view.frame.size.height;
            self.scrollview.contentSize = CGSizeMake(width *dataArray.count, height);
            self.scrollview.pagingEnabled = YES;
            
            for (int i = 0; i < dataArray.count;i++) {
                view1 *model = dataArray[i];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
                UIImage *image=[[UIImage alloc] init];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                NSURL *url = [NSURL URLWithString:model.imageurl];
                [imageView sd_setImageWithURL:url];
             
                [self.scrollview addSubview:imageView];
            }
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  DisplayData.m
//  FMDBDatabaseExample
//
//  Created by CI013 on 1/27/15.
//  Copyright (c) 2015 CI013. All rights reserved.
//

#import "DisplayData.h"
#import "FMDatabase.h"
@interface DisplayData ()
{
    FMDatabase *database;
    NSMutableArray *dataStore;
}
@end

@implementation DisplayData
@synthesize userimg;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set Navigation Bar Hidden NO
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
   
    dataStore=[[NSMutableArray alloc]init];
    
    //set the path of database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"path : - %@",path);
    
    database = [FMDatabase databaseWithPath:path];
    
    //Open the Database
    [database open];

    FMResultSet *results = [database executeQuery:@"select * from detail"];
    while([results next])
    {
        NSString *name = [results stringForColumn:@"name"];
        NSString *pass =[results stringForColumn:@"password"];
        NSString *mail =[results stringForColumn:@"email"];
        NSString *phone =[results stringForColumn:@"phone"];
        NSString *Add =[results stringForColumn:@"address"];
        NSString *date =[results stringForColumn:@"date"];
        NSString *getPath = [results stringForColumn:@"image"];
        
        NSArray *myStrings = [[NSArray alloc] initWithObjects:name, pass, mail, phone, Add, date, getPath, nil];
        NSString *joinedString = [myStrings componentsJoinedByString:@"|"];
        
        [dataStore addObject:joinedString];
    }
    [database close];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataStore count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell=nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    cell.backgroundView = nil;
    
    UILabel *labelName;
    
    NSArray *items1 = [[dataStore objectAtIndex:indexPath.row]componentsSeparatedByString:@"|"];
    
    /*get the path of image*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[items1 objectAtIndex:6]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    //set image in cell
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(5,0,60,40)];
    img.image=image;
    [cell addSubview:img];
    
    //set the user name in cell
    labelName=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 60, 20)];
    labelName.text=[items1 objectAtIndex:0];
    [labelName setFont:[UIFont systemFontOfSize:16]];
    [labelName setTextColor:[UIColor redColor]];
    labelName.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:labelName];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  ViewController.m
//  crashtest
//
//  Created by everettjf on 15/8/18.
//  Copyright (c) 2015年 everettjf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *message;

@end

@implementation ViewController


- (NSString *)ReadContent
{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"log"];
    
    NSLog(@"read log path = %@",filePath);
    
    NSString * content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

-(void) WriteContent:(NSString*) content
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"log"];
    
    if(! [fileManager fileExistsAtPath:filePath]){
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSLog(@"write log path = %@",filePath);
    
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *content = [self ReadContent];
    if(nil == content){
        [self.message setText:@"nil content"];
        return;
    }
    [self.message setText:content];
    
}
- (IBAction)writeSome:(id)sender {
    [self WriteContent:@"helloooo"];
}


- (IBAction)readLogTouchUp:(id)sender {
    NSString *content = [self ReadContent];
    if(nil == content){
        [self.message setText:@"nil content"];
        return;
    }
    [self.message setText:content];
}
- (IBAction)creshTouchUp:(id)sender {
    int *arr = 0 ;
    *arr = 300;
}
- (IBAction)crashExceptionTouchUp:(id)sender {
//    @throw @100;
    NSArray *array = [NSArray arrayWithObject:@"there is only one objective in this arary,call index one, app will crash and throw an exception!"];
    NSLog(@"%@", [array objectAtIndex:1]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

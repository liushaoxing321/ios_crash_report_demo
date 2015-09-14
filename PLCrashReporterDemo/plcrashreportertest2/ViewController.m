//
//  ViewController.m
//  plcrashreportertest2
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

- (IBAction)clearPending:(id)sender {
    [self WriteContent:@""];
    
    
    [self ReadLog];
    
}

- (void)ReadLog{
    
    
    NSString *content = [self ReadContent];
    if(nil == content){
        [self.message setText:@"nil content"];
        return;
    }
    
    if([content isEqualToString:@""]){
        [self.message setText:@"empty content"];
        return;
    }
    
    [self.message setText:content];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self ReadLog];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exceptionTouchUp:(id)sender {
    NSArray *array = @[@"hi"];
    NSLog(@"%@", [array objectAtIndex:1]);
}
- (IBAction)exceptionCrash:(id)sender {
    ((char *)NULL)[1] = 0;
}
- (IBAction)crashByPointer:(id)sender {
    int *x = 0;
    *x = 200;
}
- (IBAction)crashByDivideZero:(id)sender {
    int x = 0;
    int y = 10 / x;
    int z = 10 / 0;
    int z1 = 1 / 0;
    
    NSLog(@"y = %d , z = %d , z1=%d",y,z,z1);
}

@end

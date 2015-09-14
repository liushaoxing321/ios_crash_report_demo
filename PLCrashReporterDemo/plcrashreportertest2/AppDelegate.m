//
//  AppDelegate.m
//  plcrashreportertest2
//
//  Created by everettjf on 15/8/18.
//  Copyright (c) 2015年 everettjf. All rights reserved.
//

#import "AppDelegate.h"
#import <CrashReporter/CrashReporter.h>
#import <CrashReporter/PLCrashReportTextFormatter.h>

@interface AppDelegate ()

@end

@implementation AppDelegate



- (NSString *)ReadContent
{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"log"];
    
    NSLog(@"read log path = %@",filePath);
    
    NSString * content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

-(NSString*)crashDataPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"d.plcrash"];
    
    if(! [fileManager fileExistsAtPath:filePath]){
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
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


//
 // Called to handle a pending crash report.
 //
- (void) handleCrashReport {
     PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
     NSData *crashData;
     NSError *error;

     // Try loading the crash report
     crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
     if (crashData == nil) {
         NSLog(@"Could not load crash report: %@", error);
         [crashReporter purgePendingCrashReport];
         return;
     }
    
    [crashData writeToFile:[self crashDataPath] atomically:YES];

     // We could send the report from here, but we'll just print out
     // some debugging info instead
     PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
     if (report == nil) {
         NSLog(@"Could not parse crash report");
         [crashReporter purgePendingCrashReport];
         return;
     }

     NSLog(@"Crashed on %@", report.systemInfo.timestamp);
     NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
           report.signalInfo.code, report.signalInfo.address);
    
    NSString *humanText = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
    
    [self WriteContent:humanText];
    
     // Purge the report
     [crashReporter purgePendingCrashReport];
    
     return;
 }

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport])
        [self handleCrashReport];

    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError: &error])
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

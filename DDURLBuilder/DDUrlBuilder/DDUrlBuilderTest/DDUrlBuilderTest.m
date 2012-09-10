#import "DDUrlBuilderTest.h"
#import "DDURLBuilder.h"

@implementation DDUrlBuilderTest


// non-deterministic due to NSDictionary usage
-(void)testAuthorExample
{
    
    NSURL* expected_ = [ NSURL URLWithString: @"http://www.google.com/search?client=safari&rls=en&q=what+is+the+answer+to+the+ultimate+question+of+life+the+universe+and+everything&ie=UTF-8&oe=UTF-8" ];
    
    DDURLBuilder *builder = [DDURLBuilder URLBuilderWithURL:nil];
    [builder setHost:@"google.com"];
    [builder setScheme:@"http"];
    [builder setPath:@"search"];
    [builder addQueryValue:@"safari" forKey:@"client"];
    [builder addQueryValue:@"en" forKey:@"rls"];
    [builder addQueryValue:@"what is the answer to the ultimate question of life the universe and everything" forKey:@"q"];
    [builder addQueryValue:@"UTF-8" forKey:@"ie"];
    [builder addQueryValue:@"UTF-8" forKey:@"oe"];

    NSURL* received_ = [ builder URL ];
    
    // non-deterministic due to NSDictionary usage
    STAssertTrue( [ expected_ isEqual: received_ ], @"result URL mismatch" );
}

-(void)testSkipEncodingFlagAppendsPathAsIs
{
    DDURLBuilder* builder_ = [ DDURLBuilder URLBuilderWithURL: [ NSURL URLWithString: @"http://10.38.10.244/sitecore/login" ] ];
    builder_.shouldSkipPathPercentEncoding = YES;
    builder_.path = @"/sitecore/shell/Applications/Login/Users/Users.aspx?su=%2fsitecore%2fshell%2fapplications%2fclientusesoswindows.aspx%3fsc_lang%3den";
    
    NSURL* receivedUrl_ = [ builder_ URL ];
    NSString* received_ = [ receivedUrl_ absoluteString ];
    
    STAssertEqualObjects(
        received_,
        @"http://10.38.10.244/sitecore/shell/Applications/Login/Users/Users.aspx?su=%2fsitecore%2fshell%2fapplications%2fclientusesoswindows.aspx%3fsc_lang%3den",
        @"URL mismatch");
}

-(void)testDisabledSkipEncodingFlagSplitsPath
{
    DDURLBuilder* builder_ = [ DDURLBuilder URLBuilderWithURL: [ NSURL URLWithString: @"http://10.38.10.244/sitecore/login" ] ];
    builder_.shouldSkipPathPercentEncoding = NO;
    builder_.path = @"/sitecore/shell/Applications/Login/Users/Users.aspx?su=%2fsitecore%2fshell%2fapplications%2fclientusesoswindows.aspx%3fsc_lang%3den";
    
    NSURL* receivedUrl_ = [ builder_ URL ];
    NSString* received_ = [ receivedUrl_ absoluteString ];
    
    STAssertEqualObjects(
                         received_,
                         @"http://10.38.10.244/sitecore/shell/Applications/Login/Users/Users.aspx%3Fsu%3D%252fsitecore%252fshell%252fapplications%252fclientusesoswindows.aspx%253fsc_lang%253den",
                         @"URL mismatch");
}

@end

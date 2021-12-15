#import <CoreLocation/CoreLocation.h>

NSString *configFilePath;

%hook CLLocation

-(CLLocationCoordinate2D)coordinate {

        NSDictionary *locationDictTMP = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];

        if (locationDictTMP){
                [locationDictTMP writeToFile:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakconfiguration.plist" atomically:YES];

        } else {
                [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakconfiguration.plist" error:nil];
        }

        NSDictionary *locationDict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakconfiguration.plist"];

        if (locationDict && [[locationDict objectForKey:@"enabled"] integerValue] == 1) {

                        CLLocationCoordinate2D coordinates;
                        coordinates.latitude = [[locationDict objectForKey:@"latitude"] doubleValue];
                        coordinates.longitude = [[locationDict objectForKey:@"longitude"] doubleValue];
                        return coordinates;
        }

        return %orig;
}

-(CLLocationDistance)altitude {

        NSDictionary *locationDictTMP = [[NSDictionary alloc] initWithContentsOfFile:configFilePath];

        if (locationDictTMP){
                [locationDictTMP writeToFile:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakconfiguration.plist" atomically:YES];

        } else {
                [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakconfiguration.plist" error:nil];
        }

        NSDictionary *locationDict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakconfiguration.plist"];

        if (locationDict && [[locationDict objectForKey:@"enabled"] integerValue] == 1) {

                CLLocationDistance altitude;
                altitude = [[locationDict objectForKey:@"altitude"] doubleValue];
                return altitude;
        }

        return %orig;
}

%end

%ctor{
        configFilePath = [NSString stringWithContentsOfFile:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakpath.plist" encoding:NSUTF8StringEncoding error:nil];

        if (configFilePath && [[NSFileManager defaultManager] fileExistsAtPath:configFilePath]){
                return;
        }

        configFilePath = nil;

        NSString *path = @"/var/mobile/Containers/Data/Application/";
        NSArray *dirPaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];

        for (NSString* dirPath in dirPaths){

                NSString *filePath = [path stringByAppendingPathComponent:[dirPath stringByAppendingPathComponent:@"Library/cz.muni.locationspoofer.plist"]];

                if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){

                        configFilePath = filePath;
                        [configFilePath writeToFile:@"/var/mobile/Library/Preferences/cz.muni.locationspoofertweakpath.plist" atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];

                        return;
                }
        }
}

import Foundation
import UIKit

let appDelegateClass: AnyClass = NSClassFromString("SixtTests.UnitTestAppDelegate") ?? AppDelegate.self
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))

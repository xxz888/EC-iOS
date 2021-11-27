#
#  Be sure to run `pod spec lint OEMSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "OEMSDK"
  spec.version      = "0.0.1"
  spec.summary      = "项目基础库（工具和组件）"

  # This description is used to generate tags and improve search results.
  spec.description  = <<-DESC
    mc项目基础库，在此基础上进行o单开发。
                   DESC
  spec.homepage     = "http://baidu.cn"
  spec.license      = "LICENSE"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "agvale" => "agvale@aliyun.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios, "9.0"
  spec.ios.deployment_target = "9.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source_files  = "Classes/**/*"

  # spec.exclude_files = "Classes/Exclude"
  spec.public_header_files = "Classes/**/*.h"
  spec.prefix_header_contents = '#import "OEMSDK.h"'

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  # 本项目的资源文件
  spec.resource_bundles = {
    'OEMSDK' => ['Assets/*']
  }
  
  # 第三方的资源文件
  spec.resources = ['TXAuth/*.bundle','TXAuth/*.bin','TXAuth/*.ref']

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.vendored_frameworks = 'Vendor/*.framework'
  spec.libraries = "c++", "z", "sqlite3"
  spec.frameworks = 'AVFoundation', 'Accelerate', 'AdSupport', 'AudioToolbox', 'CoreGraphics', "CoreLocation", "CoreMedia", "CoreServices", "CoreTelephony", "CoreVideo", "CoreVideo", "ImageIO", "Photos", "Security", "SystemConfiguration", "WebKit", "CoreMotion"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.requires_arc = true
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/OEMSDK',
  }
  
  # ――― Project pods     ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.dependency "QMUIKit", '4.1.3'
  spec.dependency "Masonry", '1.1.0'
  spec.dependency "MJRefresh", '3.4.3'
  spec.dependency "AFNetworking", '4.0.1'
  spec.dependency "MBProgressHUD", '1.2.0'
  spec.dependency "SDCycleScrollView", '1.80'
  spec.dependency "MJExtension", '3.2.2'
  spec.dependency "JPush", '3.3.3'
  spec.dependency "JAnalytics", '2.1.2'
  spec.dependency "JShare", '1.9.0'
  spec.dependency "MGJRouter", '0.10.0'
  spec.dependency "IQKeyboardManager", '6.5.5'
  spec.dependency "Meiqia", '3.6.9'
  
  spec.dependency "UMCCommon", '7.1.0'
  spec.dependency "UMCShare/UI", '6.9.9'
  spec.dependency "UMCShare/Social/ReducedWeChat", '6.9.9'
  spec.dependency "UMCShare/Social/ReducedQQ", '6.9.9'
  
  spec.dependency "iCarousel", '1.8.3'
  spec.dependency "SDAutoLayout", '2.2.1'
  spec.dependency "PGDatePicker", '2.6.9'
  spec.dependency "BRPickerView", '2.6.3'
  spec.dependency "LYEmptyView", '1.3.1'
  spec.dependency "SGQRCode", '3.0.1'
  spec.dependency "WMPageController", '2.4.0'

end

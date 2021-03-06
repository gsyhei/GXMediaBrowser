#
#  Be sure to run `pod spec lint GXMediaBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #  s.dependency     "DACircularProgress", "~> 2.3.1" s.dependency     "SDWebImage", "~> 3.8.2"
  #

  s.name         = "GXMediaBrowser"
  s.version      = "0.0.1"
  s.summary      = "一个好用的图片浏览器"
  s.homepage     = "https://github.com/gsyhei/GXMediaBrowser.git"
  s.license      = "MIT"
  s.author       = { "Gin" => "279694479@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/gsyhei/GXMediaBrowser.git", :tag => "0.0.1" }
  s.requires_arc = true
  s.source_files = "GXMediaBrowser/GXMediaBrowser*.{h,m}"

  s.subspec "DACircularProgress" do |sd|
    sd.dependency "DACircularProgress", "~> 2.3.1"
    sd.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/DACircularProgress" }
  end

  s.subspec "SDWebImage" do |ss|
    ss.dependency "SDWebImage", "~> 3.8.2"
    ss.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/SDWebImage" }
  end

  s.framework    = "UIKit"

end

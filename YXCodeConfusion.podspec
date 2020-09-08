#
#  Be sure to run `pod spec lint YXCodeConfusion.podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "YXCodeConfusion"
  spec.version      = "0.0.1"
  spec.summary      = "代码混淆"
  spec.description  = <<-DESC
                    This is a code obfuscation
                   DESC

  spec.homepage     = "https://github.com/yaohongxiao49/YXCodeConfusion.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "BelieverJust" => "617146817@qq.com" }

  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/yaohongxiao49/YXCodeConfusion.git", :tag => "#{spec.version}" }

  spec.source_files  = "YXCodeConfusionTest", "YXCodeConfusionTest/CodeObfuscation/*.{h,list}"
  spec.exclude_files = "Classes/Exclude"
  spec.public_header_files = "CodeObfuscation/*.{h,list}"
  spec.prefix_header_file = "YXCodeConfusionTest/YXCodeConfusion.pch"

end

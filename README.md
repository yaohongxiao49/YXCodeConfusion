# YXCodeConfusion
代码混淆

1、分别创建.sh，empty->.list，.h。
2、于targets->Build Phases中添加Run Script并添加地址，如"$PROJECT_DIR/YXCodeConfusionTest/CodeObfuscation/confush.sh"。
3、于Prefix Header中添加地址，如"$(SRCROOT)/YXCodeConfusionTest/YXCodeConfusion.pch"。
4、于.sh中添加代码，见底部。（如脚本失败，则可于终端中cd至当前文件所在目录，sudo chmod 777 xxx.sh，进行权限修改）
5、于.list中添加需要混淆的方法名、属性名。
6、于项目.pch中添加.h。
7、build，如果成功后于.h中可见如"#define testMethod TivUUkoVpUUmKCCx"，前方为需要混淆的方法，后方为混淆后的方法。
8、如混淆成功，则可于混淆方法中，jump至.h中。

.sh脚本代码
TABLENAME=symbols
SYMBOL_DB_FILE="$PROJECT_DIR/YXCodeConfusionTest/CodeObfuscation/symbols"
STRING_SYMBOL_FILE="$PROJECT_DIR/YXCodeConfusionTest/CodeObfuscation/func.list"
HEAD_FILE="$PROJECT_DIR/YXCodeConfusionTest/CodeObfuscation/codeObfuscation.h"
export LC_CTYPE=C
 
#维护数据库方便日后作排重
createTable() {
  echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}
 
insertValue() {
  echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}
 
query() {
  echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}
 
ramdomString() {
  openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16
}
 
rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable
 
touch $HEAD_FILE
echo '#ifndef YXCodeObfuscationH
#define YXCodeObfuscationH' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE
 
sqlite3 $SYMBOL_DB_FILE .dump


发布至cocoapods
#http://guides.cocoapods.org/syntax/podspec.html 命名说明
1、创建一个Git公有库并clone下来；
2、cd至项目目录下，创建一个podspec： pod spec create xxx
3、自动生成如下模板

Pod::Spec.new do |spec|

  spec.name                = "YXCategoryGroup" #跟文件名保持一致
  spec.version             = "0.1.0" #版本号
  spec.summary             = "基础数据类型的分类集合" #简短描述，下面的是详细介绍
  spec.description         = <<-DESC
                             this project provide all kinds of categories for iOS developer 
                          DESC
#项目可访问的地址
  spec.homepage            = "https://github.com/yaohongxiao49/YXCategoryGroup" 
#协议
  spec.license             = { :type => "MIT", :file => "LICENSE" } 
#作者信息
  spec.author              = { "JustBeliever" => "617146817@qq.com" } 
#支持的平台及版本
  spec.platform            = :ios, "10.0" 
  spec.source              = { :git => "https://github.com/yaohongxiao49/YXCategoryGroup.git", :tag => "#{spec.version}"} #项目地址
#代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置
  spec.source_files        = "YXCategoryGroupTest/**/*.{h,m}"
#不包含的文件
  spec.exclude_files       = "Classes/Exclude" 
#开放的头文件，可使用<>联想调用的
  spec.public_header_files = "YXCategoryGroupTest/**/*.h" 

#组件化
  spec.subspec 'YXCategorys' do |s| 
    s.source_files         = "YXCategoryGroupTest/YXCategorys/**/*.{h,m}"
    s.public_header_files  = "YXCategoryGroupTest/YXCategorys/**/*.h"
    s.prefix_header_file   = "YXCategoryGroupTest/YXCategorys/YXCategorysPCH.pch"
  end

#pch所在地址
  spec.prefix_header_file  = 'YXCategoryGroupTest/YXClassesReferencePCH.pch' 
  spec.requires_arc        = true

#所需依赖系统的framework，多个用逗号隔开
#  spec.frameworks         =  ‘UIKit’
#添加依赖第三方的framework
#  spec.vendored_frameworks = 'PTThirdPlatformKit/TencentManager/**/*.framework' 
#依赖的核心模块，多个就写多个
#  spec.dependency “AFNetworing “, “->2.3” 
#添加资源文件
#  spec.resource = 'PTThirdPlatformKit/TencentManager/**/*.bundle' 

end

4、校验配置：pod lib lint --allow-warnings
5、创建tag：git tag -a '0.1.0' -m "描述xxx" 版本号要与配置中的一致。
6、推送tag到远程仓库：git push --tags。
7、发布自己的库描述文件podspec给cocoapods：pod trunk push xxx.podspec --allow-warnings。
8、如果是第一次发布则需要先 pod trunk register 邮箱地址 ‘用户名’ --description=‘描述’，然后进行第7步。
9、添加人员：pod trunk add-owner 库名 邮箱地址。
10、移除人员：pod trunk remove-owner 库名 邮箱地址。
11、移除标签：git tag -d ‘0.1.0’。
12、移除远程标签：git push origin :refs/tags/'0.1.0'。
13、查看自己发布过的pods：pod trunk me。
14、显示发布过的库信息：pod trunk info 库名。
15、移除库中某一个版本：pod trunk delete 库名 版本号。
16、让库中某一个版本过期：pod trunk deprecate 库名 版本号。

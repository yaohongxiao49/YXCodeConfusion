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

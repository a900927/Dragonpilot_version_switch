# Author : czde
# Email : mmlsc@qq.com

sys_check(){
echo "-------------------------------------------------------------------------------------------"
echo "当前DP版本："
cd /data/openpilot
git branch -a
backup_time=`date +"%Y%m%d%H%M"`
}


curl https://api.github.com/repos/dragonpilot-community/dragonpilot/branches |grep name |grep :|awk {'print $2'}|sed 's/,//g'|sed 's/\"//g' >./version
clear
#cat ./branches |grep name |grep :|awk {'print $2'} >./version
array=($(cat ./version))
echo "--------------------------------------------------"
echo -e "选择要升级的DP版本"
echo "--------------------------------------------------"
for ((i=0;i<${#array[@]};i++))
do 
    echo -e "\033[41;33m  $i \033[0m" ——\> ${array[i]}
done

install_dp(){
echo "备份DP目录"
cd /data
mv openpilot openpilot$backup_time
version=${array[$selected]}
git clone http://github.com.cnpmjs.org/dragonpilot-community/dragonpilot openpilot -b $version --depth 1
echo "打开 openpilot 目录"
cd openpilot

echo "查看全部分支和当前分支"
git branch -a

echo "切换到目标分支"
git checkout $version

echo "重新查看确认当前分支"
git branch

echo "请手动重启EON或等待30秒后自动重启设备"
sleep 30
reboot
}

while true; do

read -p "请输入对应数字:" selected
echo "选择版本为":"\033[1;34m ${array[$selected]} \033[0m"
dp_update=true
break;
done

if  [[ ${dp_update} == true ]]; then
	sys_check
	install_dp
else
    echo -e "退出升级"
fi
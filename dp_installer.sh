# Author : czde
# Email : mmlsc@qq.com

sys_check(){
echo "-------------------------------------------------------------------------------------------"
echo "当前DP版本："
cd /data/openpilot
git branch -a
backup_time=`date +"%Y%m%d%H%M"`
}


curl https://api.github.com/repos/dragonpilot-community/dragonpilot/branches |grep name |grep :|awk {'print $2'}|sed 's/,//g'|sed 's/\"//g' >/tmp/version
clear
#cat ./branches |grep name |grep :|awk {'print $2'} >./version
array=($(cat /tmp/version))
echo "--------------------------------------------------"
echo -e "选择要升级的DP版本"
echo "--------------------------------------------------"
for ((i=0;i<${#array[@]};i++))
do 
    echo -e "\033[41;33m  $i \033[0m" ——\> ${array[i]}
done

git_clone(){
cd /data
version=${array[$selected]}
git clone http://github.com.cnpmjs.org/dragonpilot-community/dragonpilot openpilot -b $version --depth 1
echo "打开 openpilot 目录"
cd openpilot
echo "--------------------------------------------------"
echo "查看全部分支和当前分支"
git branch -a
echo "--------------------------------------------------"
echo "切换到目标分支"
git checkout $version
echo "--------------------------------------------------"
echo "重新查看确认当前分支"
git branch
echo "--------------------------------------------------"
echo "设置语言时区为中国"
setprop persist.sys.language zh
setprop persist.sys.country CN
setprop persist.sys.timezone Asia/Shanghai
echo "--------------------------------------------------"
echo "跳过新手引导"
echo -n 2 > /data/params/d/HasAcceptedTerms
echo -n 1 > /data/params/d/HasCompletedSetup
echo "--------------------------------------------------"
echo "请手动重启EON或60秒后设备自动重启"
echo "如需取消重启操作，请按CTRL + C"
sleep 60
echo "--------------------------------------------------"
reboot
}

install_dp(){
echo "--------------------------------------------------"
echo "检查当前环境"
if [ ! -d "/data/openpilot" ]; then
echo "/data/openpilot目录不存在,判断为界面安装"
echo "--------------------------------------------------"
echo "生成/data/data/com.termux/files/continue.sh"
echo "--------------------------------------------------"
echo "#!/usr/bin/bash
cd /data/openpilot
exec ./launch_openpilot.sh" > /data/data/com.termux/files/continue.sh
chmod u+x /data/data/com.termux/files/continue.sh
git_clone
else
sys_check
echo "--------------------------------------------------"
echo "备份DP目录"
echo "--------------------------------------------------"
mv /data/openpilot /data/openpilot_${version}_${backup_time}
git_clone
fi
}

while true; do

read -p "请输入对应数字:" selected
echo "选择版本为 ${array[$selected]}"
dp_update=true
break;
done

if  [[ ${dp_update} == true ]]; then
	install_dp
else
    echo -e "退出升级"
fi

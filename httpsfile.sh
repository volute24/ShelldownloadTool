#! /bin/bash

#获取环境变量
if [ -f ~/.bash_profile ];
then
  . ~/.bash_profile
else 
   echo ".bash_profile not exist!"
fi

#包含路径配置文件
. $HOME/debug/httpsclient/filepath.cfg


#下载文件
function downLoadSiglefile()
{
	echo "downloadd to Local path:$LocalSavePath"
    #cd $$LocalSavePath
	nUpdateCnt=0
	for((index=0;index<j;index++)) 
	{  
		if [ ! -f "${LocalSavePath}${list[index]}" ];
		then
			#touch ${list[index]}
		    curl -O  -s -k -u $username:$password "$httpsHome${list[index]}"
		    mv ${list[index]} ${LocalSavePath}
			echo "update fileneme:${list[index]}"
			((nUpdateCnt++))
		else
			#echo "download--->[${list[index]}] file exist"
			continue
		fi
	}
	echo "Total update files:${nUpdateCnt}"
}

#mian start

#发送curl get请求,获取文件列表,重定向到文件 
curl -XGET -u $username:$password -k  -s "$httpsHome"  > "${shellHome}filelist.txt"

#取文件名,保存在list中
listNum=$(cat "${shellHome}filelist.txt" | wc -l)
nStartpos=5                
nEndpos=$(($listNum-2))
 
#echo "sum list : $listNum"
#echo  "nStartpos : $nStartpos" 
#echo "nEndpos:$nEndpos"

j=0
for((;$nStartpos <= $nEndpos;))
{ 
	#echo "nstartpos values : $nStartpos"
	#取文件名存入数组
	list[j]=$(cat "${shellHome}filelist.txt"|sed -n "${nStartpos}p"|awk '{print $2}'|awk -F '>' '{print $2}'|awk -F '<' '{print $1}')  
	((j++))
	((nStartpos++))
}

echo "sum file list:$j"
downLoadSiglefile $list $j
#释放list
unset list
echo "update success !"
exit 0


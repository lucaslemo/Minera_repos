#!/bin/bash
while read line_repos
do
	num_pg=1
	link=${line_repos% *}
	linguagem=${line_repos#* }
	repos=${link#*/}
	while [ $num_pg -le 2 ]
	do
		curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$link/pulls?state=close&page=$num_pg&per_page=100" | jq ".[] | .user.login" >> ${linguagem}_${repos}.csv
		num_pg=$(($num_pg+1))
	done
	sed -e "s/\"//g" "${linguagem}_${repos}.csv" | sort | uniq -c | sort -rn -o "${linguagem}_${repos}.csv"
	sed -e"s/^ *//g" -e"s/ /,/g" "${linguagem}_${repos}.csv" | awk -F"," '{OFS=",";print$2,$1;}' >> "${linguagem}_${repos}.csv"
	sed -i -e "/ /d" "${linguagem}_${repos}.csv"
done < repositorios.txt

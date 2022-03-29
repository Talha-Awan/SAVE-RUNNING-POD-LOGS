while (true)
 do
#COMMAND=`kubectl get --no-headers=true pods -o NAME | awk -F "/" '{print $2}' | grep "download-worker"`
COMMAND=`kubectl get --no-headers=true pods -o NAME --field-selector=status.phase=Running| awk -F "/" '{print $2n}'` 



for pod_name in $COMMAND
do
#echo $pod_name
 if [[ "${pod_name,,}" == *"download-worker"* ]] ;then

if ! [[ ${first[*]} =~ "$pod_name" ]]
then
date=`date -u`
date=all="${date// /.}"
#echo 'trying'
#echo 'kubectl logs -f  '$pod_name '>>_dwworker.txt || kubectl logs -f  '$pod_name '>>_detector.txt ||'
`kubectl logs -f  $pod_name download-worker >>${pod_name}_${date}_dwworker.txt& kubectl logs -f  $pod_name cc-detector >>${pod_name}_${date}__detector.txt& ` 
#echo  'done'
fi
first=$COMMAND

fi
done

#echo 'sleeping'
sleep 60

done



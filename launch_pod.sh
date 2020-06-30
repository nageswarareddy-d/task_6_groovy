php=$(ls  /root/.jenkins/workspace/task6_job1/* |grep php |wc -l)
html=$(ls  /root/.jenkins/workspace/task6_job1/* |grep html |wc -l)
## Launching PHP ReplicaSet
if [ "$php" -gt 0 ]; then
   mkdir -p /tmp/code
   mkdir -p /tmp/yml
   cp /root/.jenkins/workspace/task6_job1/*.php /tmp/code/
   cp /root/.jenkins/workspace/task6_job1/*.yml /tmp/yml/
   kubectl apply -f /tmp/yml/pvc.yml
   kubectl apply -f /tmp/yml/php-rs.yml
   kubectl apply -f /tmp/yml/expose-rs.yml
   sleep 15
   POD=$(kubectl get pod -l environment=test -o jsonpath="{.items[:].metadata.name}")
   for pod in $POD
   do
		kubectl cp /tmp/code/* $pod:/var/www/html
   done 
fi

## Launching HTML ReplicaSet
if [ "$html" -gt 0 ]; then
   mkdir -p /tmp/code
   mkdir -p /tmp/yml
   cp /root/.jenkins/workspace/task6_job1/*.html /tmp/code/
   cp /root/.jenkins/workspace/task6_job1/*.yml /tmp/yml/
   kubectl apply -f /tmp/yml/pvc.yml
   kubectl apply -f /tmp/yml/apache-rs.yml
   kubectl apply -f /tmp/yml/expose-rs.yml
   sleep 15
   POD=$(kubectl get pod -l environment=test -o jsonpath="{.items[:].metadata.name}")
   for pod in $POD
   do
		kubectl cp /tmp/code/* $pod:/var/www/html
   done 
fi


application_ip=$(kubectl get nodes -o jsonpath={.items[*].status.addresses[?\(@.type==\"InternalIP\"\)].address})
port=$(kubectl get service pv-pod -o jsonpath="{.spec.ports[:].nodePort}")
test_status=$(curl -s -o /dev/null -w "%{http_code}" http://$application_ip:$port)
if [ "$test_status" -eq 200 ]; then
    echo "Testing Successful"
else 
	echo "Testing Failed"
    exit 1    
fi  

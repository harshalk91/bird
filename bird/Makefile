bird:
	go build -o getBird

docker_build_scan:
	cd script && ./build_docker_image.sh

helm_template:
	cd script && ./create_helm_template.sh	

develop_deploy:
	cd deploy/develop && kubectl apply -f bird_deployment.yaml || exit 1
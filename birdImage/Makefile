birdImage:
	go build -o getBirdImage

docker_build_scan:
	cd script && ./build_docker_image.sh

helm_template:
	cd script && ./create_helm_template.sh	

develop_deploy:
	cd deploy/develop && kubectl apply -f bird_image_deployment.yaml || exit 1
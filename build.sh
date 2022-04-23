aws ecr get-login --no-include-email | sh

if [ $? -ne 0 ]; then
  if echo ${output} | grep -q RepositoryNotFoundException; then
    aws ecr create-repository --repository-name nginx
else
    >&2 echo ${output}
  fi
fi


IMAGE_REPO=$(aws ecr describe-repositories --repository-names nginx --query 'repositories[0].repositoryUri' --output text)

echo $IMAGE_REPO

docker tag nginx:latest $IMAGE_REPO:v1
docker push $IMAGE_REPO:v1


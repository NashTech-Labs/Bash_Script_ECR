#!/bin/bash
   while read -r images ; do
        repo=$(echo $images | cut -d ':' -f 1)
        tag=$(echo $images | cut -d ':' -f 2)
        image_exist=0
        repo_exist=0
        echo The Repository is $repo and the tag is $tag
        aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com
        ecr_tags=($(aws ecr list-images --repository-name $repo --region $REGION | jq '.imageIds[].imageTag' | tr "\n" " " | tr -d '"'))
        for ecr_tag in "${ecr_tags[@]}"
          do
             if [[ $tag == $ecr_tag ]]
             then
                      echo "This Image already Exist , So No need to Push"
                      image_exist=1
                      break
             fi
          done
        ecr_repo=($(aws ecr describe-repositories --region $REGION | jq '.repositories[].repositoryName' | tr "\n" " " | tr -d '"'))
        for repository in "${ecr_repo[@]}"
          do
             if [[ $repo == $repository ]]
             then
                      echo "THis Repo already Exists , So Skipping Repository Creation"
                      repo_exist=1
                      break
             fi
          done
        if [[ $image_exist -eq 1 ]]          
        then
            continue
        fi
       if [[ $repo_exist -eq 0 ]] 
        then 
         aws ecr create-repository --repository-name $repo  --image-scanning-configuration scanOnPush=true  --image-tag-mutability IMMUTABLE  --encryption-configuration encryptionType=kms --region $REGION
         aws ecr set-repository-policy --repository-name $repo --policy-text ./ecr-policy.json --region $REGION
        fi  
       docker login $REGISTRY_ENDPOINT --username $username --password $password
       docker pull $images
       docker login -u AWS -p $(aws ecr get-login-password --region $REGION $ACCOUNT.dkr.ecr.$REGION.amazonaws.com)
       docker tag $images $ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$images
       docker push $ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$images
    done < images_names.txt

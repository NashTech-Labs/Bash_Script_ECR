# Bash_Script_ECR
#How to Use this Script
Now before using this Script you need to create or pass these values in the your environments
1. $REGION - Name of the region where your ECR is Present
2. $Account - Aws Account
3. $REGISTRY_ENDPOINT - the registry from where you want to pull images
4. $username - the username of the registry from where you are pulling the images
5. $Password - the password to be used to authenticate for pulling images

Now this Script takes the values of images from the text file , so you need to keep the list of all the images there
and from there it will do the conditonal checks and push images incase they are required , also this scripts checks
if you are pushing it for the first time and if repository is not present on ECR it will create the repository and attach a
policy to it. AAlso it will enable KMS for encryption.



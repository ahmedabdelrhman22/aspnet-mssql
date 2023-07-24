# mongo-ecs

Demonstrate Mongo ECS Replica setup with terraform, it will setup 3 MongoDb nodes in ECS with EC2 launch type

## Init terraform

Run `terraform init`

## Plan terraform

Run `terraform plan`

## Apply terraform

Run `terraform apply --auto-approve`

## Destroy terraform

Run `terraform destroy --auto-approve`

# Setup SSH Proxy in Mac

## Install aws session manager plugin

Run the brew command:-
`brew tap dkanejs/aws-session-manager-plugin`
and
`brew install aws-session-manager-plugin`

Verify the session manager plugin:-
`session-manager-plugin`

## Configure SSH Proxy Command

Edit SSH config in `~/.ssh/config` (MAC) or window `C:\Users\username\.ssh\config` and add the following content:-

For Mac:-

```
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

Or Window:-

```
host i-* mi-*
    ProxyCommand C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p"
```

## SSH with the following command

`ssh -i /path/my-key-pair.pem username@instance-id`

## Or you can SSH with port forward

`ssh -i /path/my-key-pair.pem username@instance-id -L localport:targethost:destport`

**You can port forward multiple ports for testing your application**

# Connect Mongo from local using SSH Proxy

After configure SSH proxy, run command `make tunnel` to connect, and provide default password `mypassword` to open tunnel to EC2 instance

## Setting host file to use Seed list Connection String

In order to use Seed list connection string in SSH tunnel, you need configure primary node to map localhost. Edit host file `/private/etc/hosts`, add the following entry:-

```
127.0.0.1 mongo-ecs-primary.ecs.demo
```

## Connect Mongo Compass using Seed List Connection String

Use the following connection string to access Replica nodes:-

```
mongodb://root:mypassword@localhost:27017,localhost:27018/?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&ssl=false
```
# EKS

Demonstrate web application EKS setup with terraform.

## Init terraform

Run `terraform init`

## Plan terraform

Run `terraform plan`

## Apply terraform

Run `terraform apply --auto-approve`

# Destroy terraform

Run `terraform destroy --auto-approve`



# To install or update kubectl in eks

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl.sha256

sha256sum -c kubectl.sha256

openssl sha1 -sha256 kubectl

chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

kubectl version --short --client



# to run kubernetes files 
kubectl apply -f kubernetes/mysql-pv.yaml  -f kubernetes/mysql-pvc.yaml -f kubernetes/mysql-

configmap.yaml -f kubernetes/mysql-service.yaml -f kubernetes/mysql-deployment.yaml -f 

kubernetes/statefulset.yaml -f kubernetes/secrets.yaml  -f kubernetes/redis-deployment.yaml -f 

kubernetes/asp-net-service.yaml -f kubernetes/asp-net-deployment.yaml -f 

kubernetes/Ingress.yaml





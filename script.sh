#!/bin/bash
set -e
echo "Updating the operating system. Wait!"
sudo yum update -y >> /dev/null 2>&1
sudo yum upgrade -y >> /dev/null 2>&1
echo "Installing Docker. Wait!"
# sudo apt-get remove docker docker-engine docker.io containerd runc >> /dev/null 2>&1
# sudo apt-get update >> /dev/null 2>&1
# sudo apt-get install ca-certificates curl gnupg lsb-release >> /dev/null 2>&1
# sudo mkdir -p /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >> /dev/null 2>&1
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >> /dev/null 2>&1
# sudo apt-get update >> /dev/null 2>&1
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin >> /dev/null 2>&1
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Starting Docker. Wait!"
sudo systemctl start docker
echo "Adding user to docker group. Wait!"
sudo usermod -aG docker $USER >> /dev/null 2>&1
echo "Setting up docker to start at reboot. Wait!"
sudo systemctl enable docker.service >> /dev/null 2>&1
sudo systemctl enable containerd.service >> /dev/null 2>&1
echo "Installing common utilities. Wait!"
sudo yum install -y python3.9 python3-pip sudo dnsutils wget vim gettext iputils-ping mlocate git curl openssl zip unzip jq openjdk-8-jdk >> /dev/null 2>&1
sudo updatedb >> /dev/null 2>&1
echo "Installing ibmcloud utility. Wait!"
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh >> /dev/null 2>&1
ibmcloud plugin install container-service -r 'IBM Cloud' >> /dev/null 2>&1
echo "Installing Helm. Wait!"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 >> /dev/null 2>&1
chmod 700 get_helm.sh >> /dev/null 2>&1
bash ./get_helm.sh >> /dev/null 2>&1
rm get_helm.sh >> /dev/null 2>&1
echo "Installing OpenShift oc utility. Wait!"
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.10.0/openshift-client-linux.tar.gz >> /dev/null 2>&1
tar xvf openshift-client-linux.tar.gz >> /dev/null 2>&1
sudo mv oc /usr/local/bin/oc >> /dev/null 2>&1
rm * >> /dev/null 2>&1
echo "Installing Kubernetes kubectl. Wait!"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" >> /dev/null 2>&1
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl >> /dev/null 2>&1
echo "cleaning up. Wait!"
sudo yum clean all -y >> /dev/null 2>&1
echo "All done."
oc version --client
helm version --client
kubectl version --short --client=true
ibmcloud version -q
echo "Reboot your instance now: sudo shutdown -r now"

#!/bin/bash
set -e
echo "Updating the operating system. Please wait."
sudo yum update -y
sudo yum upgrade -y
echo "Installing Docker. Please wait."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Starting Docker. Please wait."
sudo systemctl start docker
echo "Adding user to the docker group. Please wait."
sudo usermod -aG docker $USER
echo "Setting up Docker to start at reboot. Please wait."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
echo "Installing common utilities. Please wait."
sudo yum install -y python3.9 python3-pip sudo bind-utils wget vim gettext iputils mlocate git curl openssl zip unzip jq java-1.8.0-openjdk
sudo updatedb
echo "Installing ibmcloud utility. Please wait."
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
ibmcloud plugin install container-service -r 'IBM Cloud'
echo "Installing Helm. Please wait."
curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
echo "Installing OpenShift oc utility. Please wait."
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.10.0/openshift-client-linux.tar.gz
tar xvf openshift-client-linux.tar.gz oc
sudo mv oc /usr/local/bin/oc
rm openshift-client-linux.tar.gz
echo "Installing Kubernetes kubectl. Please wait."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
echo "Cleaning up. Please wait."
sudo yum clean all -y
echo "Installation completed successfully."
echo "Reboot your instance now: sudo shutdown -r now"
oc version --client
helm version --client
kubectl version --short --client=true
ibmcloud version -q

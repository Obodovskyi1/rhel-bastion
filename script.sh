#!/bin/bash
set -e
echo "Updating the operating system. Please wait."
sudo yum update -y > /dev/null 2>&1
sudo yum upgrade -y > /dev/null 2>&1
echo "Installing Docker. Please wait."
sudo yum install -y yum-utils > /dev/null 2>&1
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo > /dev/null 2>&1
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
echo "Starting Docker. Please wait."
sudo systemctl start docker
echo "Adding user to the docker group. Please wait."
sudo usermod -aG docker $USER > /dev/null 2>&1
echo "Setting up Docker to start at reboot. Please wait."
sudo systemctl enable docker.service > /dev/null 2>&1
sudo systemctl enable containerd.service > /dev/null 2>&1
echo "Installing common utilities. Please wait."
sudo yum install -y python3.9 python3-pip sudo bind-utils wget vim gettext iputils mlocate git curl openssl zip unzip jq java-1.8.0-openjdk > /dev/null 2>&1
sudo updatedb > /dev/null 2>&1
echo "Installing ibmcloud utility. Please wait."
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh > /dev/null 2>&1
ibmcloud plugin install container-service -r 'IBM Cloud' > /dev/null 2>&1
echo "Installing Helm. Please wait."
curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash > /dev/null 2>&1
echo "Installing OpenShift oc utility. Please wait."
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.10.0/openshift-client-linux.tar.gz > /dev/null 2>&1
tar xvf openshift-client-linux.tar.gz oc > /dev/null 2>&1
sudo mv oc /usr/local/bin/oc > /dev/null 2>&1
rm openshift-client-linux.tar.gz > /dev/null 2>&1
echo "Installing Kubernetes kubectl. Please wait."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /dev/null 2>&1
chmod +x kubectl > /dev/null 2>&1
sudo mv kubectl /usr/local/bin/kubectl > /dev/null 2>&1
echo "Cleaning up. Please wait."
sudo yum clean all -y > /dev/null 2>&1
echo "Installation completed successfully."
echo "Reboot your instance now: sudo shutdown -r now"
oc version --client
helm version --client
kubectl version --short --client=true
ibmcloud version -q

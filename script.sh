#!/bin/bash

set -e  # Exit on error

echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing basic dependencies..."
sudo apt install -y curl wget unzip gnupg software-properties-common ca-certificates lsb-release

# -----------------------------
# ☕ Install Java (OpenJDK 17)
# -----------------------------
echo "☕ Installing Java..."
sudo apt install -y openjdk-17-jdk

java -version

# -----------------------------
# 🟢 Install Node.js (LTS)
# -----------------------------
echo "🟢 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

node -v
npm -v

# -----------------------------
# ☸️ Install kubectl
# -----------------------------
echo "☸️ Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

kubectl version --client

# -----------------------------
# 🔐 Install Trivy
# -----------------------------
echo "🔐 Installing Trivy..."
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
  gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
  sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update
sudo apt install -y trivy

trivy --version

# -----------------------------
# ☁️ Install AWS CLI v2
# -----------------------------
echo "☁️ Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws --version

# -----------------------------
# 🎉 Done
# -----------------------------
echo "✅ All tools installed successfully!"

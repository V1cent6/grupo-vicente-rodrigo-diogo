#!/bin/bash

# --- EXECUÇÃO SEGURA ---

echo "--- 1. Decrypting secrets from Ansible Vault ---"

# Pede a Master Password do Vault
read -s -p "Enter Ansible Vault Password: " VAULT_PASS
echo 

# Desencripta e lê os valores (usando 'view' e 'grep/awk' para não salvar em disco)
VM_USER=$(ansible-vault view secrets.yml --vault-password-file <(echo $VAULT_PASS) | grep admin_username | awk '{print $2}')
VM_PASS=$(ansible-vault view secrets.yml --vault-password-file <(echo $VAULT_PASS) | grep admin_password | awk '{print $2}')

# Verifica se os segredos foram lidos (opcional, mas bom)
if [ -z "$VM_PASS" ]; then
    echo "ERROR: Failed to decrypt secrets. Check your Vault password or secrets.yml file."
    exit 1
fi

echo "--- 2. Running Terraform (Injecting secrets via TF_VAR) ---"

# Injeta os segredos como variáveis de ambiente para o Terraform
# O Terraform lê automaticamente as variáveis que começam com TF_VAR_
TF_VAR_admin_username=$VM_USER TF_VAR_admin_password=$VM_PASS terraform apply -auto-approve

# Captura o IP Público da VM criada
PUBLIC_IP=$(terraform output -raw public_ip_address)
echo "VM Public IP: $PUBLIC_IP"

# --- 3. Running Ansible ---

echo "--- 3. Running Ansible Playbook ---"

cd ansible

# 1. Atualiza o IP no inventory.ini (substitui o placeholder)
sed -i.bak "s/\[SEU_IP_PUBLICO_REAL\]/$PUBLIC_IP/" inventory.ini

# 2. Executa o Ansible, pedindo novamente a Master Password
# O Ansible Playbook usará as vars do secrets.yml que incluímos no playbook.yml
ansible-playbook -i inventory.ini playbook.yml --vault-password-file <(echo $VAULT_PASS)

# 3. Limpeza: Restaura o inventory.ini para o placeholder
mv inventory.ini.bak inventory.ini

echo "--- Deployment Complete ---"
Note: this repo stores scripts for students to play with (several errors can be found in the scripts, i.e., credentials)

*Final assignment*

team:  max group of 3 people

Delivery date: 9 January 2026

Exercise 1
1. Fork this repository
2. in the new repositry, make sure that:
   a) a proper index.html file is served by NGINX
   b) make sure passwords are not shown in the Terraform and Ansbile files (they are not visible in the repository)
      to run this project first you need to put the variables and need to be the same as those in ansible:
         export TF_VAR_admin_username="nome_de_utilizador_aqui"
         export TF_VAR_admin_password="palavra_passe_secreta_aqui"
         terraform plan 
         terraform apply 


  

Exercise 2:
1. Create a new repository
2. Create a Linux machine in Azure that will play a DHCP role (test the configurarion)
3. use Terraform and Ansible (zero manual configuration)
4. make sure that no passwords are stored in scripts
5. delivery the code in a github repo

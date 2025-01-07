# Construire l'image Docker et démarrer le conteneur
build:
	docker-compose up --build

# Initialiser Terraform
init:
	terraform init

# Générer un plan Terraform
plan:
	terraform plan -lock=false

# Appliquer le plan Terraform
apply:
	terraform apply -lock=false

# Déployer index.html dans le bucket S3
deploy-index:
	aws s3 cp website/index.html s3://peritus-bucket/index.html

# Déployer error.html dans le bucket S3
deploy-error:
	aws s3 cp website/error.html s3://peritus-bucket/error.html

# Détruire l’infrastructure Terraform
destroy:
	terraform destroy -lock=false

services:
    terraform:
      build: .
      image: pritus-tech:latest
      container_name: terraform-container
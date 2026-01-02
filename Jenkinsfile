pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Repo checked out by Jenkins SCM"
      }
    }

    stage('Verify Tools') {
      steps {
        sh 'terraform -version'
        sh 'aws --version'
        sh 'aws sts get-caller-identity --region $AWS_REGION'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('env/dev') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('env/dev') {
          sh 'terraform plan -var="key_name=terraform"'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('env/dev') {
          sh 'terraform apply -auto-approve -var="key_name=terraform"'
        }
      }
    }
  }
}

pipeline {
  agent any

  options {
    timestamps()
    timeout(time: 15, unit: 'MINUTES')
  }

  environment {
    TF_IN_AUTOMATION = "true"
    TF_INPUT         = "false"
    TF_DIR           = "env/dev"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
        sh '''
          set -e
          echo "Workspace:"
          pwd
          echo "Listing repo files:"
          ls -la
        '''
      }
    }

    stage('Verify Terraform Code Exists') {
      steps {
        sh '''
          set -e
          test -d "${TF_DIR}" || (echo "ERROR: ${TF_DIR} not found" && exit 1)

          count=$(find "${TF_DIR}" -maxdepth 1 -type f -name "*.tf" | wc -l)
          if [ "$count" -eq 0 ]; then
            echo "ERROR: No .tf files in ${TF_DIR}"
            ls -la "${TF_DIR}"
            exit 1
          fi

          echo "Found ${count} terraform files"
        '''
      }
    }

    stage('Terraform Init') {
      steps {
        dir("${TF_DIR}") {
          sh '''
            set -e
            terraform init -no-color
          '''
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        dir("${TF_DIR}") {
          sh '''
            set -e
            terraform validate -no-color
          '''
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("${TF_DIR}") {
          sh '''
            set -e
            terraform plan \
              -no-color \
              -lock-timeout=60s \
              -var="key_name=terraform"
          '''
        }
      }
    }
  }

  post {
    always {
      echo "Pipeline finished"
    }
  }
}


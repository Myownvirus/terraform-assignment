pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
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
          echo "Repo files:"
          ls -la
          echo "Terraform files (first 100):"
          find . -maxdepth 4 -type f -name "*.tf" | sort | head -100
        '''
      }
    }

    stage('Verify Terraform Code Exists') {
      steps {
        sh '''
          set -e
          test -d "${TF_DIR}" || (echo "ERROR: ${TF_DIR} folder not found" && exit 1)
          count=$(find "${TF_DIR}" -maxdepth 1 -type f -name "*.tf" | wc -l)
          if [ "$count" -eq 0 ]; then
            echo "ERROR: No .tf files found in ${TF_DIR}"
            echo "Contents of ${TF_DIR}:"
            ls -la "${TF_DIR}" || true
            exit 1
          fi
          echo "OK: Found ${count} terraform files in ${TF_DIR}"
        '''
      }
    }

    stage('Terraform Fmt') {
      steps {
        dir("${TF_DIR}") {
          sh '''
            set +e
            terraform fmt -recursive -no-color
            exit 0
          '''
        }
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
            terraform plan -no-color -lock-timeout=60s -var="key_name=terraform"
          '''
        }
      }
    }
  }

  post {
    always {
      sh 'echo "Build finished with status: ${BUILD_STATUS:-UNKNOWN}"'
    }
  }
}


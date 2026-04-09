pipeline {
  agent { label 'laravel-agent' }
  options { timestamps() }
  environment {
    DEPLOY_HOST = '178.128.93.188'
    DEPLOY_USER = 'PANG-Lythong'
    DEPLOY_PATH = '/home/lythong/i42026-website'
    EMAIL_TO = 'akainusan555@gmail.com'
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Install PHP deps') {
      steps {
        sh 'composer install --no-interaction --prefer-dist'
      }
    }
    stage('App key') {
      steps {
        sh 'php artisan key:generate --force'
      }
    }
    stage('Build assets') {
      steps {
        sh 'npm install'
        sh 'npm run build'
      }
    }
    stage('Deploy') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'deploy-key', keyFileVariable: 'DEPLOY_KEY', usernameVariable: 'DEPLOY_USER_CRED')]) {
          sh '''
            printf "[web]\n%s\n" "$DEPLOY_HOST" > deploy/inventory.ini
            ansible-playbook -i deploy/inventory.ini deploy/site.yml \
              --private-key "$DEPLOY_KEY" \
              -u "$DEPLOY_USER_CRED" \
              --extra-vars "deploy_path=$DEPLOY_PATH"
          '''
        }
      }
    }
  }
  post {
    failure {
      script {
        try {
          emailext(to: env.EMAIL_TO, subject: "Jenkins build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "${env.BUILD_URL}")
        } catch (err) {
          echo "Email notification skipped: ${err}"
        }
        try {
          withCredentials([
            string(credentialsId: 'telegram-bot-token', variable: 'TG_TOKEN'),
            string(credentialsId: 'telegram-chat-id', variable: 'TG_CHAT')
          ]) {
            sh "curl -s -X POST https://api.telegram.org/bot${TG_TOKEN}/sendMessage -d chat_id=${TG_CHAT} -d text='Build failed: ${JOB_NAME} #${BUILD_NUMBER} ${BUILD_URL}' >/dev/null"
          }
        } catch (err) {
          echo "Telegram notification skipped: ${err}"
        }
      }
    }
  }
}

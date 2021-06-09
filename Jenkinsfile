pipeline {
  agent {label "agentfarm"}
  stages {
    stage ('Delete the workspace') {
      steps{
        cleanWs()
      }
    }
    stage ('Installing Chef Workstation') {
      steps {
        script {
          def exists = fileExists '/usr/bin/chef-client'
          if(exists == true) {
            echo 'Skipping Chef Workstation install - already installed'
          } else {
            sh 'sudo apt-get install -y wget tree unzip'
            sh 'wget https://packages.chef.io/files/stable/chef-workstation/20.10.168/ubuntu/20.04/chef-workstation_20.10.168-1_amd64.deb'
            sh 'sudo dpkg -i chef-workstation_20.10.168-1_amd64.deb'
            sh 'sudo chef env --chef-license accept'
          }
        }
      }
    }
    stage ('Download Apache Cookbook') {
      steps {
        git credentialsId: 'git-repo-creds', url: 'git@github.com:varunsharma5/apache.git'
      }
    }
/*
    stage ('Install Kitchen Docker gem') {
      steps {
        sh 'sudo apt-get install -y make gcc'
        sh 'sudo chef gem install kitchen-docker'
      }
    }
*/    
    stage ('Run Kitchen Destroy') {
      steps {
        sh 'sudo kitchen destroy'
      }
    }
    stage ('Run Kitchen Create') {
      steps {
        sh 'sudo kitchen create'
      }
    }
    stage ('Run Kitchen Converge') {
      steps {
        sh 'sudo kitchen converge'
      }
    }
    stage ('Run Kitchen verify') {
      steps {
        sh 'sudo kitchen verify'
      }
    }
    stage ('Send Slack notification') {
      steps {
        slackSend color: 'warning', message: "Mr Varun: Please approve ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.JOB_URL} | Open>)"
      }
    }
    stage ('Request Input') {
      steps {
        input 'Please approve the build'
      }
    }
    stage ('Upload to Chef Infra Server, Converge Nodes') {
      steps {
      withCredentials([zip(credentialsId: 'chef-starter.zip', variable: 'CHEFREPO')]) {
          sh 'chef install $WORKSPACE/Policyfile.rb -c $CHEFREPO/chef-repo/.chef/config.rb'
          sh 'chef push prod $WORKSPACE/Policyfile.lock.json -c $CHEFREPO/chef-repo/.chef/config.rb'
          withCredentials([sshUserPrivateKey(credentialsId: 'agent-key', keyFileVariable: 'agentKey')]) {
            sh "knife ssh 'policy_name:apache' -x ubuntu -i $agentKey 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/config.rb"
          }
        }
      }
    }
  }
  post {
    success {
      slackSend color: 'warning', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} was successful ! :)"
    }
    failure {
      slackSend color: 'warning', message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} failed ! :("
    }
  }
}

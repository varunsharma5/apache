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
    stage ('Install Kitchen Docker gem') {
      steps {
        sh 'sudo apt-get install -y make gcc'
        sh 'sudo chef gem install kitchen-docker'
      }
    }
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
    stage ('Run Kitchen Destroy') {
      steps {
        sh 'sudo kitchen destroy'
      }
    }
  }
}

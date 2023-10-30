pipeline {
  environment {
    ARGO_SERVER = '127.0.0.1:30002'
  }

  agent {
    kubernetes {
      yamlFile 'build-agent.yaml'
      defaultContainer 'maven'
      idleMinutes 1
    }
  }
  stages {
    stage('Build') {
      parallel {
        stage('Compile') {
          steps {
            container('maven') {
              sh 'mvn compile'
            }
          }
        }
      }
    }
    stage('Test') {
      parallel {
        stage('Unit Tests') {
          steps {
            container('maven') {
              sh 'mvn test'
            }
          }
        }
        stage('SCA') {
          steps {
            container('maven') {
              echo "test"
              //catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
              //  sh 'mvn org.owasp:dependency-check-maven:check'
              //}
            }
          }
          post {
            always {
              archiveArtifacts allowEmptyArchive: true, artifacts: 'target/dependency-check-report.html', fingerprint: true, onlyIfSuccessful: true
            }
          }
        }
        stage('License Checker') {
          steps {
            container('licensefinder') {
              echo "test"
              // sh 'ls -al'
              // sh '''#!/bin/bash --login
              //       /bin/bash --login
              //       rvm use default
              //      gem install license_finder
              //      license_finder
              //      '''
            }
          }
        }
      }
    }
    stage('SAST') {
      steps {
        container('slscan') {
          echo "not scanning" 
          //sh 'scan --type java,depscan --build --no-error'
        }
      }
      post {
        success {	
          archiveArtifacts allowEmptyArchive: true, artifacts: 'reports/*', fingerprint: true, onlyIfSuccessful: true
        }
      }
    }
    stage('Package') {
      parallel {
        stage('Create Jarfile') {
          steps {
            container('maven') {
              sh 'mvn package -DskipTests'
            }
          }
        }
        stage('Docker BnP') {
          steps {
            container('kaniko') {
              echo "not pushing"
              // sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --skip-tls-verify --cache=true --destination=docker.io/patreber/dso-demo:latest'
            }
          }
        }
      }
    }
    stage('Image Analysis') {
      parallel {
        stage('Image Linting') {
          steps {
            container('docker-tools') {
              echo "not linting"
              // sh 'dockle docker.io/patreber/dso-demo:latest'
            }
          }
        }
        stage('Image Scan') {
          steps {
            container('docker-tools') {
              echo "not scanning"
              // figure out later
              // sh 'trivy image --exit-code 0 patreber/dso-demo'
            }
          }
        }
      }
    }

    stage('Deploy to Dev') {
      environment {  		
        AUTH_TOKEN = credentials('argocd-jenkins-deployer-token')
      }
      steps {
        container('dind') {
          sh 'docker ps'
          sh 'docker run -t schoolofdevops/argocd-cli argocd app sync dso-demo --inescure --server $ARGO_SERVER --auth-token $AUTH_TOKEN'
          sh 'docker run -t schoolofdevops/argocd-cli argocd app wait dso-demo --health --timeout 300 --inescure --server $ARGO_SERVER --auth-token $AUTH_TOKEN'
        }
      }
    }
  }
}    	

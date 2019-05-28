pipeline {
    agent any
    stages {
        stage('Check-In') {
            steps {
                sh 'echo Started pipeline' 
            }
        }

        stage('Run tests') {	
            parallel {	
                stage('Run unittest') {	
                    steps {	
                        dir('kubernetes-101') {	
                            sh 'echo unittest'	
                        }	
                    }	
                }	
                stage('static analysis') {	
                    agent {	
                        docker { image 'hoto/flake8' }	
                    }	
                    steps {	
                        dir('DevopsKata') {	
                            sh 'echo static analysis'	
                        }	
                    }	
                }	
            }	
        }

        stage('Build Stable Images') {
            parallel {
                stage('Build App Image') {
                    steps {
                        sh "docker build -t roseth/seakube:${GIT_COMMIT.take(6)} -f kubernetes-101/Dockerfile ."
                        sh "docker tag roseth/seakube:${GIT_COMMIT.take(6)} roseth/seakube:stable"
                    }
                }
            }
        }

         stage('Push Stable Images') {
            parallel {
                stage('Push App Image') {
                    steps {
                        withCredentials([
                            string(credentialsId: 'docker-password', variable: 'DOCKER_PASS'),
                        ]) {
                            sh "docker login -u=roseth -p ${DOCKER_PASS}"
                            sh "docker push roseth/seakube:${GIT_COMMIT.take(6)}"
                        }
                    }
                }
            }
        }

        stage('Deploy Dev Server'){
            agent {
                docker {
                    image 'roffe/kubectl'
                    args '-u root'
                }
            }
            steps {
                dir('kubernetes-101/k8s') {
                    withCredentials([
                        string(credentialsId: 'certificate-authority-data', variable: 'CERTIFICATE_AUTHORITY_DATA'),
                        string(credentialsId: 'client-key-data', variable: 'CLIENT_KEY_DATA'),
                        string(credentialsId: 'client-certificate-data', variable: 'CLIENT_CERTIFICATE_DATA')
                    ]) {

                        sh 'echo $CERTIFICATE_AUTHORITY_DATA > certificate/pronto_world_certificate_authority_data'
                        sh 'echo $CLIENT_KEY_DATA > certificate/pronto_world_client_key_data'
                        sh 'echo $CLIENT_CERTIFICATE_DATA > certificate/pronto_world_client_certificate_data'

                        sh './set-context.sh'

                        dir('deployment') {
                            sh 'kubectl apply -f postgres.yml'
                            sh "cat app.yml | sed 's/{{COMMIT}}/${GIT_COMMIT.take(6)}/g' | kubectl apply -f -"
                        }
                    }
                }
            }
        }

        stage('Run Acceptance tests') {	
            parallel {	
                stage('Run Serverspec Tests') {
                    agent {
                        docker {
                            image 'ruby:2.3.6'
                        }
                    }
                    steps {	
                        dir('kubernetes-101/serverspec') {
                            sh 'bundle'
                            withCredentials([
                                sshUserPrivateKey(credentialsId: 'credential-private-key', keyFileVariable: 'SSH_PRIVATE_KEY')
                            ]) {
                                sh 'rake spec:18.191.198.18'
                                sh 'rake spec:18.218.237.243'
                                sh 'rake spec:18.191.104.43'
                            }
                        }	
                    }	
                }	
                stage('Run Acceptance Tests') {	
                    agent {
                        docker {
                            image 'cypress/base:ubuntu16'
                            args '-u root'
                        }
                    }	
                    steps {	
                        dir('kubernetes-101/cypress') {	
                            sh 'npm install'
                            sh './node_modules/.bin/cypress install'
                            sh './node_modules/.bin/cypress run'
                        }	
                    }	
                }	
            }	
        }
    }
}
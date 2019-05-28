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
                dir('k8s') {
                    withCredentials([
                        string(credentialsId: 'certificate-authority-data', variable: 'CERTIFICATE_AUTHORITY_DATA'),
                        string(credentialsId: 'client-key-data', variable: 'CLIENT_KEY_DATA'),
                        string(credentialsId: 'client-certificate-data', variable: 'CLIENT_CERTIFICATE_DATA')
                    ]) {

                        sh 'echo $CERTIFICATE_AUTHORITY_DATA > certificate/pronto_world_certificate_authority_data'
                        sh 'echo $CLIENT_KEY_DATA > certificate/pronto_world_client_key_data'
                        sh 'echo $CLIENT_CERTIFICATE_DATA > certificate/pronto_world_client_certificate_data'

                        sh './set-context.sh'

                        dir('deployments') {
                            sh 'kubectl apply -f db.yml'
                            sh "cat app.yml | sed 's/{{COMMIT}}/${GIT_COMMIT.take(6)}/g' | kubectl apply -f -"
                        }
                    }
                }
            }
        }
    }
}
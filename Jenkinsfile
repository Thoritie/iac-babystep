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
                        sh "docker build -t roseth/seakube:${GIT_COMMIT.take(6)} -f Dockerfile ."
                        sh "docker tag roseth/seakube:${GIT_COMMIT.take(6)} roseth/seakube:stable"
                    }
                }
            }
        }


        // stage('Deploy Dev Server Kubernetes') {
        //     stages {
        //         stage('Pull Image') {
        //             agent {
        //                 docker {
        //                     image 'stephdw/jenkins-ansible'
        //                 }
        //             }
        //             steps {
        //                 dir('ansible') {
        //                     withCredentials([
        //                         sshUserPrivateKey(credentialsId: 'rocket-ssh-credential', keyFileVariable: 'SSH_PRIVATE_KEY')
        //                     ]) {
        //                         sh "ansible-playbook -i development playbooks/pull_image_kubernetes_node.yml --private-key=${SSH_PRIVATE_KEY} --extra-vars 'commit=${GIT_COMMIT.take(6)}'"
        //                     }
        //                 }
        //             }
        //         }
        //         stage('Deploy Dev Server'){
        //             agent {
        //                 docker {
        //                     image 'roffe/kubectl'
        //                     args '-u root'
        //                 }
        //             }
        //             steps {
        //                 dir('k8s/dev') {
        //                     withCredentials([
        //                         string(credentialsId: 'pronto-world-certificate-authority-data', variable: 'PRONTO_WORLD_CERTIFICATE_AUTHORITY_DATA'),
        //                         string(credentialsId: 'pronto-world-client-key-data', variable: 'PRONTO_WORLD_CLIENT_KEY_DATA'),
        //                         string(credentialsId: 'pronto-world-client-certificate-data', variable: 'PRONTO_WORLD_CLIENT_CERTIFICATE_DATA')
        //                     ]) {

        //                         sh 'echo $PRONTO_WORLD_CERTIFICATE_AUTHORITY_DATA > certificate/pronto_world_certificate_authority_data'
        //                         sh 'echo $PRONTO_WORLD_CLIENT_KEY_DATA > certificate/pronto_world_client_key_data'
        //                         sh 'echo $PRONTO_WORLD_CLIENT_CERTIFICATE_DATA > certificate/pronto_world_client_certificate_data'

        //                         sh './set-context.sh'

        //                         dir('deployments') {
        //                             sh "cat app.yml | sed 's/{{COMMIT}}/${GIT_COMMIT.take(6)}/g' | kubectl apply -f -"
        //                             sh "cat dynalite.yml | sed 's/{{COMMIT}}/${GIT_COMMIT.take(6)}/g' | kubectl apply -f -"
        //                             sh 'kubectl apply -f db.yml'
        //                             sh 'kubectl apply -f elasticsearch.yml'
        //                         }
        //                     }
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}
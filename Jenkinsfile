pipeline {
    agent {
    	docker { image 'node:16'       //use node.js 16 as base image
	         args '-u root:root'  // run as root so apt-get works below
		 } 
    	}

    stages {
        stage('Install node dependencies') {
            steps {
                echo 'Installing..'
                sh 'npm install --save'      //installing required dependencies
                
            }
        }
     
        stage('Test') {
            steps {
                echo 'Testing..'
                
            }
        }
	stage('Snyk Scan') {
            steps {
                echo 'Snyk Security Scan..'
                sh 'npm install -g snyk'  //install synk CLI
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]){ sh 'snyk auth $SNYK_TOKEN' } //authenticate

                script {
                        def result = sh(script: 'snyk test --severity-threshold=high' , returnStatus: true)

                        if (result != 0) {
                                error 'pipeline failed'
                        } else {         //stops pipeline if critical issues
                                echo 'No high/critical vulnerabilities detected'
                        }
                }
            }
        }
	
	
	
    stage('Build Docker Image') {
            steps {
			  script{
                echo 'Building Docker image of app....'
                docker.withServer('tcp://docker:2376', 'dind-certs'){
					docker.build("bhagya21878288/nodeapp21878288_assignment2:${BUILD_NUMBER}") 
					
				}
                	
			  }
                	
            }
        }
	stage('Push image to docker') {
            steps {
				script {
                	echo 'pushing image....'
                	docker.withServer('tcp://docker:2376', 'dind-certs'){
                        docker.withRegistry('https://index.docker.io/v1/','dockerhub-cred'){
							docker.image("bhagya21878288/nodeapp21878288_assignment2:${BUILD_NUMBER}").push()
		}  

            }
        }
			}
        
    }
	stage('Archive artifacts'){
		steps{
		     echo 'Archiving important files'
		     archiveArtifacts artifacts: 'package.json, package-lock.json, app.js, Dockerfile', fingerprint: true, followSymlinks: false
		}
	}	
}
}

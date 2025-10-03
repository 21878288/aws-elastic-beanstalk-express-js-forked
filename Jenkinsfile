pipeline {
    agent {
    	docker { image 'node:16'       //use node.js 16 as base image
	         args '-u root:root -v /certs/client:/certs/client:ro'  // run as root 
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
	
	
	stage('Build Docker Image & push to registry') {
		steps{
			echo 'Building docker image of app'
			script{
				docker.withServer('tcp://docker:2376', 'dind-certs'){
					def imagename = 'bhagya21878288/nodeapp21878288_assignment2:${env.BUILD_NUMBER}'
					echo 'Building image: ${imagename}'
					def img = docker.build(imagename)
					docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-cred'){
						echo 'pushing image'
						img.push()
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

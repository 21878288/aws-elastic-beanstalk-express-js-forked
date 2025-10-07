pipeline {
    agent none{

    stages {
        stage('Install node dependencies') {
	    agent { docker { image 'node:16' } }  //use node.js 16 as base image
            steps {
                echo 'Installing..'
                sh 'npm install --save'      //installing required dependencies
                
            }
        }
     
        stage('Test') {
	    agent { docker{ image 'node:16' } }
            steps {
                echo 'Testing..'
		sh 'npm test  || echo "No tests specified"'
                
            }
        }
	stage('Snyk Scan') {
	    agent { docker{ image 'node:16' } }
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
		agent any
		steps{
			echo "Building docker image of app"
			script{
				docker.withServer('tcp://docker:2376', 'dind-certs'){
					def imagename = "bhagya21878288/nodeapp21878288_assignment2:${env.BUILD_NUMBER}"
					def img = docker.build(imagename)
					echo "Building image: ${imagename}"
					docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-cred'){
						echo "pushing image to registry-docker hub"
						img.push()
					}
				}
			}
		}
	}
	
	stage('Archive artifacts'){
		agent { docker{ image 'node:16' } }
		steps{
		     echo 'Archiving important files'
		     archiveArtifacts artifacts: 'package.json, package-lock.json, app.js, Dockerfile', fingerprint: true, followSymlinks: false
		}
	}	
}
}
}

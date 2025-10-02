pipeline {
    agent {
    	docker { image 'node:16' } //use node.js 16 as base image
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
                sh 'npm test'  //run tests
            }
        }
		stage('Snyk Scan') {
            steps {
                echo 'Snyk Security Scan..'
                sh 'npm install -g snyk'  //install synk CLI
                sh 'snyk auth 49e25c41-bfc3-4b1a-b16f-dc0791a443ac' //authenticate

                script {
                        def result = sh(script: 'synk test --severity-threshold=high' , returnStatus: true)

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
                echo 'Building....'
                script {
                	docker.build("bhagya21878288/nodeapp21878288_assignment2"+$BUILD_NUMBER") }  //build docker image of the app
                	
            }
        }
	stage('Push image to docker') {
            steps {
                echo 'pushing image....'
                script {
                        docker.withRegistry('https://index.docker.io/v1/','dockerhub-cred'){
						docker.image("bhagya21878288/nodeapp21878288_assignment2:$BUILD_NUMBER" }.push()  //push docker image to repo

            }
        }

        
    }
}

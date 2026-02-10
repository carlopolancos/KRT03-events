
pipeline {
    agent any

    stages {
        stage('Build API') {
            steps {
                // Build the Spring Boot API project using Maven
                dir("${WORKSPACE}/events-api") {
                    bat 'mvn clean package' // For Windows
                    // Or use sh 'mvn clean package' for Linux/macOS
                }
            }
        }

        stage('Start API') {
            steps {
                // Start the API in the background
                dir("${WORKSPACE}/events-api/target") {
                    bat 'start java -jar events-api-0.0.1-SNAPSHOT.jar' // For Windows
                    // Or use sh 'nohup java -jar events-api-0.0.1-SNAPSHOT.jar &' for Linux/macOS
                }
                // Wait for API to start (adjust the sleep duration as needed)
                sleep 30
            }
        }

        stage('Run Tests') {
            steps {
                // Run Karate tests against the API
                dir("${WORKSPACE}/events-api-tests0") {
                    bat 'mvn test'
                    // Or use sh 'mvn test' for Linux/macOS
                }
            }
        }
    }

    post {
        always {
            // Stop the API process
            bat 'taskkill /f /im java.exe /fi "WINDOWTITLE eq events-api-0.0.1-SNAPSHOT.jar"' // For Windows
            // Or use sh 'pkill -f "events-api-0.0.1-SNAPSHOT.jar"' for Linux/macOS
        }
        success {
            dir("${WORKSPACE}/events-api-tests0") {
                junit 'target/karate-reports/*.xml'
//                cucumber 'target/karate-reports/*.json'

                // Archive Gatling Reports
                // We archive the whole gatling directory to preserve CSS/JS for the HTML report
                archiveArtifacts artifacts: 'target/gatling/**', allowEmptyArchive: true

                // Optional: If you have the HTML Publisher plugin, you can expose the link in Jenkins UI
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'target/gatling',
                    reportFiles: '**/index.html',
                    reportName: 'Gatling Performance Report'
                ])
            }
        }
    }
}

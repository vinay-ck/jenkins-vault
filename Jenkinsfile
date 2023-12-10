node {
    // define the secrets and the env variables
    // engine version can be defined on secret, job, folder or global.
    // the default is engine version 2 unless otherwise specified globally.
    
    def secrets = [
        [path: 'aws/sts/jenkins_ecr_admin', engineVersion: 1, secretValues: 
            [
                [envVar: 'AWS_ACCESS_KEY_ID', vaultKey: 'access_key'],
	            [envVar: 'AWS_SECRET_ACCESS_KEY', vaultKey: 'secret_key'],
	            [envVar: 'AWS_SESSION_TOKEN', vaultKey: 'security_token']
            ]
        ]
    ]

    // optional configuration, if you do not provide this the next higher configuration
    // (e.g. folder or global) will be used
    def configuration = [vaultUrl: 'https://competency.ck-poc.online:8200',
                         vaultCredentialId: 'vault-aws',
                         engineVersion: 1]


    stage('SCM') {
        git branch: 'main', credentialsId: 'jenkins-git', url: 'https://github.com/vinay-ck/jenkins-vault.git'
    }

    stage('Build Docker') {
        sh 'git rev-parse HEAD > commit'
        def commit = readFile('commit').trim()
        sh "docker build -t mynginx:${commit} ."
        sh "docker tag mynginx:${commit} 750224197114.dkr.ecr.ap-southeast-1.amazonaws.com/mynginx:${commit}"
    }

    stage('Push Image') {
        // inside this block your credentials will be available as env variables
        withVault([configuration: configuration, vaultSecrets: secrets]) {
        sh 'git rev-parse HEAD > commit'
        def commit = readFile('commit').trim()            
        sh 'aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 750224197114.dkr.ecr.ap-southeast-1.amazonaws.com'
        sh "docker push 750224197114.dkr.ecr.ap-southeast-1.amazonaws.com/mynginx:${commit}"
        }
    }

}

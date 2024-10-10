# github-runners

This repo is to explore the different ways of creating Github runners and documenting it. 

## Running locally on EC2 instance
This method is pretty straight forward. Provision an EC2 instance of your choice. You can get all the commands from the Github console.
- Navigate to `Github repo > Settings >'Actions' on left plane > runners > New self-hosted runner`
- Select the Runner image as `Linux`. Select Architecture as `x64` if you have provisioned the EC2 instance with Amazon Linux default ami. AMI name will also have this information if you have already provisioned EC2.
  
![image](https://github.com/user-attachments/assets/06d9698b-b93d-4425-8503-6ca21e7ab0a3)
- Copy and run the commands given in the console.
Install the below packages on your EC2 before running the given commands.
```
sudo yum install perl -y
sudo yum install libicu -y
```

Downloading the necessary files
```sh
# Create a folder
$ mkdir actions-runner && cd actions-runner

# Download the latest runner package
$ curl -o actions-runner-linux-x64-2.320.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz

# Optional: Validate the hash
$ echo "93ac1b7ce743ee85b5d386f5c1787385ef07b3d7c728ff66ce0d3813d5f46900  actions-runner-linux-x64-2.320.0.tar.gz" | shasum -a 256 -c

# Extract the installer
$ tar xzf ./actions-runner-linux-x64-2.320.0.tar.gz
```
Configure
```
# Create the runner and start the configuration experience
$ ./config.sh --url https://github.com/your-username/your-repo --token YOUR_TOKEN_HERE

# Last step, run it!
$ ./run.sh
```
Note: While running the config.sh commands, it will prompt for typing in few details such as 
- Runner group - If you don't have Runner group set already, just press enter key to add the runner to Default group
- name of the runner
- labels — one or more comma-separated labels. This will help to choose the correct runner when there are multiple runners configured. You will mention this label in your workflows.
- work folder - The work folder, often referred to as '_work' by default, is a directory within the runner's installation path that hosts all the job execution content. 



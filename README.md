College project for databases class at UNAL. Work in progress


Ensure you have the following prerequisites installed before starting:


## Virtual Environment Setup
	pip install virtualenv
	cd [path where you wish to create virtual env]
	python -m venv [name of virtual env] 
	
## Virtual Enviorment Activation
	For MacOS:
		source env/bin/activate
	For Windows:
		env/Scripts/activate.bat //In CMD
 		env/Scripts/Activate.ps1 //In Powershell

## Install Requirements
	pip install -r requirementsWindows.txt

## Download Chromedriver
https://googlechromelabs.github.io/chrome-for-testing/

## Ensure a MySQL server is running.
Configure environment variables in a .env file: 

	MYSQL_HOST="your_host" 
	MYSQL_USER="your_user" 
	MYSQL_PASSWORD="your_password" 
	MYSQL_DATABASE="your_database"
	SECRET_KEY="your_secret_key"

	CHROMEDRIVER_PATH = "\path\to\your\chromedriver\chromedriver.exe"


## Execute the project:
	uvicorn main:app --reload

Feel free to adapt and expand this template based on the specific details and features of your project.

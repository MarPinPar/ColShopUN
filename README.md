College project for databases class at UNAL. Work in progress


Ensure you have the following prerequisites installed before starting:


## Virtual Environment Setup

	python3.9 -m venv fastapi-env 
	source fastapi-env/bin/activate
	pip install -r requirements.txt


## Ensure a MySQL server is running.
Configure environment variables in a .env file: 

	MYSQL_HOST=your_host 
	MYSQL_USER=your_user 
	MYSQL_PASSWORD=your_password 
	MYSQL_DATABASE=your_database
	SECRET_KEY=your_secret_key


##Execute the project:
	uvicorn main:app --reload

Feel free to adapt and expand this template based on the specific details and features of your project.

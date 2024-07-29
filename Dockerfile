FROM public.ecr.aws/lambda/python:3.12

# Copy requirements.txt
COPY src/requirements.txt ${LAMBDA_TASK_ROOT}

# Install the specified packages
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy function code
COPY src/user_service.py ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "user_service.lambda_handler" ]
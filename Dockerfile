FROM python:3.11.3-slim

#don't generage .pyc files in container
ENV PYTHONDONTWRITEBYTECODE=1

# turn off buffering for better container logging
ENV PYTHONUNBUFFERED=1

# install pipenv
COPY Pipfile Pipfile.lock ./
RUN python -m pip install --upgrade pip
RUN pip install pipenv && pipenv install --dev --system --deploy

WORKDIR /var/www
COPY . ./app
RUN pipenv sync
EXPOSE 8080
CMD [ "uvicorn", "src.app:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8080" ]
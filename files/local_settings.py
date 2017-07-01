# enable private Git doc repositories
ALLOW_PRIVATE_REPOS = True

# configure name of the server
# PRODUCTION_DOMAIN = "myserver"

# configure email client
EMAIL_HOST = 'smtp.example.com'
EMAIL_HOST_USER = 'rtd@example.com'
EMAIL_HOST_PASSWORD = 'secret'
EMAIL_PORT = 465
EMAIL_USE_TLS = True
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_BACKEND = 'django_smtp_ssl.SSLEmailBackend'

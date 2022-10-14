from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='the-coffee-bar',
    version='0.2.0',
    description='The Coffee Bar - OpenTelemetry instrumented demo application',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/SumoLogic/the-coffee-bar',
    author='Mateusz "mat" Rumian',
    author_email='mrumian@sumologic.com',
    classifiers=[
        'Development Status :: 3 - Beta',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Build Tools',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.10',
    ],
    keywords='the-coffee-bar opentelemetry auto instrumentation setuptools development',

    packages=find_packages(),
    python_requires='>=3.8, <4',

    install_requires=['APScheduler==3.9.1',
                      'cron-descriptor==1.2.31',
                      'Flask==2.2.2',
                      'flask-cors==3.0.10',
                      'opentelemetry-distro==0.32b0',
                      'opentelemetry-exporter-jaeger==1.12.0rc2',
                      'opentelemetry-exporter-otlp-proto-http==1.12.0rc2',
                      'opentelemetry-exporter-zipkin==1.12.0rc2',
                      'opentelemetry-instrumentation==0.32b0',
                      'opentelemetry-sdk==1.12.0rc2',
                      'opentelemetry-propagator-aws-xray==1.0.1',
                      'opentelemetry-propagator-b3==1.12.0rc2',
                      'paste==3.5.2',
                      'psycopg2==2.9.4',
                      'pyjson==1.5.2',
                      'requests==2.28.1',
                      'statsd==3.3.0',
                      'tcconfig==0.28.0',
                      'waitress==2.1.2',
                      ],
    data_files=[],
    entry_points={
        'console_scripts': [
            'the-coffee-bar=src.bin.the_coffee_bar:main',
            'the-coffee-machine=src.bin.the_coffee_machine:main',
            'the-cashdesk=src.bin.the_cashdesk:main',
            'the-coffee-lover=src.bin.the_coffee_lover:main',
        ],
    },
    project_urls={
        'Bug Reports': 'https://github.com/Sumologic/the-coffee-bar/issues',
        'Source': 'https://github.com/Sumologic/the-coffee-bar/applications/python-the-coffee-bar-apps',
    },
)

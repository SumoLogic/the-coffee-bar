from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='the-coffee-bar',
    version='0.0.1',
    description='The Coffee Bar - python auto instrumented application',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/Sanyaku/tracing-demo-java',
    author='Mateusz "mat" Rumian',
    author_email='mrumian@sumologic.com',
    classifiers=[  # Optional
        'Development Status :: 3 - Alpha',

        # Indicate who your project is intended for
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Build Tools',

        # Pick your license as you wish
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3.8',
    ],
    keywords='the-coffee-bar opentelemetry auto instrumentation setuptools development',

    packages=find_packages(),
    python_requires='>=3.7, <4',

    install_requires=['APScheduler==3.6.3',
                      'argparse==1.4.0',
                      'opentelemetry-instrumentation==0.14b0',
                      'opentelemetry-api==0.14b0',
                      'opentelemetry-sdk==0.14b0',
                      'opentelemetry-instrumentation-flask==0.14b0',
                      'opentelemetry-instrumentation-requests==0.14b0',
                      'opentelemetry-instrumentation-psycopg2==0.14b0',
                      'opentelemetry-exporter-jaeger==0.14b0',
                      'opentelemetry-exporter-otlp==0.14b0',
                      'opentelemetry-exporter-zipkin==0.14b0',
                      'psycopg2-binary==2.8.6',
                      'pyjson==1.3.0',
                      'pyyaml==5.3.1',
                      'requests==2.24.0',
                      ],
    data_files=[('config', ['src/config/config_otlp.yaml'])],
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

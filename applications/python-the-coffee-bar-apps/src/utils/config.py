from argparse import Namespace

import yaml
import logging as log


def open_config_file(file_path: str) -> dict:
    try:
        with open(file_path, mode='r') as file:
            content = yaml.safe_load(file)
            return content
    except Exception as ex:
        log.error('Please provide existing configuration file path using "--config" switch\n%s', ex)
        exit(1)


def args_to_conf_dict(args: Namespace) -> dict:
    return vars(args)


def merge_configuration(from_file: dict, from_args: dict) -> dict:
    configuration = {}

    for arg in from_args.keys():
        configuration[arg] = promote_from_args(from_file.get(arg), from_args.get(arg))

    return configuration


def promote_from_args(from_file, from_args):
    if from_file is not None and from_args is not None:
        return from_args
    elif from_file is not None and from_args is None:
        return from_file
    else:
        return from_args


class Config:
    config = {}

    def __init__(self, config_path: str):
        self.config = open_config_file(file_path=config_path)

    def get_the_coffee_lover_config(self):
        return self.config['the_coffee_lover']

    def get_the_coffee_bar_config(self):
        return self.config['the_coffee_bar']

    def get_the_coffeemachine_config(self):
        return self.config['the_coffee_machine']

    def get_the_cashdesk_config(self):
        return self.config['the_cashdesk']

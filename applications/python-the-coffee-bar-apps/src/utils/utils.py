import json

from argparse import Namespace


def args_to_conf_dict(args: Namespace) -> dict:
    return vars(args)


def to_json(obj) -> dict:
    if isinstance(obj, str):
        return json.loads(obj)
    elif isinstance(obj, dict):
        return obj

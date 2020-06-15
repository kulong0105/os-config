# coding: utf-8

import os

def Settings( **kwargs ):
    virtual_python = os.path.join(os.getenv("PATH").split(":")[0], "python")
    return {
        'interpreter_path': virtual_python
    }

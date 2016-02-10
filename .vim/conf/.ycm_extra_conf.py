import os
import glob
import logging
import inspect
import yaml

logger = logging.getLogger( __name__ )

def CSharpSolutionFile(filepath):
    logger.info('Got filepath value "' + filepath + '" in CSharpSolutionFile function')
    for root, dirs, files in os.walk(filepath):
        for file in files:
            if len(glob.glob(os.path.join(root, '*.sln'))) == 1:
                return os.path.join(root, file)

def FindFileInClosestParent(filename, filepath):
    for root, dirs, files in os.walk(filepath):
        logger.info("FindFileInClosestParent: In root: " + root + ", with dirs: " + ','.join(dirs) + " and files: " + ','.join(files))
        for file in files:
            if file == filename:
                return os.path.join(root, file)
        break
    parent = os.path.abspath(os.path.join(root, os.pardir))
    if root != parent:
        return FindFileInClosestParent(filename, parent)
    else:
        return None

def FlagsForFile(filename, **kwargs):
    data = kwargs['client_data']
    filetype = data['&filetype']

    flags = [
                '-Wall',
                '-Wextra'
            ]

    lang_specific_flags = \
    {
        'cpp': ['-xc++', '-std=c++14'],
        'c'  : ['-xc']
    }

    flags.extend(lang_specific_flags[filetype])

    logger.info("Generating additionalIncludes for file: " + filename)
    startSearchPath = os.path.dirname(filename)
    #executable_dir = os.path.dirname(os.path.realpath(inspect.getfile(inspect.currentframe())))
    shakeCfg = FindFileInClosestParent("shake.yml", startSearchPath)
    logger.info("Found shakeCfg: " + shakeCfg)

    with open(shakeCfg, 'r') as stream:
        y = yaml.load(stream)
        logger.info(y)
        if "AdditionalIncludes" in y:
            additionalIncludes = y["AdditionalIncludes"]
        else:
            additionalIncludes = []

    includes = ['include'] + glob.glob(os.path.dirname(shakeCfg) + '/deps/*/include') + additionalIncludes

    defines  = []

    for i in includes:
        flags.append('-I' + i)
    for d in defines:
        flags.append('-D' + d)

    return {
        'flags': flags,
        'do_cache': True
    }

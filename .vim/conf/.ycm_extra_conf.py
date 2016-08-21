import os
import glob
import logging
import inspect

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

def ImplicitIncludes(srcfile):
    startSearchPath = os.path.dirname(srcfile)
    cfg = FindFileInClosestParent("config.mk", startSearchPath)

    implicitIncludes = ['include'] + glob.glob(os.path.dirname(cfg) + '/deps/*/include')
    return implicitIncludes

def IncludesFromMakeCfg(srcfile):
    startSearchPath = os.path.dirname(srcfile)
    makeCfg = FindFileInClosestParent("config.mk", startSearchPath)
    if makeCfg is None:
        return None
    # Read configuration file
    with open(makeCfg, "r") as f:
        data = f.readlines()
    # Search for lines containing ADDINC and take space separated paths
    incs = []
    for line in data:
        if "ADDINC" in line:
            incs = line.split()[2:]
    return incs

def FlagsForFile(filename, **kwargs):
    # Gather the source filetype
    data = kwargs['client_data']
    filetype = data['&filetype']

    # Debug
    #executable_dir = os.path.dirname(os.path.realpath(inspect.getfile(inspect.currentframe())))

    # Common flags
    flags = ['-Wall', '-Wextra']

    # Language variant specific flags
    lang_specific_flags = \
    {
        'cpp': ['-xc++', '-std=c++14'],
        'c'  : ['-xc']
    }
    flags.extend(lang_specific_flags[filetype])

    # Gather include directories for given source file
    logger.info("Generating include directories for file: " + filename)

    # Try parsing SBuild and then Makefile configuration if that fails
    includes = ImplicitIncludes(filename)
    makeIncludes = IncludesFromMakeCfg(filename)
    if makeIncludes is not None:
        includes += makeIncludes

    for i in includes:
        flags.append('-I' + i)

    # Gather define flags
    defines  = []
    for d in defines:
        flags.append('-D' + d)

    return {
        'flags': flags,
        'do_cache': True
    }

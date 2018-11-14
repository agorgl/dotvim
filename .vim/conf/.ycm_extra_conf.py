import os
import glob
import logging
import inspect
import subprocess

logger = logging.getLogger( __name__ )

def CSharpSolutionFile(filepath):
    logger.info('Got filepath value "' + filepath + '" in CSharpSolutionFile function')
    for root, dirs, files in os.walk(filepath):
        for file in files:
            if len(glob.glob(os.path.join(root, '*.sln'))) == 1:
                return os.path.join(root, file)

def FindFileInClosestParent(filename, filepath):
    for root, dirs, files in os.walk(filepath):
        #logger.info("FindFileInClosestParent: In root: " + root + ", with dirs: " + ','.join(dirs) + " and files: " + ','.join(files))
        for file in files:
            if file == filename:
                return os.path.join(root, file)
        break
    parent = os.path.abspath(os.path.join(root, os.pardir))
    if root != parent:
        return FindFileInClosestParent(filename, parent)
    else:
        return None

def IncludesFromMake(makecfg):
    # Retrieve makecfg relative path
    subproj_path = os.path.dirname(os.path.relpath(makecfg, os.getcwd()))
    # Handle top project case
    if subproj_path == "":
        subproj_path = "."
    logger.info("Using subproject: " + subproj_path)
    # Call makefile for include paths
    output = subprocess.Popen(["make", "showincpaths_" + subproj_path], stdout=subprocess.PIPE).communicate()[0]
    if output:
        # Convert it to string
        output = output.decode('utf8')
        # Take the first line and make space separated string a list
        incpaths = output.split('\n')[0].split()
        logger.info("Got include paths for subproject with config \"" + makecfg + "\"" + ": " + str(incpaths))
        # Make them absolute using the configuration file as a base
        #incs = map(lambda s : os.path.abspath(os.path.join(os.path.dirname(makecfg), s)), incs)
        return incpaths
    return []

def DefinesFromMake(makecfg):
    # Retrieve makecfg relative path
    subproj_path = os.path.dirname(os.path.relpath(makecfg, os.getcwd()))
    # Handle top project case
    if subproj_path == "":
        subproj_path = "."
    # Call makefile for include paths
    output = subprocess.Popen(["make", "showdefines_" + subproj_path], stdout=subprocess.PIPE).communicate()[0]
    if output:
        # Convert it to string
        output = output.decode('utf8')
        # Take the first line and make space separated string a list
        defines = output.split('\n')[0].strip().split()
        logger.info("Got defines for subproject with config \"" + makecfg + "\"" + ": " + str(defines))
        return defines
    return []

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
    if os.name == 'nt':
        flags.append("--target=x86_64-w64-mingw32")

    # Gather include directories for given source file
    logger.info("Gathering include directories for file: " + filename)

    # Find closest project config file in parent directories
    start_search_path = os.path.dirname(filename)
    makecfg = FindFileInClosestParent("config.mk", start_search_path)
    if makecfg is not None:
        logger.info("Using configuration: " + makecfg)
        # Get subproject include search path list
        includes = IncludesFromMake(makecfg)
        # Construct include search path flags
        logger.info("Using includes: " + str(includes))
        for i in includes:
            flags.append('-I' + i)
        # Get subproject define list
        defines = DefinesFromMake(makecfg)
        for d in defines:
            flags.append('-D' + d)

    return {
        'flags': flags,
        'do_cache': True
    }

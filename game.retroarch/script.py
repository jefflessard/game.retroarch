import xbmc
import xbmcaddon
import subprocess
import os

if __name__ == '__main__':
   script = os.path.join(xbmcaddon.Addon().getAddonInfo('path'), 'bin/retroarch-ctl')
   subprocess.call([script, "run"])

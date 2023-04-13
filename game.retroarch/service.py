import xbmc
import xbmcaddon
import subprocess
import os


class Monitor(xbmc.Monitor):

   def __init__(self, *args, **kwargs):
      xbmc.Monitor.__init__(self)
      self.id = xbmcaddon.Addon().getAddonInfo('id')

   def onSettingsChanged(self):
      subprocess.call(['systemctl', 'restart', self.id])


if __name__ == '__main__':
   script = os.path.join(xbmcaddon.Addon().getAddonInfo('path'), 'bin/retroarch-ctl')
   subprocess.call([script, "enable"])
   Monitor().waitForAbort()

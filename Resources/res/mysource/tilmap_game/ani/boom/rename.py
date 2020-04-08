# -*- coding: UTF-8 -*-

import os

for root, dirs, files in os.walk(os.getcwd() + "/Resources/res/mysource/tilmap_game/ani/boom"):
    for name in files:
        if name[:7] == 'boom_00':
            os.rename(os.path.join(root, name), os.path.join(root, name[:9] + '.png'))
            print(os.path.join(root, name))
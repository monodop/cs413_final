
from os import rename
from os import listdir
from os.path import isfile, join
import re

originalName = "Player"
originalExt = ".png"
digits = 3

replacements = {
	3: "Player_Idle_",
	11: "Player_Walk_",
	13: "Player_Jump_",
	14: "Player_Jump_Fast_",
	15: "Player_Jump_Med_",
	16: "Player_Jump_Slow_",
	17: "Player_Jump_Peak_",
}

i = 1
prev_r = 0
while True:
	
	fname = originalName + str(i) + originalExt
	if isfile(fname):
		replacement = ""
		index = 0
		for r in replacements.keys():
			if r >= i:
				replacement = replacements[r]
				index = i - prev_r
				if r == i:
					prev_r = r
				break
		new_fname = replacement + ("{0:0=" + str(digits) + "d}").format(index) + originalExt
		rename(fname, new_fname)
		i += 1
	else:
		break
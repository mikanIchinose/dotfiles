let g:quickrun_config={}
let g:quickrun_config["java"] = {'exec' : ['javac -J-Dfile.encoding=UTF8 %o %s', '%c -Dfile.encoding=UTF8 %s:t:r %a']}


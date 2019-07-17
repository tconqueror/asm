set temp=%~1
del -f tmp.b64 && certutil -encode Project.exe tmp.b64 && findstr /v /c:- tmp.b64 > %temp%.txt

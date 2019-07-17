set temp=%~1
certutil -decode %temp%.txt %temp%.exe

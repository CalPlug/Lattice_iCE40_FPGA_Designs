import sys
import os
import cgi

src =  "FCOriginal.png"


sys.stdout.write("<html>")
sys.stdout.write("Content-Type: image/png\n")
sys.stdout.write("Content-Length: " + str(os.stat(src).st_size) + "\n")
sys.stdout.write("\n")
sys.stdout.write("</html>")
sys.stdout.flush()
sys.stdout.buffer.write(open(src, "rb").read())



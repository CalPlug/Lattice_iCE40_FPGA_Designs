import cgi
import cgitb
import sys
cgitb.enable()
import numpy as nx
import matplotlib.pyplot as plt
import os.path
import os

sys.path.insert(0, '/usr/local/lib/python3.7/site-packages/')
import networkx
import Solver as Solver

# import GraphGenerator as GraphGen
print "Content-type:text/html\r\n\r\n"

files = glob.glob('/*.txt')
for f in files:
    print f

print """
<!DOCTYPE html>
<head>
    <title>Brandon H Lam</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="style.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
</head>

<script>
    $SCRIPT_ROOT = "http://localhost:8080/GraphWebsite/cgi-bin/";
</script>



<center>
    <h1> 
            Communities II
    </h1>
</center>

<center>
	<h2>
		Fluid Communities, Measuring Parititions, Partitions via Centrality Measures, Validating Partitions
	</h2>
</center>

<center>
	<h2> 
		Brandon Lam <br>
		EECS 118 Term Project <br>
		ID: 22623816 <br>
	</h2>

</center>

				<h1>Original Graph:</h1>
				<br>
				<center>
"""

data_uri = open('GNOriginal.png', 'rb').read().encode('base64').replace('\n', '')
img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)
print(img_tag)


print """
<script>
	function openParam(a,b,c,d,e) {
	    var keep = document.getElementById(a);
	    var hide1 = document.getElementById(b);
	    var hide2 = document.getElementById(c);
	    var hide3 = document.getElementById(d);
	    var hide4 = document.getElementById(e);
        var result1 = document.getElementById("FCResult")
        var result2 = document.getElementById("GNResult")
        var result3 = document.getElementById("PerformanceResult")
        var result4 = document.getElementById("CoverageResult")
        var result5 = document.getElementById("ValidateResult")
	    if (keep.style.display === "none") {
		keep.style.display = "block";
	    	hide1.style.display = "none";
	    	hide2.style.display = "none";
	    	hide3.style.display = "none";
	    	hide4.style.display = "none";
	    	result1.style.display = "none";
	    	result2.style.display = "none";
	    	result3.style.display = "none";
	    	result4.style.display = "none";
	    	result5.style.display = "none";
	    } else {
		    keep.style.display = "none";
	    	hide1.style.display = "none";
	    	hide2.style.display = "none";
	    	hide3.style.display = "none";
	    	hide4.style.display = "none";
	    	result1.style.display = "none";
	    	result2.style.display = "none";
	    	result3.style.display = "none";
	    	result4.style.display = "none";
	    	result5.style.display = "none";

	    }
	}
</script>
<br>
<left>
<h1>Result Graph:</h1>
</left>
<br>
<center>
"""

level = 1
while True:
    data_uri = open('GNVisualized_' + str(level) + '.png', 'rb').read().encode('base64').replace('\n', '')
    img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)
    print(img_tag)
    level = level + 1
    if not os.path.isfile('GNVisualized_' + str(level) + '.png'):
        break


print """
    <h3>Fluid Communities</h3>
    <p>This is the resulting graph from the Fluid Communities Algorithm</p>
    <h3>Available Algorithms</h3>
    <button onclick="openParam('PerformanceParam','GNParam','FCParam','CoverageParam','VerifyParam')">Measure the Performance of this Partition</button>
    <button onclick="openParam('CoverageParam','GNParam','PerformanceParam','FCParam','VerifyParam')">Measuring the Coverage of this Partition</button>
    <button onclick="openParam('VerifyParam','GNParam','PerformanceParam','CoverageParam','FCParam')">Validate this Partition</button>
    </p>
</center>
"""

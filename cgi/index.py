import cgi
import cgitb
import sys
cgitb.enable()
import numpy as nx
import matplotlib.pyplot as plt

sys.path.insert(0, '/usr/local/lib/python3.7/site-packages/')
import networkx
import Solver as Solver
#import GraphGenerator as GraphGen
print "Content-type:text/html\r\n\r\n"


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

<center>
	<h2> 
		Upload a Graph (CSV Format) or Have One Generated: 
	</h2>
</center>

<center>
	<p>
	
		<iframe style="display:none;" name="target"></iframe>
       <form enctype = "multipart/form-data" action = "save_file.py" method = "post" target = "target">
       File: <input type = "file" name = "filename"/>
       <input type = "submit" value = "Upload"/>
       </form>
       
       OR
       <br>
   
		<form name = "NewGraph" form action="GraphGenerator.py" target = "target" onsubmit ="JavaScript:OpenOGGraph()">
			        Cliques: <input name="cliques" type="text"/>
			        Size: <input name="size" type="text"/>
                    <input name="Submit"  type="submit" value="Generate" />
			<br>
		</form>
	</p>
</center>

"""

Solver.read_Graph()

print """
<script>
	function OpenOGGraph() {
	    var keep = document.getElementById("OGGraph");
	    if (keep.style.display === "none") {
		    keep.style.display = "block";
		    }
	}
</script>

<div id="OGGraph" style="display:none">
<div class="content">
	<div align = "left">
		<font size = 45px>
			<b>
				<br>
				<center>
				Graph has been uploaded/Generated. Please select an algorithm.
</center>
			</b>
		</font>
	</div>
<center>
    <h3>Available Algorithms</h3>
    <button onclick="openParam('FCParam','GNParam','PerformanceParam','CoverageParam','VerifyParam')">Fluid Communities</button>
    <button onclick="openParam('GNParam','FCParam','PerformanceParam','CoverageParam','VerifyParam')">Partitions via Centrality Measures (Girvan-Newman)</button>
    <button onclick="openParam('PerformanceParam','GNParam','FCParam','CoverageParam','VerifyParam')">Measuring Partitions - Performance</button>
    <button onclick="openParam('CoverageParam','GNParam','PerformanceParam','FCParam','VerifyParam')">Measuring Partitions - Coverage</button>
    <button onclick="openParam('VerifyParam','GNParam','PerformanceParam','CoverageParam','FCParam')">Validate Partition</button>
</div>
</center>
</div>

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

<script>
	function displayResult(a,b,c,d,e) {
	    var keep = document.getElementById(a);
	    var hide1 = document.getElementById(b);
	    var hide2 = document.getElementById(c);
	    var hide3 = document.getElementById(d);
	    var hide4 = document.getElementById(e);
	    if (keep.style.display === "none") {
		    keep.style.display = "block";
	    	hide1.style.display = "none";
	    	hide2.style.display = "none";
	    	hide3.style.display = "none";
	    	hide4.style.display = "none";
	    } else {
		    keep.style.display = "none";
	    	hide1.style.display = "none";
	    	hide2.style.display = "none";
	    	hide3.style.display = "none";
	    	hide4.style.display = "none";
	    }
	}
</script>

<div id="FCParam" style="display:none">
		<form name = "FC" form action="FC.py">
			        Enter number of communities to be found: <input name="size" type="text"/>
                    <input name="Submit"  type="submit" value="Generate" />
        </form>
</div>

<div id="GNParam" style="display:none">
		<form name = "GN" form action="GN.py">
			        Enter number of tuples of communities to be found: <input name="size" type="text"/>
                    <input name="Submit"  type="submit" value="Generate" />
        </form>
</div>

<div id="PerformanceParam" style="display:none">
	Enter Partition File: <input name="location" type="text"/>
	<button onclick="displayResult()">Browse</button>
	<button onclick="displayResult()">Submit</button>
</div>

<div id="CoverageParam" style="display:none">
	Enter Partition File: <input name="location" type="text"/>
	<button onclick="displayResult()">Browse</button>
	<button onclick="displayResult()">Submit</button>
</div>

<div id="VerifyParam" style="display:none">
	Enter Partition File: <input name="location" type="text"/>
	<button onclick="displayResult()">Browse</button>
	<button onclick="displayResult()">Submit</button>
</div>

<div id = "FCResult" style="display:none">
<div class="content">
	<div align = "left">
		<font size = 45px>
			<b>
				Result Graph:
			</b>
		</font>
	</div>
<center>
"""

data_uri = open('FCVisualized.png', 'rb').read().encode('base64').replace('\n', '')
img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)
print(img_tag)

print """"
    <h3>Fluid Communities</h3>
    <p>
    This is the resulting graph from the Fluid Communities Algorithm
    <h3>Available Algorithms</h3>
    <button onclick="openParam('PerformanceParam','GNParam','FCParam','CoverageParam','VerifyParam')">Measure the Performance of this Partition</button>
    <button onclick="openParam('CoverageParam','GNParam','PerformanceParam','FCParam','VerifyParam')">Measuring the Coverage of this Partition</button>
    <button onclick="openParam('VerifyParam','GNParam','PerformanceParam','CoverageParam','FCParam')">Validate this Partition</button>
    </p>
</div>
</center>
</div>

<div id = "GNResult" style="display:none">
<div class="content">
	<div align = "left">
		<font size = 45px>
			<b>
				Result Graph:
			</b>
		</font>
	</div>
<center>
"""

data_uri = open('GNVisualized_1.png', 'rb').read().encode('base64').replace('\n', '')
img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)
print(img_tag)
data_uri = open('GNVisualized_2.png', 'rb').read().encode('base64').replace('\n', '')
img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)
print(img_tag)
data_uri = open('GNVisualized_3.png', 'rb').read().encode('base64').replace('\n', '')
img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)
print(img_tag)

print """
    <h3>Partitions via Centrality Measures</h3>
    <p>
    This is the resulting graph from the Girvan-Newman Algorithm
    </p>
</div>
</center>
</div>
<div id = "PerformanceResult" style="display:none">
</div>

"""


import cgi
import GraphGenerator(1,2)
print "Content-type: text/html\n\n";

print """
<html class="no-js">
<head>
    <title>Brandon H Lam</title>
    <link type="text/css" rel="stylesheet" href="/style.css" />
    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
</head>

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
		<form action = "x.jsp">
			Select File: <input name="location" type="text"/>
    			<button class="button">Submit</button>
			<br> or <br>
    			<button class="button">Generate a Graph</button>
			<br>
		</form>
	</p>
</center>
"""
#GraphGen.generate(1,2)

print """
<div class="content">
	<div align = "left">
		<font size = 45px>
			<b>
				Original Graph:
                                    <img src="/FCOriginal.png">

"""

data_uri = open('FCOriginal.png', 'rb').read().encode('base64').replace('\n', '')
img_tag = '<img src="data:image/png;base64,{0}">'.format(data_uri)

print(img_tag)

#execfile ('image.py')
print """
			</b>
		</font>
	</div>
<center>
    <img src="http://localhost:8000/FCOriginal.png">
    <h3>Avaliable Algorithms</h3>
    <button onclick="openParam('FCParam','GNParam','PerformanceParam','CoverageParam','VerifyParam')">Fluid Communities</button>
    <button onclick="openParam('GNParam','FCParam','PerformanceParam','CoverageParam','VerifyParam')">Partitions via Centrality Measures (Girvan-Newman)</button>
    <button onclick="openParam('PerformanceParam','GNParam','FCParam','CoverageParam','VerifyParam')">Measuring Partitions - Performance</button>
    <button onclick="openParam('CoverageParam','GNParam','PerformanceParam','FCParam','VerifyParam')">Measuring Partitions - Coverage</button>
    <button onclick="openParam('VerifyParam','GNParam','PerformanceParam','CoverageParam','FCParam')">Validate Partition</button>
</div>
</center>

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
	function displayResult() {
	    var x = document.getElementById("FCResult");
	    if (x.style.display === "none") {
		x.style.display = "block";
	    } else {
		x.style.display = "none";
	    }
	}
</script>

<div id="FCParam" style="display:none">
	Enter number of communities to be found: <input name="location" type="text"/>
	<button onclick="displayResult()">Submit</button>
</div>

<div id="GNParam" style="display:none">
	Enter number of communities to be found: <input name="location" type="text"/>
	<button onclick="displayResult()">Submit</button>
</div>

<div id="PerformanceParam" style="display:none">
	Enter number of communities to be found: <input name="location" type="text"/>
	<button onclick="displayResult()">Submit</button>
</div>

<div id="CoverageParam" style="display:none">
	Enter number of communities to be found: <input name="location" type="text"/>
	<button onclick="displayResult()">Submit</button>
</div>

<div id="VerifyParam" style="display:none">
	Enter number of communities to be found: <input name="location" type="text"/>
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
    <img src="FCVisualized.png"/ alt="" >
    <h3>Fluid Communities</h3>
    <p>
    This is the resulting graph from the Fluid Communities Algorithm
    </p>
</div>
</center>
</div>
"""

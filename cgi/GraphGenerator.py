import cgi
import cgitb
import sys
sys.path.insert(0, '/usr/local/lib/python3.7/site-packages/')
cgitb.enable()
import networkx as nx

form = cgi.FieldStorage()
x = int(form["cliques"].value)
y = int(form["size"].value)
G = nx.connected_caveman_graph(x, y)
with open('graph.csv', 'w') as f:
    for x in G.edges:
        y = ','.join(map(str,x))
        f.write(y+',1\n')


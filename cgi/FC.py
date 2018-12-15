import sys
import cgi
import matplotlib.pyplot as plt
import numpy as np
sys.path.insert(0, '/usr/local/lib/python3.7/site-packages/')
import cgitb
cgitb.enable()
import networkx as nx
import csv
import pylab
import itertools
import matplotlib.cm as cm
import matplotlib.colors as cls


m = None
n = None
G = None
pos = None


def read_Graph():
    global m
    global G
    global pos
    m = 'graph.csv'
    G = nx.read_edgelist(m, delimiter=",", nodetype = int, data=[("weight", int)])
    G.edges(data=True)
    pos = nx.spring_layout(G)
    #save original graph
    nx.draw(G, pos, with_labels=True, node_color='b', edge_color='k', node_size=200, alpha=0.5)
    pylab.title('Original', fontsize=15)
    pylab.savefig('FCOriginal.png')

form = cgi.FieldStorage()
n = int(form['size'].value)
read_Graph()
GIter = nx.community.asyn_fluidc(G, int(n))
communities = []
for GCommunity in GIter:
    communities.append(GCommunity)
colormap = plt.cm.gist_ncar
colors = [colormap(i) for i in np.linspace(0, 1, len(communities))]
nx.draw(G, pos, with_labels=True, edge_color='k', node_size=200, alpha=0.5)
pylab.title('Visualized', fontsize=15)
with open('FCPartition.txt', 'w') as f:
    i = 0
    for x in communities:
        nx.draw_networkx_nodes(G, pos, nodelist = x, node_color=colors[i])
        y = ','.join(map(str, x))
        f.write(y + '|')
        i = i + 1
pylab.savefig('FCVisualized.png')

print """
Status: 303 See other
Location: ./FCResult.py
"""

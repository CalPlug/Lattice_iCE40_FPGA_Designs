import sys
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
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
    pylab.savefig('Original.png')

def FC(depth):
    n = depth
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


def GN(depth):
    n = depth
    #GN levels
    level = 1
    comp = nx.community.girvan_newman(G)
    for communities in itertools.islice(comp, int(n)):
        nx.draw(G, pos, with_labels=True, edge_color='k', node_size=200, alpha=0.5)
        colormap = plt.cm.gist_ncar
        colors = [colormap(i) for i in np.linspace(0, 1, len(communities))]
        pylab.title('Visualized', fontsize=15)
        with open('GNPartition_' + str(level) + '.txt', 'w') as f:
            i = 0
            for x in communities:
                nx.draw_networkx_nodes(G, pos, nodelist = x, node_color=colors[i])
                y = ','.join(map(str, x))
                f.write(y + '|')
                i = i + 1
        pylab.savefig('GNVisualized_' + str(level) + '.png')
        level = level + 1


def hit_VP():
    def show_result():
        n = depth.get()

        with open(n,'r') as f:
            n = f.readline()
            n = n[:-1]
        partition = []

        communities = n.split("|")
        for i in range(0,len(communities)):
            nodes = communities[i].split(",")
            s = set(nodes)
            T2 = set(map(int, s))
            partition.append(T2)
        partitions = iter(partition)
        print(partitions)

        a = nx.community.is_partition(G, partition)
        print(partition)
        print(G.nodes())
        print(a)
        messagebox.showinfo("Is the set a valid partition?", "Set: " '[%s]' % ', '.join(map(str, partition)) + "\n%s" % (a))


    def select_partition():
        partition_ = askopenfilename() #path function
        depth.set(partition_)

def hit_Coverage():
    n = depth.get()

    with open(n,'r') as f:
        n = f.readline()
        n = n[:-1]

    partition = []
    communities = n.split("|")
    for i in range(0,len(communities)):
        nodes = communities[i].split(",")
        s = set(nodes)
        T2 = set(map(int, s))
        partition.append(T2)
    partitions = iter(partition)
    for x in partitions:
        print(x)
        print(partitions)

    if not nx.community.is_partition(G, partition):
        messagebox.showinfo("Invalid Partition", "The entered partition is not a valid partition of the nodes of the graph. Please try again.")
    else:
        a = nx.community.coverage(G, partition)
        messagebox.showinfo("Coverage Measurement", "Partition: " '[%s]' % ', '.join(map(str, partition)) + "\nHas a coverage of: "+ "%f" % (a) +
                            "\n\n(Coverage is defined as ratio of the number of intra-community edges to the total number of edges in the graph)")

    def select_partition():
        partition_ = askopenfilename() #path function
        depth.set(partition_)

def hit_Performance():
    def show_result():
        n = depth.get()

        with open(n,'r') as f:
            n = f.readline()
            n = n[:-1]

        partition = []
        communities = n.split("|")
        for i in range(0,len(communities)):
            nodes = communities[i].split(",")
            s = set(nodes)
            T2 = set(map(int, s))
            partition.append(T2)
        partitions = iter(partition)
        for x in partitions:
            print(x)
            print(partitions)

        if not nx.community.is_partition(G, partition):
            messagebox.showinfo("Invalid Partition", "The entered partition is not a valid partition of the nodes of the graph. Please try again.")
        else:
            a = nx.community.performance(G, partition)
            messagebox.showinfo("Performance Measurement", "Partition: " '[%s]' % ', '.join(map(str, partition)) + "\nHas a performance of: "+ "%f" % (a) +
                                "\n\n(Performance is defined as the ratio of the number of intra-community edges plus inter-community non-edges with the total number of potential edges)")


def select_partition():
    partition_ = askopenfilename() #path function
    depth.set(partition_)

def select_path():
    path_ = askopenfilename() #path function
    path.set(path_)


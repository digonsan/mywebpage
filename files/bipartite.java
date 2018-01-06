/* 
Source: https://ipg.epfl.ch/page-136872-en.html hw1, problem 1.

I think this program is best case in average O(nl) where n is the number of 
variable nodes and l is the degree of variable nodes, in worse cases l could be as big as m = (n*l)/r, which is the number of check nodes (and r is their degree)*/

import java.util.Random;

class Node {
    int type; //0 - variable, 1 - check
    int[] sockets;
    
    Node(int t, int d){
        type = t;
        sockets = new int[d];
    }
}

class Edge {
    int var_side; //id of socket in variable node
    int chk_side; //id of socket in check node
    
    Edge(int v, int c){
        var_side = v;
        chk_side = c;
    }
}


public class bipartite {
    //declare global arrays
    static int[] var_sockets;
    static int[] chk_sockets;
    static Node[] var_nodes;
    static Node[] chk_nodes;
    static Edge[] edges;


    public static void main (String[] args){
        int l = Integer.parseInt(args[0]);//variable node degree
        int r = Integer.parseInt(args[1]);//check node degree
        int n = Integer.parseInt(args[2]);//number of variable nodes
        int m = Integer.parseInt(args[3]);//number of check nodes
        check_valid(l, r, n, m);
        
        //initalize data structures
        int ned = n*l; //note m*r = n*l
        var_sockets = new int[ned];
        chk_sockets = new int[ned];
        //set all to -1 to have a way to check if they are already "connected"
        for(int i = 0; i < size; i++){
            var_sockets[i] = -1;
            chk_sockets[i] = -1;
        }
        var_nodes = new Node[n];
        chk_nodes = new Node[m];
        edges = new Edge[ned];
        
        //fill in data structures
        make_nodes(0, l, n);//make variable nodes
        make_nodes(1, r, m);//make check nodes
        make_graph(n*l);
        print_graph(n*l, l, r);
    }

//permutation idea inspired from http://stackoverflow.com/questions/6946789/generating-random-permutation-uniformly-in-java 
    static int[] permute(int size){
        int[] permutation = new int[size];
        Random rand = new Random();
        //first they are all "in order"
        for (int i =0; i < size; i++){
            permutation[i] = i;
        }
        //randomly swap entries with entries that are ahead in the array
        for (int i = 0; i < size; i++){
            int new_i = i + rand.nextInt(size-i);
            int temp = permutation[i];
            permutation[i] = permutation[new_i];
            permutation[new_i] = temp;
        }
        return permutation;
    }
    
    //join each ith variable node with the ith check node in the permutation
    static void make_graph(int nedges){
        int[] permutation = permute(nedges);
        for (int var = 0; var < nedges; var++){
            int chk = permutation[var];
            Edge new_edge = new Edge(var, chk);
            edges[var] = new_edge;
        }
    }
    
    static void make_nodes(int type, int degree, int howmany){
        //fill in different arrays depending on which nodes are being created
        int [] sockets;
        Node[] nodes;
        if(type==1){//1 chk, 0 var
            sockets = chk_sockets;
            nodes = chk_nodes;
        } else {
            sockets = var_sockets;
            nodes = var_nodes;
        }
        //make nodes and fill in arrays
        for (int i = 0; i < howmany; i++){
            Node new_node = new Node(type, degree);
            nodes[i] = new_node;//nodes array is just all the nodes of spec type
            
/*sockets array has n*l entries:
  - The index of each entry indicates the "label" of that socket - 1.
  - The value of that entry indicates the node index (i)
  new_node.sockets array has l entries
  - The index of that entry doesn't mean anything for now
  - The value of that entry indicates the "label" of the socket
 */           
            for (int j = 0; j < degree; j++){
                Random rand = new Random();
                //NOTE this n is not the same n
                int n = rand.nextInt(howmany*degree);
                while (sockets[n] != -1){
                    n = rand.nextInt(howmany*degree);
                }
                sockets[n] = i;//TO DO: how to know which socket in i though??
                new_node.sockets[j] = n;
            } 
        }
    }
    
    //check if the input is valid as per specifications
    static void check_valid(int l, int r, int n, int m){
        if (l < 1 || r < 1 || n < 1 || m < 1){
            System.out.println("Error: cannot handle non-positive values");
            System.exit(1);
        }
        if (m != (n*l)/r){
            System.out.println("Error: invalid number for check nodes");
            System.exit(1);
        }
    }
    
    //print graph for debug/to prove that it is working
    static void print_graph(int nedges, int vard, int chkd){
        for(int i = 0; i < nedges; i++){//for each edge
            int var = edges[i].var_side;//get both sides of the edge
            int chk = edges[i].chk_side;
            int vari = var_sockets[var];//var is label, value is index of node
            int chki = chk_sockets[chk];//similarly for chk
            Node var_node = var_nodes[vari];//use retrieved indices to get nodes
            Node chk_node = chk_nodes[chki];
            int vnodesock = -1;
            int cnodesock = -1; 
            //look though all the sockets of the retrieved nodes to see
            //which socket was used
            for(int j = 0; j < vard; j++){
                if (var_node.sockets[j] == var){
                    vnodesock = j;
                    break;
                }
            }
            for(int j = 0; j < chkd; j++){
                if (chk_node.sockets[j] == chk){
                    cnodesock = j;
                    break;
                }
            }
            //print stuff
            System.out.println("Edge "+i+" is (var,chk) = ("+var+", "+chk+
                               ") \nJoining var node "+vari+" at socket "
                               +vnodesock+"\n     to chk node "+chki+" at socket "
                               +cnodesock);
            System.out.println("");
        }
    }
}

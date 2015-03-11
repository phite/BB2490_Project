import os,sys,glob

# CODE TO SPLIT ALL THE SEQUENCES IN HUMAN AND YEAST


path_file_1 = "/Users/MarcoSalvatore/Desktop/"
path_da_aprire = glob.glob(path_file_1+'human_joined.fasta') 

for lines in path_da_aprire: 	
	lines=open(lines,"r")
	lines=lines.readlines()
	for seq in lines:
		seq=seq.rstrip('\n')
		if seq.startswith('>'):
			ids = seq
		elif not seq.startswith('>'):
			reads = [seq[i:i+25] for i in range(0, len(seq))]  #CREATION SLIDING WINDOW OF 25 RESIDUES
			for element in reads:
				if len(element)==25:
					print ids
					print element	
		
import os,sys,glob

def extraction():
	lista = []
	with open('blacklist.fasta','r') as filez:
				for elz in filez:
					elz=elz.strip('\n')
					#ele = elz.split(' ')
					if not elz.startswith('>'):
						lista.append(elz)
				
				with open('yeast_transcripts25.fa_yeast_mapped.sam_extracted','r') as files :
					for ext in files:
						ext = ext.strip('\n')
						fragment = ext.split('\t')
						if fragment[-1] in lista :
							print ext


def compare(files,filex):
	f=(open(files,'rb'))
	d=(open(filex,'rb'))
	dicbed={}
	dicbed25={}
	for line1 in f:
		line1=line1.rstrip()
		line1=line1.split('\t')
	
		
		if int(line1[2])-int(line1[1])>25:
			dicbed[line1[0]+":"+str(line1[1])]=str(line1[2]+":"+line1[3])
		else:
			dicbed25[line1[0]+":"+str(line1[1])]=str(line1[2]+":"+line1[3])
	
	for lines in d:
		lines=lines.rstrip()
		lines=lines.split('\t')
		x=lines[2]+":"+str(lines[3])
		#print x
		y=str(lines[4])+":"+str(lines[1])
		
		for k,v in dicbed.iteritems():
			try:
				if k==x:	
					prima=lines[5]
			
				
				if v==y:
					add=int(v.split(":")[0])-int(k.split(":")[1])-25
					print ">"+k+":"+v+"\t"+prima+lines[5][-add:]
					#print prima+lines[5][-add:]
			except:
				pass
	
		for k,v in dicbed25.iteritems():
			if k==x:
				header= ">"+k+":"+v
			if v==y:
				print header+"\t"+lines[5]
	
if __name__ == "__main__":
	with open(os.path.join('/Users/MarcoSalvatore/Desktop','yeast-blacklist-semidef.txt'),"w") as p:
		saveout = sys.stdout
		sys.stdout = p
		extraction()
		p.close()
		sys.stdout = saveout
	compare('/Users/MarcoSalvatore/Desktop/yeast-blacklist.bedmerge_pos','/Users/MarcoSalvatore/Desktop/yeast-blacklist-semidef.txt')

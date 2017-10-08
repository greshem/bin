class Gre:
	def __init__(self, name):
		self.name=name;

	def  echo(self):
		print "BBBBB",  self.name;

if __name__=="__main__":
	a=Gre("this_is_greshem");
	a.echo();

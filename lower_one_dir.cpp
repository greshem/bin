#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <iostream> 
using namespace std;
int find(char *in);
int find2(char *in );
int main(int argc, char *argv[])
{
	char *tmpbuf="/vld/sys/fdos/";
	find2(tmpbuf);
	return 0;
}
int lower(char *in , int len)
{
	char *p= in;
	for(int i=0; i< len; i++)
	{
		if(*(p+i)>='A' && *(p+i) <= 'Z')
		{
			in[i]+='a'-'A';
		}
	}
	return 0;
}

int find2(char *in )
{
	//printf("##### %s\n", in);
	string pwd(in);
	static char cwd[1024];
	DIR *dirp;
	struct dirent *dp;

	chdir(pwd.c_str());
	if((dirp=opendir("." ) )==NULL)
	{
		printf("opendir error\n");
		return -1;
	}
	getcwd(cwd, 1024);

	while((dp=readdir(dirp)))
	{
		if(dp->d_type==DT_DIR)
		{
			if(strcmp(dp->d_name, ".")==0)			
			{
				continue;
			}
			if(strcmp(dp->d_name,"..") == 0)
			{
				continue;
			}

			//printf("%s/%s", cwd, dp->d_name);
			 char    path[1024]={0};
			char orig[1024]={0};
			//memset(path, '\0', 1024);
			strncpy(orig, dp->d_name, sizeof(orig));	

			lower(dp->d_name, strlen(dp->d_name));

			printf("######DIR: %s -->  %s\n", orig, dp->d_name);
			if(rename(orig, dp->d_name))
			{
				perror(" DIR rename error");
			}
			sprintf(path, "%s/%s", pwd.c_str(), dp->d_name);

			find2(path  );
		}
		else//(dp->d_type==DT_FILE)
		{
			//printf("%s/%s\n",cwd, dp->d_name);
			char file[1024];
			char orig[1024]={0};

			strncpy(orig, dp->d_name, sizeof(orig));	

			lower(dp->d_name, strlen(dp->d_name));
	
			printf("#FILE %s -->  %s\n", orig, dp->d_name);
			if(  rename(orig, dp->d_name))
			{
				perror("FILENAME rename error");
			}
		
			sprintf(file, "%s/%s", pwd.c_str(), dp->d_name);
			printf("%s\n", file);
		}
	}
	closedir(dirp);
	chdir("..");
return 0;
}

int find(char *in)
{
	chdir(in);
	DIR *dirp;
	struct dirent *dp;
	if((dirp=opendir(in))==NULL)
	{
		printf("opendir error\n");
		return -1;
	}
	while((dp=readdir(dirp)))
	{
		if(dp->d_type==DT_DIR)
		{
			if(!strcmp(dp->d_name, ".")&&  !strcmp(dp->d_name,".."))
			{
				find(dp->d_name);
			}
		}
		else
		{
			lower(dp->d_name, strlen(dp->d_name));
			printf("%s\n", dp->d_name);
		}
	}
}

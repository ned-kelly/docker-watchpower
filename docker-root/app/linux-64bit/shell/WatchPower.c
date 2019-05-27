#define DIR_LIB "./lib/"

#include <dirent.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main(void)
{
    char classPath[1024];
    strcpy(classPath, "-Djava.class.path=.:");

    DIR *dirp; 
    struct dirent *dp;
    dirp = opendir(DIR_LIB);
    while ((dp = readdir(dirp)) != NULL) {
	if(strstr(dp->d_name, ".jar") == NULL){
		continue;
	}
        
        strcat(classPath, DIR_LIB);
	strcat(classPath, dp->d_name);
	strcat(classPath, ":");
    }      
    (void) closedir(dirp);
    char *p[4];
    p[0] = "javaw";
    p[1] = classPath;
    p[2] = "cn.com.voltronic.solar.console.linux.WatchPower";
    p[3] = NULL;
    execv("./jre/bin/java",p);
}

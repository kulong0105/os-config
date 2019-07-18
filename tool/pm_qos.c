/********************************************************************
 *Program:
 * 		dynamically tuned cpu's latency by using PM QOS interface.
 *
 *********************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>


static int pm_qos_fd = -1;

void start_low_latency(int latency, char command[], char s_flag,
		       char f_flag, char r_flag, char d_flag);
void check_current_latency(void);
void usage(char *selfname);


int main(int argc, char *argv[])
{

    if (argc < 2) {
	printf("-----------parameter is not enough------------\n");
	usage(argv[0]);
	return 1;
    }

    int opt;
    int latency;
    char command[100];
    memset(command, 0, sizeof(command));
    static int command_step = 0;
    int num = 0;

    char s_flag = 0;
    char f_flag = 0;
    char r_flag = 0;
    char d_flag = 0;

    opterr = 0;			// prohibit show  getopt()  error message
    while ((opt = getopt(argc, argv, "hcs:f:r:d")) != -1) {
	num++;
	switch (opt) {
	case 'h':
	    usage(argv[0]);
	    return 0;

	case 'c':
	    check_current_latency();
	    return 0;

	case 's':
	    s_flag = 1;
	    latency = atoi(optarg);
	    break;

	case 'f':
	    f_flag = 1;
	    latency = atoi(optarg);
	    break;

	case 'r':
	    r_flag = 1;
	    num = optind - 1;

	    for (num; num < argc; num++) {
		sprintf(command + command_step, "%s ", argv[num]);
		command_step += strlen(argv[num]) + 1;
	    }
	    goto start_run;


	case 'd':
	    d_flag = 1;
	    break;

	case '?':
	    printf("Unknown option: %c \n", (char) optopt);
	    usage(argv[0]);
	    return 1;

	default:
	    printf("It should be never get there!\n");
	    usage(argv[0]);
	    return 1;
	}
    }


  start_run:

    if (s_flag == 1 || f_flag == 1) {
	if (r_flag == 1 || d_flag == 1) {

	    start_low_latency(latency, command, s_flag, f_flag,
			      r_flag, d_flag);
	    return 0;

	}
    }


    usage(argv[0]);

    return 1;

}


/************************************************************************
 *function:
 *	set cpu's latency.
 * 
 *parameter:
 *	latency: unit is a microsecond.
 *	command: process to run
 *	*_flag : option flag.
 *
 ************************************************************************/
void start_low_latency(int latency, char command[], char s_flag,
		       char f_flag, char r_flag, char d_flag)
{

    if (pm_qos_fd >= 0)
	return;

    if (latency < 0) {
	printf("latency must be greater than 0.\n", latency);
	return;
    }


    if ((pm_qos_fd = open("/dev/cpu_dma_latency", O_RDWR)) == -1) {
	perror("Failed to open PM QOS file:");
	return;
    }


    int current_latency = -1;
    if (read(pm_qos_fd, &current_latency, sizeof(current_latency)) == -1) {
	perror("Failed to read cpu_dma_latency file:");
	return;
    }

    if (s_flag == 1) {

	if (latency > current_latency) {

	    printf("current_latency = %d\n", current_latency);
	    printf("set_latency = %d\n", latency);
	    printf
		("set_latency must be less than current_latency,unless you use -f option.\n");
	    return;
	}
    } else {
	if (latency > current_latency) {
	    int fd;
	    char tmpfile[100];

	    sprintf(tmpfile, "tmpfile_%d", getpid());
	    if ((fd = open(tmpfile, O_CREAT | O_RDWR, 0644)) == -1) {
		perror("Failed to open  tmpfile:");
		return;
	    }

	    dup2(fd, STDOUT_FILENO);	//redirection STDOUT_FILENO to tmpfile
	    close(fd);

	    system
		("lsof /dev/cpu_dma_latency | sed -n '6,$p' | awk '{print $1}'");


	    close(STDOUT_FILENO);
	    open("/dev/tty", O_WRONLY);	//restore stdout

	    if ((fd = open(tmpfile, O_RDWR)) == -1) {
		perror("Failed to open tmpfile:");
		return;
	    }

	    char ch = 0;
	    char process_name[50];	//stroage process's name
	    memset(process_name, 0, 50);
	    int res = 0;

	    int i = 0;

	    while ((res = read(fd, &ch, 1)) != 0) {
		if (ch != '\n') {
		    process_name[i] = ch;
		    i++;
		} else {

		    printf("Process: %s will be killed!\n", process_name);
		    memset(process_name, 0, 50);
		    i = 0;
		}
	    }

	    unlink(tmpfile);
	    system
		("kill -9  `lsof -t /dev/cpu_dma_latency | sed -n '5,$p'`");

	}
    }


    if (write(pm_qos_fd, &latency, sizeof(latency)) == -1) {

	perror("Failed to write cpu_dma_latency file:");
	return;
    }


    printf("Befor set,latency = %d\n", current_latency);
    printf("After set,latency = %d\n", latency);


    if (r_flag == 1) {
	system(command);
	close(pm_qos_fd);
    } else {

	daemon(1, 1);

	while (1) {
	    sleep(1000);
	}

    }

    return;
}

/************************************************************************
 *function:
 *	1:show cpu's current latency.
 *	2:show c-state's max latency.
 *
 ************************************************************************/
void check_current_latency(void)
{
    if ((pm_qos_fd = open("/dev/cpu_dma_latency", O_RDWR)) == -1) {
	perror("Failed to open PM QOS file:");
	return;
    }

    int current_latency = -1;
    if (read(pm_qos_fd, &current_latency, sizeof(current_latency)) == -1) {
	perror("Failed to read cpu_dma_latency file:");
	return;
    }
    printf("current_latency = %d\n", current_latency);

    if (close(pm_qos_fd) == -1)
	perror("Failed to close cpu_dma_latency file:");



    int fd;
    char tmpfile[100];

    sprintf(tmpfile, "tmpfile_%d", getpid());
    if ((fd = open(tmpfile, O_CREAT | O_RDWR, 0644)) == -1) {
	perror("Failed to open  tmpfile:");
	return;
    }

    dup2(fd, STDOUT_FILENO);	//redirection STDOUT_FILENO to tmpfile
    close(fd);

    system("cpupower  idle-info | grep Latency | awk '{print $2}'");

    close(STDOUT_FILENO);
    open("/dev/tty", O_WRONLY);	//restore stdout

    if ((fd = open(tmpfile, O_RDWR)) == -1) {
	perror("Failed to open tmpfile:");
	return;
    }

    char ch = 0;
    char time_us[6][10];	//stroage C-State's max latency
    memset(time_us, 0, sizeof(time_us));
    int res = 0;

    static int i = 0;
    static int j = 0;

    while ((res = read(fd, &ch, 1)) != 0) {
	if (ch != '\n') {
	    time_us[i][j] = ch;
	    j++;
	} else {
	    i++;
	    j = 0;
	}
    }

    unlink(tmpfile);

    printf("C0-state's  max latency is %3d us\n", atoi(time_us[0]));
    printf("C1-state's  max latency is %3d us\n", atoi(time_us[1]));
    printf("C1E-state's max latency is %3d us\n", atoi(time_us[2]));
    printf("C3-state's  max latency is %3d us\n", atoi(time_us[3]));
    printf("C6-state's  max latency is %3d us\n", atoi(time_us[4]));
    printf("C7-state's  max latency is %3d us\n", atoi(time_us[5]));

    return;
}



void usage(char *selfname)
{
    printf("Synopsis:\n");
    printf("   %s -h \n", selfname);
    printf("   %s -c \n", selfname);
    printf("   %s -s max_latency -r program_to_run\n", selfname);
    printf("   %s -s max_latency -d \n", selfname);
    printf("   %s -f max_latency -r program_to_run\n", selfname);
    printf("   %s -f max_latency -d\n", selfname);

    printf("Options:\n");
    printf("   -h  show help message.\n");
    printf("   -c  show current cpu's latency(unit in us).\n");
    printf("   -s  set  cpu's latency(unit in us).\n");
    printf("   -r  set  run program(unit in us).\n");
    printf("   -d  run as a daemon(unit in us).\n");
    printf
	("   -f  force set  cpu's latency(unit in us). Warning:This may be stop tuned service and other service.\n");

    printf("Example:\n");
    printf("   %s -s 100 -r /usr/bin/ls\n", selfname);
    printf("   %s -s 100 -d\n", selfname);
    return;
}

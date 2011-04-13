#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>

static volatile int SIGINT_count = 0;

#pragma unused ignore

void
gbeta_SIGINThandler(int ignore)
{ 
  SIGINT_count++;
  signal(SIGINT,&gbeta_SIGINThandler);
}

void
gbeta_setupSIGINT(void)
{
  signal(SIGINT,&gbeta_SIGINThandler);
}

long 
gbeta_receivedSIGINT(void)
{
  int count=SIGINT_count;
  SIGINT_count=0;
  return count;
}

void
gbeta_simulateSIGINT(void)
{
  SIGINT_count++;
}

void
gbeta_SIGCHLDhandler(int ignore)
{
  /* just let the kernel forget the (zombie) process data */
  wait(NULL);
  signal(SIGCHLD,&gbeta_SIGCHLDhandler);
}

void
gbeta_setupSIGCHLD(void)
{
  signal(SIGCHLD,&gbeta_SIGCHLDhandler);
}

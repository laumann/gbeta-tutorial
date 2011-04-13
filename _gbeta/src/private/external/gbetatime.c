#include <sys/times.h>

long
gbeta_get_utime(void)
{
  struct tms TMS;
  times(&TMS);
  return (long)TMS.tms_utime;
}

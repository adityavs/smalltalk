# sigaltstack.m4 serial 3 (libsigsegv-2.2)
dnl Copyright (C) 2002-2003 Bruno Haible <bruno@clisp.org>
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.

AC_DEFUN([GST_REPLACE_POLL], [

AC_CACHE_CHECK(for working poll, gst_cv_func_poll, [
  exec AS_MESSAGE_FD([])>/dev/null
  AC_CHECK_FUNC(poll, [
    # Check whether poll() works on special files (like /dev/null) and
    # and ttys (like /dev/tty). On MacOS X 10.4.0, it doesn't.
    AC_TRY_RUN([
#include <fcntl.h>
#include <poll.h>
      int main()
      {
	struct pollfd ufd;
	/* Try /dev/null for reading.  */
	ufd.fd = open ("/dev/null", O_RDONLY);
	if (ufd.fd < 0) /* If /dev/null does not exist, it's not MacOS X. */
	  return 0;
	ufd.events = POLLIN;
	ufd.revents = 0;
	if (!(poll (&ufd, 1, 0) == 1 && ufd.revents == POLLIN))
	  return 1;
	/* Try /dev/null for writing.  */
	ufd.fd = open ("/dev/null", O_WRONLY);
	if (ufd.fd < 0) /* If /dev/null does not exist, it's not MacOS X. */
	  return 0;
	ufd.events = POLLOUT;
	ufd.revents = 0;
	if (!(poll (&ufd, 1, 0) == 1 && ufd.revents == POLLOUT))
	  return 1;
	/* Trying /dev/tty may be too environment dependent.  */
	return 0;
      }], [gst_cv_func_poll=yes], [gst_cv_func_poll=no], [
      # When cross-compiling, assume that poll() works everywhere except on
      # MacOS X, regardless of its version.
      AC_EGREP_CPP([MacOSX], [
#if defined(__APPLE__) && defined(__MACH__)
This is MacOSX
#endif
      ], [gst_cv_func_poll='possibly not'], [gst_cv_func_poll=yes])])
  ], [gst_cv_func_poll=no])
  test "$silent" != yes && exec AS_MESSAGE_FD([])>&1
])

if test $gst_cv_func_poll != yes; then
  AC_LIBOBJ(poll)
  AC_DEFINE(poll, rpl_poll,
    [Define to rpl_poll if the replacement function should be used.])
fi
])

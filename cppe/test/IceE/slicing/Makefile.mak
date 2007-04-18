# **********************************************************************
#
# Copyright (c) 2003-2007 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ..\..\..

CLIENT		= client.exe
SERVER		= server.exe

TARGETS		= $(CLIENT) $(SERVER)

COBJS		= Test.obj \
		  Client.obj \
		  AllTests.obj

SOBJS		= Test.obj \
    		  ServerPrivate.obj \
		  TestI.obj \
		  Server.obj

SRCS		= $(COBJS:.obj=.cpp) \
		  $(SOBJS:.obj=.cpp)

!include $(top_srcdir)/config/Make.rules.mak

ICECPPFLAGS	= -I. $(ICECPPFLAGS) -DWIN32_LEAN_AND_MEAN

CPPFLAGS	= -I. -I../../include $(CPPFLAGS) -WX

!if "$(OPTIMIZE_SPEED)" != "yes" & "$(OPTIMIZE_SIZE)" != "yes"
CPDBFLAGS        = /pdb:$(CLIENT:.exe=.pdb)
SPDBFLAGS        = /pdb:$(SERVER:.exe=.pdb)
!endif

$(CLIENT): $(COBJS)
	$(LINK) $(LDFLAGS) $(CPDBFLAGS) $(COBJS) /out:$@ $(TESTLIBS)

$(SERVER): $(SOBJS)
	$(LINK) $(LDFLAGS) $(SPDBFLAGS) $(SOBJS) /out:$@ $(TESTLIBS)

clean::
	del /q Test.cpp Test.h
	del /q ServerPrivate.cpp ServerPrivate.h

!include .depend

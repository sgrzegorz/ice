# **********************************************************************
#
# Copyright (c) 2003-2007 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ..\..\..

!if "$(SMART_DEVICE)" == ""
CLIENT		= client.exe
!endif
MFCCLIENT	= mfcclient.exe

!ifdef BUILD_MFC

TARGETS		= $(MFCCLIENT)

!else

TARGETS		= $(CLIENT)

!endif

OBJS		= Chat.obj \
		  PingThread.obj \
		  Router.obj \
		  Session.obj

COBJS		= Client.obj

MOBJS		= ChatClient.obj \
		  ChatClientDlg.obj \
		  ChatConfigDlg.obj \
		  LogI.obj \
		  stdafx.obj

SRCS		= $(OBJS:.obj=.cpp) \
		  $(COBJS:.obj=.cpp)

!include $(top_srcdir)/config/Make.rules.mak

SLICE2CPPEFLAGS = -I. --ice $(SLICE2CPPEFLAGS)

CPPFLAGS        = -I. $(CPPFLAGS) $(MFC_CPPFLAGS)
!ifdef BUILD_MFC
!if "$(SMART_DEVICE)" == "" | "$(STATICLIBS)" != "yes"
CPPFLAGS	= $(CPPFLAGS) -D_AFXDLL
!endif
!else
CPPFLAGS	= $(CPPFLAGS) -DWIN32_LEAN_AND_MEAN -WX
!endif

!if "$(OPTIMIZE_SPEED)" != "yes" & "$(OPTIMIZE_SIZE)" != "yes"
CPDBFLAGS        = /pdb:$(CLIENT:.exe=.pdb)
MPDBFLAGS        = /pdb:$(MFCCLIENT:.exe=.pdb)
!endif

!if "$(SMART_DEVICE)" == ""

$(CLIENT): $(OBJS) $(COBJS)
	$(LINK) $(LDFLAGS) $(CPDBFLAGS) $(OBJS) $(COBJS) /out:$@ $(LIBS)

RESFILE		= ChatClient.res
ChatClient.res: ChatClient.rc
	$(RC) ChatClient.rc

!else

$(CLIENT)::

RESFILE		= ChatClientCE.res
ChatClientCE.res: ChatClientCE.rc
	$(RC) ChatClientCE.rc

!endif

$(MFCCLIENT): $(OBJS) $(MOBJS) $(RESFILE)
	$(LINK) $(LDFLAGS) $(MFC_LDFLAGS) $(MPDBFLAGS) $(OBJS) $(MOBJS) $(RESFILE) /out:$@ $(LIBS)

!ifndef BUILD_MFC

clean::
	del /q Chat.cpp Chat.h
	del /q Router.cpp Router.h
	del /q Session.cpp Session.h
	del /q $(RESFILE)

!if "$(CPP_COMPILER)" != "VC80_EXPRESS"
$(EVERYTHING)::
	$(MAKE) -nologo /f Makefile.mak BUILD_MFC=1 $@
!endif

!endif

!include .depend

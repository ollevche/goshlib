LIBNAME	= libtime



WIN64CC	= x86_64-w64-mingw32-gcc
LINUXCC	= gcc



CLIB			= clib

CLIBF			= main
CLIBSRC			= $(addsuffix .c, $(addprefix $(CLIB)/, $(CLIBF)))

WIN64DIR		= $(CLIB)/win64
CLIBWIN64OBJ	= $(addsuffix .o, $(addprefix $(WIN64DIR)/, $(CLIBF)))

LINUXDIR		= $(CLIB)/linux
CLIBLINUXOBJ	= $(addsuffix .o, $(addprefix $(LINUXDIR)/, $(CLIBF)))



GOLIB		= golib
GOLIBF		= main
GOLIBSRC	= $(addsuffix .go, $(addprefix $(GOLIB)/, $(GOLIBF)))



APP		= app
APPF	= main
APPSRC	= $(addsuffix .c, $(addprefix $(APP)/, $(APPF)))
APPOBJ	= $(addsuffix .o, $(addprefix $(APP)/, $(APPF)))



all: $(CLIB)/$(LIBNAME).so usego run

win: $(CLIB)/$(LIBNAME).dll $(GOLIB)/$(LIBNAME).dll

$(CLIB)/$(LIBNAME).dll: $(CLIBWIN64OBJ)
	$(WIN64CC) -shared -lm -o $@ $(CLIBWIN64OBJ)

$(WIN64DIR)/%.o: $(CLIB)/%.c
	mkdir -p $(WIN64DIR)
	$(WIN64CC) -c -o $@ $<

$(CLIB)/$(LIBNAME).so: $(CLIBLINUXOBJ)
	$(LINUXCC) -shared -lm -o $@ $(CLIBLINUXOBJ)

$(LINUXDIR)/%.o: $(CLIB)/%.c
	mkdir -p $(LINUXDIR)
	$(LINUXCC) -c -o $@ $<

$(GOLIB)/$(LIBNAME).so:
	go build -o $@ -buildmode=c-shared $(GOLIBSRC)

$(GOLIB)/$(LIBNAME).dll:
	GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=$(WIN64CC) \
	go build -o $@ -buildmode=c-shared $(GOLIBSRC)

usec: $(CLIB)/$(LIBNAME).so
	cp $(CLIB)/$(LIBNAME).so $(APP)/

usego: $(GOLIB)/$(LIBNAME).so
	cp $(GOLIB)/$(LIBNAME).so $(APP)/

$(APP)/$(APP): $(APPOBJ)
	$(LINUXCC) -o $@ $(APPOBJ) -L$(APP)/ -I$(APP)/ -ltime

$(APP)/%.o: $(APP)/%.c
	$(LINUXCC) -c -o $@ $<

run: $(APP)/$(APP)
	@echo "Running $(APP)/$(APP)"
	@export LD_LIBRARY_PATH=./$(APP)/:$$LD_LIBRARY_PATH; ./$(APP)/$(APP)

clean:
	rm -rf $(WIN64DIR) $(LINUXDIR)
	rm -f $(APPOBJ)

fclean: clean
	rm -f $(CLIB)/$(LIBNAME).dll $(CLIB)/$(LIBNAME).so
	rm -f $(GOLIB)/$(LIBNAME).dll $(GOLIB)/$(LIBNAME).so $(GOLIB)/$(LIBNAME).h
	rm -f $(APP)/$(APP) $(APP)/$(LIBNAME).so

re: fclean all
